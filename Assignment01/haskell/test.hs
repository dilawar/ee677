-- Test script.
--
import qualified  Data.Set as Set 
import Data.Bits
import Data.List

data Bit = F | T | X deriving (Eq, Ord, Show)
type BitVector = [Bit] 


minus :: [BitVector] -> [BitVector] -> [BitVector]
minus [] _ = []
minus x [] = x
minus x (y:ys) = minus (filter(/= y) x) ys

-- Convert an integer to its minimal bit representation.
intToBitVector :: Integer -> BitVector
intToBitVector 0 = [F]
intToBitVector 1 = [T]
intToBitVector n = (intToBitVector (rem n 2)) ++ (intToBitVector (div n 2))

-- Convert an integer to a fixed length bit representation i.e. 2 = 0010 (length
-- = 4) rather than just 10 (minimal length).
intToBitVectorOfLength :: Integer -> Int -> BitVector
intToBitVectorOfLength num len 
    | (shiftL 1 len-1) < num = error "Number can't be represented in given bits."
    | otherwise = let x = length $ (intToBitVector num) in helper x num where 
                    helper x num 
                        | x >= len = intToBitVector num 
                        | otherwise = (intToBitVector num) ++ [F | y <- [1 .. (len - x)]]


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


-- Convert list of integers to a set of bit-vectors.
listToMinterms :: [Integer] -> Int -> Set.Set BitVector
listToMinterms [] n = Set.empty
listToMinterms (x:xs) n = Set.insert (intToBitVectorOfLength x n) (listToMinterms xs n)

listToUniqueMinterms x y = Set.toList $ listToMinterms x y

-- Before proceeding further, let's write a list of int terms for testing
-- purpose. 
intMinterms = [0,1,2,8,9,10,14,13,15]
--intMinterms = [0,1]
minterms = listToUniqueMinterms intMinterms 4

merge :: BitVector -> BitVector -> BitVector
merge [] _ = []
merge _ [] = []
merge (a:as) (b:bs) 
    | a == b = a : merge as  bs
    | a /= b = X : merge as bs
    | otherwise = error "Ooo.. Sticky situation."
 
-- Partitions the given minterms in such a way that each minterms has its
-- one-Hamming distance terms with it.
getHammingOneMergedTerms :: BitVector -> [BitVector] -> (BitVector, [BitVector])
getHammingOneMergedTerms x y = (x , mergedTerms x y)
    where 
        mergedTerms x [] = []
        mergedTerms x (y:ys) 
            | 1 == hammingDistance x y = merge x y : mergedTerms x ys
            | otherwise = mergedTerms x ys

-- Find marked and unmarked terms 
markedUnmarkedTerms :: BitVector -> [BitVector] -> (BitVector, ([BitVector], [BitVector]))
markedUnmarkedTerms x y = (x, (markedTerms x y, unmarkedTerms x y))
    where 
        markedTerms x y = l 
            -- | not . null $ l = x : l 
            -- | otherwise = l 
                where l = filter (\z -> 1 == hammingDistance x z) y
        unmarkedTerms x y = filter (\z -> 1 /= hammingDistance x z) y
    

partitionMinterms :: [BitVector] -> [(BitVector, [BitVector])]
partitionMinterms (x:[]) = []
partitionMinterms x = getHammingOneMergedTerms (head x) x : (partitionMinterms (tail x))

qmStep :: [BitVector] -> ([BitVector], [BitVector])
qmStep x = (collectMarked y, collectUnMarked y) where 
            y = partitionMinterms x

collectMarked p = nub $ foldr (++) [] (snd $ unzip p)
collectUnMarked p = nub $ foldr (\y -> (:) (fst y)) [] b where 
                            b = filter (\y-> null (snd y)) p

collectMarkedUnmarkedTerms [] = []
collectMarkedUnmarkedTerms x = markedUnmarkedTerms (head x) x : collectMarkedUnmarkedTerms (tail x)


---------------------

stepQM x = (nub $ mergedTerms p , minus x (nub $ markedTerms p)) 
    where 
        p = collectMarkedUnmarkedTerms x
        mergedTerms [] = []
        mergedTerms (p:ps) = map (\y -> merge (fst p) y) ( fst . snd $ p) ++ mergedTerms ps
        markedTerms [] = []
        markedTerms (p:ps) 
            | (not . null)  (fst . snd $ p) = (fst p) : (fst . snd $ p) ++ markedTerms ps 
            -- | null ps = (fst p) : markedTerms ps
            | otherwise = (fst . snd $ p) ++ markedTerms ps


