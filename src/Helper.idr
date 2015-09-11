module Helper

import public Lightyear.Core
import public Lightyear.Combinators
import public Lightyear.Strings

import public Control.Eternal
import public Unicode

natToInt : (ℕ) → ℤ
natToInt Z = 0
natToInt (S k) = 1 + (natToInt k)

intToNat : (ℤ) → ℕ
in' : Bool → (ℕ) → (ℤ) → ℕ
in' True n i = n
in' False n i = S (intToNat (i-1))
intToNat n = in' (n <= 0) Z n

splitLines : String → (List String)
splitLines s = splitOn '\n' s

hex : Parser ℤ
hex = do
    c <- (ord . toUpper) ∰ satisfy isHexDigit
    pure $ if (c ≥ ord '0') ∧ (c ≤ ord '9') then c - ord '0'
                                            else 10 + c - ord 'A'

hexQuad : Parser ℤ
hexQuad = do
    a <- hex
    b <- hex
    c <- hex
    d <- hex
    pure $ a × 4096 + b × 256 + c × 16 + d

specialChar : Parser Char
specialChar = do
    c <- satisfy (const True)
    case c of
        '"'  => pure '"'
        '\\' => pure '\\'
        '/'  => pure '/'
        'b'  => pure '\b'
        'f'  => pure '\f'
        'n'  => pure '\n'
        'r'  => pure '\r'
        't'  => pure '\t'
        'u'  => map chr hexQuad
        _    => satisfy (const False) <?> "expected special char"

justParse : Parser Char
justParse = satisfy (const True) <?> "Whatever"

bString' : Parser (List Char)
bString' = (char '"' *!> pure Prelude.List.Nil) <|> do
    c <- satisfy (/= '"')
    if (c ≡ '\\') then map (::) specialChar <*> bString'
                  else map (c ::) bString'

parseWord' : Parser (List Char)
parseWord' = (space *!> pure Prelude.List.Nil) <|> do
    c <- satisfy (/= ' '); map (c ::) parseWord'

parseWord'' : Parser (List Char)
parseWord'' = (pure Prelude.List.Nil) <|> do
    c <- satisfy (/= ' '); map (c ::) parseWord'

parseUntilLine : Parser (List Char)
parseUntilLine = (char '\n' *!> pure Prelude.List.Nil) <|> do
    c <- satisfy (/= '\n'); map (c ::) parseUntilLine
