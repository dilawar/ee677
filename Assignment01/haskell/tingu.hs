import Quine
import System.Environment (getArgs)
import System.Console.GetOpt
import Text.ParserCombinators.Parsec
import Data.Maybe  (fromMaybe)
import Test.QuickCheck

data Flag = Version | Input String | Output String deriving Show

options :: [OptDescr Flag]
options = [
    Option ['V'] ["version"] (NoArg Version) "show version number"
    , Option ['i'] ["input"] (ReqArg Input "FILE") "Some option that require a file arguments"
    ]

makeOutput :: Maybe String -> Flag 
makeOutput ms = Output (fromMaybe "stdin" ms)

header = "Usage : ./tingu [OPTIONS ...]"

processArgs :: [Flag] -> IO ()
processArgs x = do 
    case length x of 
        1 -> computeMinimalForm x 


-- Write the parser here.

--minterms = endBy line eol 
--line = ((string "vars") <|> (string "minterms")) >> spaces >> char '=' >> spaces >> many1 (char ',' <|> digit)
minterms = endBy line eol 
line = varline <|> termsline
varline = ((string "vars") >> spaces >> char '=' >> spaces) >>  (many1 digit)
termsline = ((string "minterms") >> spaces >> char '=' >> spaces) >> many1 (char ',' <|> digit)
eol = (string "\n" <|> string "\n\r")
terms = endBy (many1 digit) (char ',')


printMinterm [] = ""
printMinterm (x:xs) = (map (\y -> case y of 
                                    T -> '1'
                                    F -> '0'
                                    X -> '-') x) ++"\n"++printMinterm xs

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
                            putStrLn "** I have found the minimal representation of your function."
                            putStrLn $ printMinterm  m
                            putStrLn "** Verifying my answers. It may take some time.... "
                            verifyResult m terms var
                            putStrLn "Peace!!"
                          
-- This function verify if result is correct 
verifyResult m terms var 
    = quickCheck $ ( prop_equality :: [Bit] -> Bool ) where 
            prop_equality x = applyInputToSOP m (take var x) == applyInputToSOP (listToUniqueMinterms terms var) (take var x)

applyInputToATerm [] _ = True
applyInputToATerm _ [] = True
applyInputToATerm (x:xs) (y:ys) 
    | x == X = applyInputToATerm xs ys
    | x == y = applyInputToATerm xs ys 
    | otherwise = False

-- This function apply input to a SOP and return True if input
-- satisfies it.
applyInputToSOP x input = or $ map (\y -> applyInputToATerm y input) x


getMinterms (x:y) = do 
    print (x)
    case (parse terms "(unknown)" (concat y)) of 
        Left e -> do putStrLn "Error parsing minterms : "
                     print e 
        Right r -> do 
                    return r
                    putStrLn ""

welcome = "\n"++
          "\nHello, I am Tingu, the mighty crab! And I like tea. " ++
          "\nYou should call me "++
          " $./tingu -i filename "++
          " from your terminal.\n"
main = do 
    putStrLn welcome 
    args <- getArgs
    case getOpt RequireOrder options args of 
        (flags, [], [] ) -> processArgs flags
        (_, nonOpts, []) -> error $ "unrecognised arguments : " ++ unwords nonOpts
        (_,     _,   msgs) -> error $ concat msgs ++ usageInfo header options 


