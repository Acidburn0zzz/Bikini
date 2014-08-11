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
      Right v  => do let cpp = finalize v bra
                     let sln = splitLines cpp
                     save sln cpf

intercalateC : List String -> String
intercalateC [] = ""
intercalateC [x] = x
intercalateC (x :: xs) = x ++ "," ++ intercalateC xs

cleanUp : List String -> { [SYSTEM] } Eff ()
cleanUp [x]     = sys $ "rm -rf " ++ x
cleanUp (x::xs) = do sys $ "rm -rf " ++ x
                     cleanUp xs

bquestY : String -> List String -> { [SYSTEM] } Eff ()
bquestY f xs = do let cpps = intercalateC $ filter (isSuffixOf "cpp") xs
                  sys $ "g++ -I . -o " ++ f ++ " " ++ cpps ++ " -O3 -Wall -std=c++1y"
                  cleanUp xs

bcompileX : String -> String -> FileIO () ()
bcompileX f cpf = do case !(open f Read) of
                      True  => do dat <- readFile
                                  close {- =<< -}
                                  bquestX dat True cpf
                      False => putStrLn ("Error!")

buildProject : List String -> List String -> FileIO () ()
buildProject [] _ = putStrLn "There is nothing to do"
buildProject [x] [] = putStrLn "No modules to compile"
buildProject [x] ys = do putStrLn $ "out: " ++ x
                         bquestY x ys
                         putStrLn "Done"
buildProject (x :: xs) ys = do putStr $ "compile: " ++ x
                               let ffs = with String splitOn '.' x
                               let rff = reverse ffs
                               {- DAMN IDRIS BUG !!!
                               let ext = case head' rff of
                                            Just "cxx"  => "cpp"
                                            Just "h"    => "hpp"
                                            Just ex     => ex
                                            Nothing     => "WTF"
                                            -}
                               let Just JJ = head' rff
                               let ext = if JJ == "cxx" 
                                            then "cpp"
                                            else if JJ == "h"
                                                    then "hpp"
                                                    else "WTF"
                               case rff # 1 of
                                Just f => do let cpf = f ++ "." ++ ext
                                             putStrLn $ " -> " ++ cpf
                                             bcompileX x cpf
                                             buildProject xs $ cpf :: ys
                                _ => do putStrLn "Error!"
                                        buildProject xs ys
