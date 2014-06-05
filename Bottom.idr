module Bottom

import Effect.StdIO
import Effect.File

import Control.IOExcept
import Control.Eternal

import Lightyear.Core
import Lightyear.Combinators
import Lightyear.Strings

import Data.SortedMap

data BValue = BIndent String
            | JustParse Char
            | BArray (List BValue)
               
instance Show BValue where
  show (BIndent s)      = show s
  show (JustParse c)    = show c
  show (BArray  xs)     = show xs

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
    _    => satisfy (const False) <?> "expected special char"

bIndent' : Parser (List Char)
bIndent' = (char ' ' $!> pure Prelude.List.Nil) <|> do
  c <- satisfy (/= ' ')
  if (c == '\\') then map (::) specialChar <$> bIndent'
                 else map (c ::) bIndent'

bIndent : Parser String
bIndent = char ' ' $> map pack bIndent' <?> "BIndent"

justParse : Parser Char
justParse = satisfy (const True) <?> "Whatever"

bParser : Parser BValue
bParser =  (map BIndent bIndent)
       <|> (map JustParse justParse)
       
bArray : Parser (List BValue)
bArray = some bParser

quest : (List String) -> { [STDIO] } Eff IO ()
quest file = do
    let onestring = concat file
    putStrLn onestring
    putStrLn " >>> \n"
    case parse bArray onestring of
      Left err => putStrLn $ "error: " ++ err
      Right v  => putStrLn $ show v

FileIO : Type -> Type -> Type
FileIO st t = { [FILE_IO st, STDIO] } Eff IO t 

readFile : FileIO (OpenFile Read) (List String)
readFile = readAcc [] where
  readAcc : List String -> FileIO (OpenFile Read) (List String)
  readAcc acc = if (not !eof) then readAcc $ !readLine :: acc
                              else return  $ reverse acc

compile : String -> FileIO () ()
compile f = do case !(open f Read) of
                True => do quest !readFile
                           close {- =<< -}
                False => putStrLn ("Error!")
