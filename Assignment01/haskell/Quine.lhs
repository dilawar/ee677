\begin{code}
module Quine (quine, Bit(X,T,F), listToUniqueMinterms) where 
\end{code}
0 : Import needed libraries or write your own class.

    We define our data-type as T for (true), F (false) and X (don't care). We
    also 'derive' Equality on these data-types. Here is a sticky situtation.
    What we can say about following relation :
            is X == X ?
    This is a tricky situtation. We don't know what value X can take. There are four
    possibilities i.e. 0 == 1, 0 == 0, 1 == 0, 1 == 1. One can show that at
    least one of these does not have same answer. Thus answer to X == X can only
    be X. 

    Now we run into another trouble. By default, haskell have only True and
    False as valid values of predicate and allowing above mentioned comparisions
    will force us to write our own function. Can one take an easy way out of it?

    I believe we can. In our algorithm, we'll never compare equal terms. For
    example, we can not say anything about whether 011- >= 011- but we can say
    something about whether 011- >= 001-. Term 011- is always bigger than term
    001- despite the value  - might take.

    We must make sure that during the execution of our program, duplicate terms
    do not exists in any list. 

\begin{code}
import Data.List
import Data.Bits
import Test.QuickCheck
import qualified Data.Set as Set

-- 1 : T, 0 : F, X : Don't care
data Bit = F | T | X deriving (Eq, Ord, Show)
type BitVector = [Bit] 

-- For quickcheck
instance Arbitrary Bit where 
    arbitrary = elements [T,F] 
\end{code}

1. Helper functions 

    We also need a function which convert an integer to a list of bits. Where we
    should keep the LSB. I am keeping the LSB at head of the list.

        3 = 011 =  [1,1,0] => [T,T,F]
 
    We need another function which can convert the given minterms into the list
    of their equivalent bit representation of fixed length. We already have
    low-level function in our inventory. Let's use them to build this function.


\begin{code}

-- Convert an integer to its minimal bit representation.
intToBitVector :: Integer -> BitVector
intToBitVector 0 = [F]
intToBitVector 1 = [T]
intToBitVector n = (intToBitVector (rem n 2)) ++ (intToBitVector (div n 2))

-- Convert an integer to a fixed length bit representation i.e. 2 in 4 bit
-- representation is 0010 rather than just 10 (minimal length). Ofcourse, this 
-- is displayed as [F,F,T,F] (LSB first).
intToBitVectorOfLength :: Integer -> Int -> BitVector
intToBitVectorOfLength num len 
    | (shiftL 1 len-1) < num = error "Number can't be represented in given bits."
    | otherwise = let x = length $ (intToBitVector num) in helper x num where 
                    helper x num 
                        | x >= len = intToBitVector num 
                        | otherwise = (intToBitVector num) ++ [F | y <- [1 .. (len - x)]]

\end{code}


    What else is needed, We need a function which can tell us at how many
    places, two given minterms differs. What are their, ummm.. what they call
    it.. they have named it after that dude.. yes, the Hamming distance? 

\begin{code}
-- Given two minterms, compute their Hamming distance.
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

\end{code}

    
    We also need a function to substract one list from another.

\begin{code}
minus :: [BitVector] -> [BitVector] -> [BitVector]
minus [] _ = []
minus x [] = x
minus x (y:ys) = minus (filter(/= y) x) ys
\end{code}


    It is not neccessary that given list of integers does not have repetetive
    elements. Following function will take care of it.

\begin{code}
-- Convert list of integers to a set of bit-vectors.
listToMinterms :: [Integer] -> Int -> Set.Set BitVector
listToMinterms [] n = Set.empty
listToMinterms (x:xs) n = Set.insert (intToBitVectorOfLength x n) (listToMinterms xs n)

listToUniqueMinterms x y = Set.toList $ listToMinterms x y
\end{code}


2. Quine McClusky Method

    The basis operation in QM method is to combine two terms with Hamming
    distance 1. For example if 0110 and 0111 are combined then new term should
    be 011-. 
    
    Should we check if input to this function is valid. I think we should, who
    knows who can give this function what! But wait, this function is recursive
    and some properties are not invariant during recursion. So, unless we prove
    that particular property is invariant during recursion, we must not write
    them inside recursive function for testing purpose. Let's drop this idea be
    dumb for time being.

\begin{code}
 
merge :: BitVector -> BitVector -> BitVector
merge [] _ = []
merge _ [] = []
merge (a:as) (b:bs) 
    | a == b = a : merge as  bs
    | a /= b = X : merge as bs
    | otherwise = error "Ooo.. Sticky situation."
 
\end{code}

    What happens if a minterm in list does not have any companion in that list
    with hamming distance 1. We must include them in our final result.

\begin{code}

-- Find marked and unmarked terms 
markedUnmarkedTerms :: BitVector -> [BitVector] -> (BitVector, ([BitVector], [BitVector]))
markedUnmarkedTerms x y = (x, (markedTerms x y, unmarkedTerms x y))
    where 
        markedTerms x y = l 
            -- | not . null $ l = x : l 
            -- | otherwise = l 
                where l = filter (\z -> 1 == hammingDistance x z) y
        unmarkedTerms x y = filter (\z -> 1 /= hammingDistance x z) y
    

collectMarkedUnmarkedTerms [] = []
collectMarkedUnmarkedTerms x = markedUnmarkedTerms (head x) x : collectMarkedUnmarkedTerms (tail x)


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

qm [] = []
qm x = (snd $ stepQM x) ++ qm (fst $ stepQM x)

quine x n = qm (listToUniqueMinterms x n)

\end{code}
