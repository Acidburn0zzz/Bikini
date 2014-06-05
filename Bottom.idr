module Bottom

import Effect.StdIO
import Effect.File

import Control.IOExcept
import Control.Eternal

import Lightyear.Core
import Lightyear.Combinators
import Lightyear.Strings

data BValue = BLet String
            | BIndent String
            | JustParse Char
               
instance Show BValue where
  show (BLet s)         = "auto "
  show (BIndent s)      = s
  show (JustParse c)    = let cc : List Char = [c]
                          in pack cc

bIndent' : Parser (List Char)
bIndent' = (char ' ' $!> pure Prelude.List.Nil) <|> do
  c <- satisfy (/= ' '); map (c ::) bIndent'

bIndent : Parser String
bIndent = string "    " $> map pack bIndent' <?> "BIndent"

parseWord' : Parser (List Char)
parseWord' = (char ' ' $!> pure Prelude.List.Nil) <|> do
  c <- satisfy (/= ' '); map (c ::) parseWord'

justParse : Parser Char
justParse = satisfy (const True) <?> "Whatever"

bParser : Parser BValue
bParser =  (map BLet $ string "let" $> map pack parseWord' <?> "bLet")
       <|> (map JustParse justParse)

bracketBuilder : String -> String
bracketBuilder noBra = do
    let lines   = splitOn '\n' $ unpack noBra
    let slines  = map pack lines
    let fld     = foldr1 (\a, b => do let ua = unpack a
                                      let len = length ua
                                      let la = length $ takeWhile (== ' ') ua
                                      let lb = length $ takeWhile (== ' ') $ unpack b
                                      let fa = length $ takeWhile (== '#') ua
                                      if len == 0 || fa > 0
                                        then (a ++ "\n" ++ b)
                                        else if la == lb
                                            then (a ++ ";\n" ++ b)
                                           else if la > lb then (a ++ ";\n}" ++ b)
                                                           else (a ++ " {\n" ++ b)
                                      ) slines
    fld

finalize : (List BValue) -> Bool -> String
finalize v bra = do
    let noBra = concat $ map show v
    if bra then bracketBuilder noBra
           else noBra

quest : (List String) -> Bool -> { [STDIO] } Eff IO ()
quest file bra = do
    let onestring = concat file
    putStrLn onestring
    putStrLn " >>> \n"
    case parse (some bParser) onestring of
      Left err => putStrLn $ "error: " ++ err
      Right v  => putStrLn $ finalize v bra

FileIO : Type -> Type -> Type
FileIO st t = { [FILE_IO st, STDIO] } Eff IO t 

readFile : FileIO (OpenFile Read) (List String)
readFile = readAcc [] where
  readAcc : List String -> FileIO (OpenFile Read) (List String)
  readAcc acc = if (not !eof) then readAcc $ !readLine :: acc
                              else return  $ reverse acc

compile : String -> FileIO () ()
compile f = do case !(open f Read) of
                True => do quest !readFile True
                           close {- =<< -}
                False => putStrLn ("Error!")
