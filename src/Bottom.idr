module Bottom

import Effect.StdIO
import Effect.System
import Effect.File

import IOProcess

import Control.IOExcept
import Control.Eternal

-- Compile to C++ and save
bquestX : List String -> Bool -> String -> FileIO () ()
bquestX file bra cpf =
    case parse (some bParser) (concat file) of
      Left err => putStrLn $ "Failed to parse: " ++ err
      Right v  => let sln = splitLines $ finalize v bra
                  in save sln cpf

-- coma intercalate
intercalateC : List String -> String
intercalateC [] = ""
intercalateC [x] = x
intercalateC (x :: xs) = x ++ "," ++ intercalateC xs

-- recursive rm -rf
cleanUp : List String -> { [SYSTEM] } Eff ()
cleanUp [x]     = sys $ "rm -rf " ++ x
cleanUp (x::xs) = do sys $ "rm -rf " ++ x
                     cleanUp xs

-- compile to executable
bquestY : String -> List String -> { [SYSTEM] } Eff ()
bquestY f xs = let cpps = intercalateC $ filter (isSuffixOf "cpp") xs
               in do sys $ "g++ -I . -o " ++ f ++ " " ++ cpps ++ " -O3 -Wall -std=c++1y"
                     cleanUp xs

-- just compile with -c flag
bquestYL : String -> List String -> { [SYSTEM] } Eff ()
bquestYL f xs = let cpps = intercalateC $ filter (isSuffixOf "cpp") xs
                in do sys $ "g++ -I . -c -o " ++ f ++ " " ++ cpps ++ " -O3 -Wall -std=c++1y"
                      cleanUp xs

-- Compile to C++ and save with bquestX
bcompileX : String -> String -> FileIO () ()
bcompileX f cpf = case !(open f Read) of
                      True  => do dat <- readFile
                                  close {- =<< -}
                                  bquestX dat True cpf
                      False => putStrLn ("File not found :" ++ f)

-- TODO: Set active compiler
setCpp : String -> IO() -- { [SYSTEM] } Eff ()
setCpp _ = putStrLn $ "Not implemented..."

-- Src compile w/o Effect!
srcCompileNoEffect : String -> String
srcCompileNoEffect x = 
    case rff # 1 of
        Just f => let ext = case head' rff of
                              Just "cxx"  => "cpp"
                              Just "h"    => "hpp"
                              _           => "WTF"
                  in f ++ "." ++ ext
        _ => ""
  where rff : List String
        rff = reverse $ with String splitOn '.' x

-- Building source Point
srcCompile : String -> FileIO () ()
srcCompile x = 
    case srcCompileNoEffect x of
        ""  => putStrLn "What?"
        cpf => do putStrLn $ " -> " ++ cpf
                  bcompileX x cpf

-- Building project Point
buildPoint : (Nat, String) -> List String -> FileIO () ()
buildPoint (t,x) m =
    case toIntegerNat t of
        0 => do putStr $ "src: " ++ x
                srcCompile x
        1 => do putStrLn $ "Compiler set to: " ++ x
        5 => do putStrLn $ "out: " ++ x
                bquestY x m
        6 => do bquestYL x m
        _ => do putStrLn "What!?"

-- Recursive project Build
buildProject : List (Nat, String) -> List String -> FileIO () ()
buildProject [] _               = putStrLn "There is nothing to do"
buildProject _ []               = putStrLn "No modules to compile"
buildProject [(t,x)] m          = buildPoint (t,x) m
buildProject ((t,x) :: xs) m    = do buildProject [(t,x)] m
                                     buildProject xs m
