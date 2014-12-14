module Main

import Top
import System

version : String
version = "0.0.7"

showVersion : IO ()
showVersion = putStrLn $ "Bikini v." ++ version

help : IO ()
help = do
    showVersion
    putStrLn "-v / --version:\t Display version"
    putStrLn "-h / --help:\t Display help"
    putStrLn "-c:\t\t Compile file"
    putStrLn "-b:\t\t Build project"
    putStrLn "FILENAME:\t Generate C++ code"
    putStrLn "FILENAME.bproj:\t Build project"

bcompile : List String -> IO ()
bcompile args = case args # 2 of
                    Just f  => run $ compile f
                    Nothing => putStrLn "File is not specified"

bproject : List String -> IO ()
bproject args = case args # 2 of
                    Just f  => run $ build f
                    Nothing => putStrLn "File is not specified"

noArgsFile : String -> IO ()
noArgsFile file = do
    if isSuffixOf ".bproj" file then run $ build file
                                else run $ codegen file

main : IO ()
main = System.getArgs >>= \args =>
    if length args > 1 then
      case args # 1 of
        Just cmd => case cmd of
                      "--version"   => showVersion
                      "-v"          => showVersion
                      "--help"      => help
                      "-h"          => help
                      "-c"          => bcompile args
                      "-b"          => bproject args
                      file          => noArgsFile file
        _        => putStrLn "What?"
   else do putStrLn "Hi"
