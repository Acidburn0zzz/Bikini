module Syntax

import Control.IOExcept
import Control.Eternal

import Lightyear.Core
import Lightyear.Combinators
import Lightyear.Strings

import Helper

data BValue = BString String
            | BLet String
            | BMatch String
            | BMatchc String
            | BMatchd String
            | JustParse Char

caseProcess : Bool -> String -> String
caseProcess d s = do
    let sa   = unpack s
    let skp1 = 1 + (length $ takeWhile (== '[') sa)
    let cwd  = if d then "default "
                    else "case "
    let val1 = (unpack cwd) ++ (drop skp1 sa)
    let skp2 = length $ takeWhile (/= '=') val1
    let val2 = (take skp2 val1) ++ (unpack ": return ") ++ (drop (skp2 + 2) val1)
    (pack val2) ++ "\n"

instance Show BValue where
    show (BString s)    = show s
    show (BLet s)       = "auto "

    show (BMatch s)     = "[&]() { switch /* match */ "
    show (BMatchc s)    = caseProcess False s
    show (BMatchd s)    = caseProcess True s

    show (JustParse c)  = pack $ with List [c]

bString : Parser String
bString = char '"' $> map pack bString' <?> "Simple string"

bParser : Parser BValue
bParser =  (map BString bString)
       <|> (map BLet $ string "let" $> map pack parseWord' <?> "bLet")
       
       <|> (map BMatch  $ string "match"    $> map pack parseWord' <?> "bMatch")
       <|> (map BMatchc $ string "[=>"      $> map pack parseUntilLine <?> "bMatchc")
       <|> (map BMatchd $ string "[~>"      $> map pack parseUntilLine <?> "bMatchd")
       
       <|> (map JustParse justParse)