-- Test script.
--

import Data.Set as Set 

data Bit = T | F | X deriving (Eq, Show)
type BitVector = [Bit]


-- Convert an integer to its minimal bit representation.
intToBitVector :: Integer -> BitVector
intToBitVector 0 = [F]
intToBitVector 1 = [T]
intToBitVector n = (intToBitVector (rem n 2)) ++ (intToBitVector (div n 2))

-- Convert an integer to a fixed length bit representation i.e. 2 = 0010 (length
-- = 4) rather than just 10 (minimal length).
intToBitVectorOfLength :: Integer -> Int -> BitVector
intToBitVectorOfLength num len 
    | 2 ^ len < num = error "Number can't be represented in given bits."
    | otherwise = let x = fromIntegral . length $ (intToBitVector num) in helper x num where 
                    helper x num 
                        | x >= num = intToBitVector num 
                        | otherwise = (intToBitVector num) ++ [F | y <- [1 .. (toInteger len - x)]]


hammingDistance :: BitVector -> BitVector -> Int
hammingDistance [] _ = 0 -- protection 
hammingDistance _ [] = 0 -- protection
hammingDistance (a:as) (b:bs)
    | length(a:as) /= length(b:bs) =  error "This is Hamming! You are giving me unequal lists :-/ "
    | otherwise = helper (a:as) (b:bs) 0 where 
                    helper [] _ n = n
                    helper (x:xs) (y:ys) count 
                        | x /= y = helper xs ys (count+1)
                        | otherwise = helper xs ys count



