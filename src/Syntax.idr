module Syntax

import public Helper
import public Control.IOExcept

import public Data.SortedMap

data BValue = BString String
            | BLet String
            | BInit (String, BValue)
            | BMatch String
            | BMatchc String
            | BMatchd String
            | JustParse Char

caseProcess : Bool -> String -> String
caseProcess d s =
    let sas  = unpack s
        skp1 = 1 + (length $ takeWhile (== '[') sas)
        cwd  = if d then "default "
                    else "case "
        val1 = (unpack cwd) ++ (drop skp1 sas)
        skp2 = length $ takeWhile (/= '=') val1
        val2 = (take skp2 val1) ++ (unpack ": return ") ++ (drop (skp2 + 2) val1)
    in (pack val2) ++ "\n"

instance Show BValue where
    show (BString s)    = show s
    show (BLet s)       = "const auto "
    show (BInit (k, v)) = "auto " ++ k ++ " =" ++ (show v) -- ++ "\n"

    show (BMatch s)     = "[&]() { switch /* match */ "
    show (BMatchc s)    = caseProcess False s
    show (BMatchd s)    = caseProcess True s

    show (JustParse c)  = pack $ with List [c]

bString : Parser String
bString = char '"' $> map pack bString' <?> "Simple string"

mutual
    bInit : Parser (String, BValue)
    bInit = do key <- map pack (many (satisfy $ not . isSpace)) <$ space
               val <- string "<-" $> bParser -- map pack parseUntilLine
               pure (key, val)

    bParser : Parser BValue
    bParser =  (map BString bString)
           <|> (map BLet $ string "let" <$ space $> map pack parseWord'' <?> "bLet")

           <|> (map BMatch  $ string "match"    $> map pack parseWord' <?> "bMatch")
           <|> (map BMatchc $ string "[=>"      $> map pack parseUntilLine <?> "bMatchc")
           <|> (map BMatchd $ string "[~>"      $> map pack parseUntilLine <?> "bMatchd")

           <|>| map BInit bInit
           <|>| map JustParse justParse
