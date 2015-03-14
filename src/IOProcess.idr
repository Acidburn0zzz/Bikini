module IOProcess

import public Effects
import public Effect.StdIO
import public Effect.System
import public Effect.File

import public Lex

FileIO : Type → Type → Type
FileIO st t = { [FILE_IO st, STDIO, SYSTEM] } Eff t 

-- system w/o return
sys : String → { [SYSTEM] } Eff ()
sys ss = do system ss
            return ()

-- Recursive writeLine
writeFile : (List String) → { [FILE_IO (OpenFile Write)] } Eff ()
writeFile [] = return ()
writeFile (x :: xs) = do writeLine x
                         writeFile xs

-- List String => FileIO
save : (List String) → String → FileIO () ()
save ww f = case !(open f Write) of
                True  => do writeFile ww
                            close {- =<< -}
                False => putStrLn $ "Error writing file!" ⧺ f

-- Compile to C++
bikini : (List String) → Bool → { [STDIO] } Eff ()
bikini file bra =
    case parse (some bParser) onestring of
          Left err => putStrLn $ "Parsing Error: " ⧺ err
          Right v  => putStrLn $ finalize v bra
  where onestring : String
        onestring = concat file

-- [DEPRECATED] Fast compile simple C⧺ code to exe
questC : (List String) → Bool → String → FileIO () ()
questC file bra fx =
    case parse (some bParser) onestring of
      Left err => putStrLn $ ("Parsing Error: " ⧺ err)
      Right v  => let sln = splitLines $ finalize v bra
                      ffs = with String splitOn '.' fx
                  in case ffs ‼ 0 of
                        Just f => do let cpf = f ⧺ ".cpp"
                                     let exf = f ⧺ ".exe"
                                     save sln cpf
                                     sys $ "g++ -o " ⧺ exf ⧺ " " ⧺ cpf ⧺ " -O3 -Wall -std=c++1y"
                                     sys $ "rm -f " ⧺ cpf
                        _ => putStrLn ("Error!")
  where onestring : String
        onestring = concat file

-- FileIO => List String
readFile : FileIO (OpenFile Read) (List String)
readFile = readAcc [] where
  readAcc : List String -> FileIO (OpenFile Read) (List String)
  readAcc acc = if (not !eof) then readAcc $ !readLine :: acc
                              else return  $ reverse acc
