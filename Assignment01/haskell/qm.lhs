-1 : Import needed libraries or write your own class.

\begin{code}
-- 1 : T, 0 : F, X : Don't care
data Bits = T | F | X deriving (Eq, Show) 
\end{code}

0. Data to used throughout the program.

\begin{code}
minterms :: [Int]
minterms = [0,1,2,8,9,10,13,14,15]
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
                    helper [] _ count = count
                    helper _ [] count = count
                    helper (x:xs) (y:ys) count 
                        | x /= y = helper xs ys (count+1)
                        | otherwise = helper xs ys count 
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

combineHammingOne :: [Bits] -> [[Bits]] -> [[Bits]]
combineHammingOne x xs = map (\y -> combine x y) (findHammingOne x xs)

stepQM [] = []
stepQM (x:[]) = []
stepQM (x:xs) = (combineHammingOne x xs) ++ (stepQM xs)

qm :: [[Bits]] -> [[Bits]]
qm [] = []
qm (x:xs) = stepQM (x:xs) ++ qm (stepQM (x:xs))
\end{code}
