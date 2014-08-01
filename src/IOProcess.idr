module IOProcess

import Effect.StdIO
import Effect.System
import Effect.File

import Lex

import Control.IOExcept
import Control.Eternal

FileIO : Type -> Type -> Type
FileIO st t = { [FILE_IO st, STDIO, SYSTEM] } Eff t 

sys : String -> { [SYSTEM] } Eff ()
sys ss = do system ss
            return ()

writeFile : (List String) -> { [FILE_IO (OpenFile Write)] } Eff ()
writeFile [] = return ()
writeFile (x :: xs) = do writeLine x
                         writeFile xs

save : (List String) -> String -> FileIO () ()
save ww f = case !(open f Write) of
                True  => do writeFile ww
                            close {- =<< -}
                False => putStrLn ("Error!")

quest : (List String) -> Bool -> { [STDIO] } Eff ()
quest file bra =
    let onestring = concat file
    in case parse (some bParser) onestring of
          Left err => putStrLn $ "error: " ++ err
          Right v  => putStrLn $ finalize v bra

questC : (List String) -> Bool -> String -> FileIO () ()
questC file bra fx =
    let onestring = concat file
    in case parse (some bParser) onestring of
      Left err => putStrLn $ ("error: " ++ err)
      Right v  => do let cpp = finalize v bra
                     let sln = splitLines cpp
                     let ffs = with String splitOn '.' fx
                     case ffs # 0 of
                        Just f => do let cpf = (f ++ ".cpp")
                                     let exf = (f ++ ".exe")
                                     save sln cpf
                                     sys $ "g++ -o " ++ exf ++ " " ++ cpf ++ " -O3 -Wall -std=c++1y"
                                     sys $ "rm -f " ++ cpf
                        _ => putStrLn ("Error!")

readFile : FileIO (OpenFile Read) (List String)
readFile = readAcc [] where
  readAcc : List String -> FileIO (OpenFile Read) (List String)
  readAcc acc = if (not !eof) then readAcc $ !readLine :: acc
                              else return  $ reverse acc
