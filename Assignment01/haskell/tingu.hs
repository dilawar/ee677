import Quine
import System.Environment (getArgs)

test = quine [1,2,3] 2

main = do 
    args <- getArgs
    putStrLn $ show args
