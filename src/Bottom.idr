module Bottom

import Effect.StdIO
import Effect.System
import Effect.File

import IOProcess

import Control.IOExcept
import Control.Eternal

bquestX : List String -> Bool -> String -> FileIO () ()
bquestX file bra cpf =
    case parse (some bParser) (concat file) of
      Left err => putStrLn $ "Error: " ++ err
      Right v  => let sln = splitLines $ finalize v bra
                  in save sln cpf

intercalateC : List String -> String
intercalateC [] = ""
intercalateC [x] = x
intercalateC (x :: xs) = x ++ "," ++ intercalateC xs

cleanUp : List String -> { [SYSTEM] } Eff ()
cleanUp [x]     = sys $ "rm -rf " ++ x
cleanUp (x::xs) = do sys $ "rm -rf " ++ x
                     cleanUp xs

bquestY : String -> List String -> { [SYSTEM] } Eff ()
bquestY f xs = let cpps = intercalateC $ filter (isSuffixOf "cpp") xs
               in do sys $ "g++ -I . -o " ++ f ++ " " ++ cpps ++ " -O3 -Wall -std=c++1y"
                     cleanUp xs

bcompileX : String -> String -> FileIO () ()
bcompileX f cpf = case !(open f Read) of
                      True  => do dat <- readFile
                                  close {- =<< -}
                                  bquestX dat True cpf
                      False => putStrLn ("file not found :" ++ f)

buildProject : List String -> List String -> FileIO () ()
buildProject [] _ = putStrLn "There is nothing to do"
buildProject [x] [] = putStrLn "No modules to compile"
buildProject [x] ys = do putStrLn $ "out: " ++ x
                         bquestY x ys
                         putStrLn "Done"
buildProject (x :: xs) ys = do putStr $ "compile: " ++ x
                               case rff # 1 of
                                Just f => let ext = case head' rff of
                                                Just "cxx"  => "cpp"
                                                Just "h"    => "hpp"
                                                _      => "WTF"
                                              cpf = f ++ "." ++ ext
                                          in do putStrLn $ " -> " ++ cpf
                                                bcompileX x cpf
                                                buildProject xs $ cpf :: ys
                                _ => do putStrLn "Error!"
                                        buildProject xs ys
  where rff : List String
        rff = reverse $ with String splitOn '.' x
