-1 : Import needed libraries or write your own class.

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
import Data.List -- For intersect 
import Debug.Trace

-- 1 : T, 0 : F, X : Don't care
data Bits = T | F | X deriving (Eq, Show) 
\end{code}

0. Data to used throughout the program.

\begin{code}
minterms :: [Int]
minterms = [0,1,2,8,9,10,13,14,15] -- Example from Somenzi and Satchel (or Hatchel)
\end{code}


1. Helper functions 

    Let's have minterms in a list. We should also write a function which
    displays a number in its binary representation. Fortunately such a function
    is available in stadard library.


    We also need a function which convert an integer to a list of bits. Where we
    should keep the LSB. I am keeping the LSB at head of the list.

        3 = 011 =  [1,1,0]

\begin{code}

-- This function simply converts a integer into its bits representation
intToBinList :: Int  -> [Bits]
intToBinList 0 = [F]
intToBinList 1 = [T]
intToBinList n = (intToBinList (rem n 2)) ++ (intToBinList (div n 2))

-- This function converts an integer to a list Bits of given length len. If len
-- is not sufficient then it raises an error and program terminates. If len is 
-- larger than the minumum possible bits required to represent num, it appends
-- the result with 0's. Keep in mind that head of list is LSB.

intToBinListOfLength :: Int -> Int -> [Bits]
intToBinListOfLength num len 
    | 2^len < num = error "Number can not represented in given number of bits"
    | otherwise = let x = length(intToBinList num) in helper x num where
                   helper x num 
                        | x >= len = intToBinList num 
                        | otherwise = (intToBinList num) ++ [F | y <- [1 .. (len-x)] ]                         

\end{code}

    Oklie Doklie! We are good to proceed. We need another function which can
    convert the given minterms into the list of their equivalent bit
    representation of fixed length. We already have low-level function in our
    inventory. Let's use them to build this function.

\begin{code}

minTermsToBitLists :: [Int] -> Int -> [[Bits]]
minTermsToBitLists minterms len = map (\x -> intToBinListOfLength x len) minterms

\end{code}

    What else is needed, We need a function which can tell us at how many
    places, two given minterms differs. What are their, ummm.. what they call
    it.. they have named it after that dude.. yes, the Hamming distance? 

\begin{code}
-- Given two minterms, compute their Hamming distance.
hammingDistance ::  [Bits] -> [Bits] -> Int 
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

    No less important is a step where we add an element to a list which already
    contains that element. We must not add a element if present.

\begin{code}
cons :: [Bits] -> [[Bits]] -> [[Bits]]
cons [] y = y
cons x y
    | null (filter (==x) y) = x:y
    | otherwise = y

\end{code}

    And how about substracting two lists. We might need it.

\begin{code}
substractL :: [[[Bits]]] -> [[Bits]]
substractL (x:xs) 
    = subs x (foldr (++) [] xs) where
      subs x [] = x
      subs [] y = []
      subs x (y:ys) = subs (filter (/=y) x) ys
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
combine :: [Bits] -> [Bits] -> [Bits]
combine [] _ = []
combine _ [] = []
combine (a:as) (b:bs) 
    | a == b = a : combine as  bs
    | a /= b = X : combine as bs
    | otherwise = error "Ooo.. Sticky situation."
    
listMinterms = minTermsToBitLists minterms 4
testCombine = combine [F, F, T] [F, T, T]
\end{code}

    What happens if a minterm in list does not have any companion in that list
    with hamming distance 1. We must include them in our final result.

\begin{code}

findHammingOne :: [Bits] -> [[Bits]] -> [[Bits]]
findHammingOne a bs = filter (\y -> 1 == hammingDistance a y) bs

-- Find all terms in a list with hamming distance n, and those terms which are
-- not. Return a pair of lists.
findTermsWithHammingDistanceN :: [Bits] -> Int -> [[Bits]] -> ([[Bits]], [[Bits]])
findTermsWithHammingDistanceN [] _ _ = error "Empty list in first argument."
findTermsWithHammingDistanceN x _ [] = ([], [])
findTermsWithHammingDistanceN x 0 xs = (xs, [])
findTermsWithHammingDistanceN x n (y:ys)
    | n == hammingDistance x y = (cons y (fst (findTermsWithHammingDistanceN x n
                                    ys)), snd ( findTermsWithHammingDistanceN x n ys))
    | otherwise = ( fst (findTermsWithHammingDistanceN x n ys), cons y (snd
                    (findTermsWithHammingDistanceN x n ys)))


-- TODO : Write a test for following property. 
-- Property length (fst result) + length (snd result) == length input 


-- This function is slightly different from the previous one. If there is no
-- match for x in xs, then x also belong to snd of result.
findTermsWithHammingDistanceOne x y 
    | null (fst result) = (fst result, (x:(snd result)))
    | otherwise = result 
    where 
        result = findTermsWithHammingDistanceN x 1 y


combineHammingOne :: [Bits] -> [[Bits]] -> ([[Bits]], [[Bits]])
combineHammingOne x xs 
    = (map (\y -> combine x y) (fst (findTermsWithHammingDistanceOne x xs))
        , snd (findTermsWithHammingDistanceOne x xs))

stepQM :: [[Bits]] -> ([[Bits]], [[[Bits]]])
stepQM [] = ([], [[]])
stepQM (x:xs) 
    = (fst (combineHammingOne x xs) `union` fst (stepQM xs)
        , (snd (combineHammingOne x xs) : (snd (stepQM xs))))

qm :: [[Bits]] -> [[Bits]]
qm [] = []
qm x = substractL (snd (stepQM x)) ++ qm (fst (stepQM x))
--
\end{code}
