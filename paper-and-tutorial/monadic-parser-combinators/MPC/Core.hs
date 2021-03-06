module MPC.Core
where

import Control.Monad
import Data.Char
import Data.Maybe

newtype Parser a = Parser
    { runParser :: String -> [(a,String)]
    }

-- >>>> 2.2 primitive parsers

-- return `v` without consuming anything
result :: a -> Parser a
result v = Parser $ \inp -> [(v,inp)]

-- always fails
zero :: Parser a
zero = --Parser $ \inp -> []
    Parser $ const []

-- consume the first char, fail if this is impossible
item :: Parser Char
item = Parser $ \inp ->
    case inp of
         []     -> []
         (x:xs) -> [(x,xs)]

-- >>>> 2.3 parser combinators
instance Monad Parser where
    return = result
    m >>= f = Parser $ \inp -> do
        -- apply m on inp, which yields (v, inp')
        (v,inp') <- runParser m inp
        -- apply f on v, which ylelds next parser
        -- run parser on the unconsumned parts inp'
        runParser (f v) inp'

-- consume and test if the first character satisfies
--   a predicate
sat :: (Char -> Bool) -> Parser Char
sat p = do
    x <- item
    guard $ p x
    return x

-- consume an exact `x`
char :: Char -> Parser Char
char x = sat (\y -> x == y)

-- test if an Ord is within a given range
inBetween :: (Ord a) => a -> a -> a -> Bool
inBetween a b v = a <= v && v <= b

-- consume a digit
digit :: Parser Char
digit = sat $ inBetween '0' '9'

-- consume a lower case char
lower :: Parser Char
lower = sat $ inBetween 'a' 'z'

-- consume a upper case char
upper :: Parser Char
upper = sat $ inBetween 'A' 'Z'

-- use p and q to parse the same string
--   return all possibilities
plus :: Parser a -> Parser a -> Parser a
p `plus` q = Parser $ \inp ->
    runParser p inp ++ runParser q inp

-- consume letters (i.e. lower / upper)
letter :: Parser Char
letter = lower `plus` upper

-- consume alphanum (i.e. letter / digit)
alphanum :: Parser Char
alphanum = letter `plus` digit

-- consume a word (i.e. consecutive letters)
word :: Parser String
{-
-- impl #1
word = newWord `plus` result ""
    where
        newWord = do
            x <- letter
            xs <- word
            return (x:xs)
-}
-- impl #2
word = many letter

-- we have MonadPlus here
--   and I think this is equivalent to 
--   "MonadOPlus" in the paper
instance MonadPlus Parser where
    mzero = zero
    mplus = plus

-- consume a string from input
string :: String -> Parser String
string ""     = return ""
string (x:xs) = do
    char x
    string xs
    return (x:xs)

-- >>>> 4.1 simple repetition
-- consume some chars recognized by `p`
-- refactor: `many` and `many1` can be defined muturally recursively.
many :: Parser a -> Parser [a]
{-
-- impl #1
many p = many1 p `plus` return []
-}
-- impl #2
many p = force $ orEmpty $ many1 p

-- identifiers are lower-case letter followed by
--   zero or more alphanum
ident :: Parser String
ident = do
    x <- lower
    xs <- many alphanum
    return (x:xs)

-- same as `many`, but this time we don't produce extra empty seq
many1 :: Parser a -> Parser [a]
many1 p = do
    x <- p
    xs <- many p
    return (x:xs)

-- convert string to int, please make sure `(not $ null xs)`
stringToInt :: String -> Int
stringToInt xs = foldl1 merge $ map digitToInt xs
    where
        merge a i = a * 10 + i

-- recognize a natural number
nat :: Parser Int
{-
-- impl #1
nat = do
    xs <- many1 digit
    return $ stringToInt xs
-}
-- impl #2
nat = liftM digitToInt digit `chainl1` return merge
    where
        merge a i = a * 10 + i

-- recognize integers (i.e. positive, zero, negative)
int :: Parser Int
int = do
    f <- op
    n <- nat
    return $ f n
    where
        -- either apply a `negate` if `-` is present
        -- or keep it unchanged (by applying `id`)
        --   if '-' is recognized, we will have two functions here
        --   but that is not a problem, because `nat` won't recognize
        --   anything that begin with a '-'
        op = (char '-' >> return negate) `plus` return id

-- >>>> 4.2 repetition with separators

-- recognize a list of integers
ints :: Parser [Int]
{-
-- impl #1
ints = do
    char '['
    -- begins with an int
    n <- int
    -- followed by arbitrary number of ','+int
    ns <- many (char ',' >> int)
    char ']'
    return (n:ns)
-}
{-
-- impl #2
ints = do
    char '['
    xs <- int `sepby1` char ','
    char ']'
    return xs
-}
-- impl #3
ints = bracket (char '[')
               (int `sepby1` char ',')
               (char ']')

-- recognize pattern of `p` `sep` `p` `sep` `p` ...
sepby1 :: Parser a -> Parser b -> Parser [a]
p `sepby1` sep = do
    x <- p
    xs <- many (sep >> p)
    return (x:xs)

-- recognize `open` `p` `close`
bracket open p close = do 
    open
    xs <- p
    close
    return xs

-- parse something or return empty
orEmpty :: Parser [a] -> Parser [a]
orEmpty p = p `plus` return []

-- same as `sepby1`, allow empty result
sepby :: Parser a -> Parser b -> Parser [a]
p `sepby` sep = orEmpty $ p `sepby1` sep

-- >>>> 4.3 repetition with meaningful separators

-- take `factor` and `op`, consume non-empty seq
--   operator should be left associative
chainl1 :: Parser a -> Parser (a -> a -> a) -> Parser a
{-
-- impl #1
p `chainl1` op = do
    x <- p
    fys <- many $ do
            f <- op
            y <- p
            return (f,y)
    return $ foldl
        (\x (op,y) -> x `op` y)
        x
        fys
-}
-- impl #2
-- parse first element by `p`
-- parse rest of it by `rest`
p `chainl1` op = p >>= rest
    where
        rest x = (do
            f <- op
            y <- p
            -- parse and get `f` and `y`
            -- do the calculate and keep going recursively
            rest (x `f` y))
            -- or we just stop here
            `plus` return x


chainr1 :: Parser a -> Parser (a -> a -> a) -> Parser a
-- first parse a single p
p `chainr1` op = p >>= rest
    where
        rest x = (do
            -- parse op and parse the rest part recursively
            f <- op
            y <- p `chainr1` op
            -- combine result
            return $ x `f` y)
            -- or do nothing
            `plus` return x

-- take as argument a list of pairs
--   whose `fst` is a parser that recognize some string of type `a`
--   and `snd` is the corresponding result
--   this function produces a parser that try to parse something
--   of type `a` in parallel and return all possible `b`s
ops :: [(Parser a, b)] -> Parser b
ops xs = foldr1 plus [ p >> return op | (p,op) <- xs]

-- allows consuming nothing
chainl :: Parser a -> Parser (a -> a -> a) -> a -> Parser a
chainr :: Parser a -> Parser (a -> a -> a) -> a -> Parser a

chainl p op v = (p `chainl1` op) `plus` return v
chainr p op v = (p `chainr1` op) `plus` return v

-- force the first result of a parser, increase laziness
force :: Parser a -> Parser a
force p = Parser $ \inp ->
    let x = runParser p inp in
    head x : tail x

-- only return the first result from a parser
first :: Parser a -> Parser a
{-
-- impl #1
-- problem: `take 1 xxx` might unfold to some `take 0 xs`
--   we know that its safe to abort `xs` now
first p = Parser $ \inp -> take 1 $ runParser p inp 
-}
-- impl #2
first p = Parser $ \inp ->
    case runParser p inp of
        [] -> []
        (x:_) -> [x]

-- `g` is a binary, after `g x y`, we apply `f`
(.:) :: (c -> d) -> (a -> b -> c) -> (a -> b -> d)
(f .: g) x y = f (g x y)

-- lazy `plus`, if the first one succeeds,
--   the second one never get evaluated
(+++) :: Parser a -> Parser a -> Parser a
(+++) = first .: plus
