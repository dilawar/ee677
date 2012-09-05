import Quine
import System.Environment (getArgs)
import System.Console.GetOpt
import Text.ParserCombinators.Parsec
import Data.Maybe  (fromMaybe)
import Test.QuickCheck

test = quine [1,2,3] 2

data Flag = Version | Input String | Output String deriving Show

options :: [OptDescr Flag]
options = [
    Option ['V'] ["version"] (NoArg Version) "show version number"
    , Option ['i'] ["input"] (ReqArg Input "FILE") "Some option that require a file arguments"
    , Option ['o'] ["output"] (OptArg makeOutput "FILE") "some option with an optional file argument"
    ]

makeOutput :: Maybe String -> Flag 
makeOutput ms = Output (fromMaybe "stdin" ms)

header = "Usage : ./tingu [OPTIONS ...]"

processArgs :: [Flag] -> IO ()
processArgs x = do 
    case length x of 
        1 -> computeMinimalForm x 
       -- 2 -> compareTwoFiles x 


-- Write the parser here.

--minterms = endBy line eol 
--line = ((string "vars") <|> (string "minterms")) >> spaces >> char '=' >> spaces >> many1 (char ',' <|> digit)
minterms = endBy line eol 
line = varline <|> termsline
varline = ((string "vars") >> spaces >> char '=' >> spaces) >>  (many1 digit)
termsline = ((string "minterms") >> spaces >> char '=' >> spaces) >> many1 (char ',' <|> digit)
eol = (string "\n" <|> string "\n\r")
terms = endBy (many1 digit) (char ',')

computeMinimalForm :: [Flag] -> IO ()
computeMinimalForm x = do 
    file <- readFile ((\(Input y) -> y) (head x))
    case parse minterms "(unknown)" file of 
        Left e -> do putStrLn "Error parsing input : "
                     print e 
        Right r -> do 
            let var = read (head r) :: Int
            let t = head (tail r)
            case parse terms "(unknown)" t of
                Left e -> do 
                            print "Error parsing minterms. Make sure each term is ended by ,"
                            print e
                Right r -> do 
                            let terms = map (\y -> read y :: Integer) r
                            let m = quine terms var
                            putStrLn "I have found the minimal representation."
                            print m
                          
    

getMinterms (x:y) = do 
    print (x)
    case (parse terms "(unknown)" (concat y)) of 
        Left e -> do putStrLn "Error parsing minterms : "
                     print e 
        Right r -> do 
                    return r
                    putStrLn ""

main = do 
    args <- getArgs
    case getOpt RequireOrder options args of 
        (flags, [], [] ) -> processArgs flags
        (_, nonOpts, []) -> error $ "unrecognised arguments : " ++ unwords nonOpts
        (_,     _,   msgs) -> error $ concat msgs ++ usageInfo header options 


