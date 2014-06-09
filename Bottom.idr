module Bottom

import Effect.StdIO
import Effect.File

import Top

import Control.IOExcept
import Control.Eternal

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
