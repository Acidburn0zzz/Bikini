module Bottom

import Effect.StdIO
import Effect.File

import Control.IOExcept
import Control.Eternal

import Lightyear.Core
import Lightyear.Combinators
import Lightyear.Strings

data BValue = BLet String
            | JustParse Char
               
instance Show BValue where
  show (BLet s)         = "auto "
  show (JustParse c)    = pack $ with List [c]

parseWord' : Parser (List Char)
parseWord' = (char ' ' $!> pure Prelude.List.Nil) <|> do
  c <- satisfy (/= ' '); map (c ::) parseWord'

justParse : Parser Char
justParse = satisfy (const True) <?> "Whatever"

bParser : Parser BValue
bParser =  (map BLet $ string "let" $> map pack parseWord' <?> "bLet")
       <|> (map JustParse justParse)
       
splitLines : String -> List String
splitLines s = map pack $ splitOn '\n' $ unpack s

complete : String -> String -> String
complete a b = do
    let ua  = unpack a
    let la  = length $ takeWhile (== ' ') ua
    let lb  = length $ takeWhile (== ' ') $ unpack b
    let fa  = length $ takeWhile (== '#') ua
    let len = length $ drop la ua
    if len == 0 || fa > 0
        then (a ++ "\n" ++ b)
        else if la == lb
                then (a ++ ";\n" ++ b)
                else if la > lb then let rpl     = pack $ with List replicate lb ' '
                                     in (a ++ ";\n" ++ rpl ++ "}\n" ++ b)
                                else (a ++ " {\n" ++ b)

copenclose : String -> (Nat, Nat, String)
copenclose a = do
    let ua  = unpack a
    let op : List Char = ['{']
    if isSuffixOf op ua
        then let sz = length $ takeWhile (== ' ') ua
             in (sz, 2, a)
        else let cl : List Char = ['}']
             in if isSuffixOf cl ua
                    then let sz = length $ takeWhile (== ' ') ua
                         in (sz, 1, a)
                    else (0, 0, a)

complete2 : (Nat, Nat, String) -> (Nat, Nat, String) -> (Nat, Nat, String)
complete2 (oa, ca, a) (ob, cb, b) = do
    if ca == 2
        then if cb == 1 && oa == ob
                then (ob, 0, (a ++ "\n!!!" ++ b))
                else (ob, 2, (a ++ "\n???" ++ b))
        else (ob, cb, (a ++ "\n" ++ b))

bracketBuilder : String -> String
bracketBuilder noBra = do
    let slines  = splitLines noBra
    let foldred = foldr1 complete slines
    let mapopen = map copenclose (splitLines foldred)
    let (_, _, brC) = foldl1 complete2 mapopen
    "#pragma once\n#include \"lib/Bikini.h\"\n" ++ brC

finalize : (List BValue) -> Bool -> String
finalize v bra = do
    let noBra = concat $ map show v
    if bra then bracketBuilder noBra
           else noBra

quest : (List String) -> Bool -> { [STDIO] } Eff IO ()
quest file bra = do
    let onestring = concat file
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
