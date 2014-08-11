module Main
import Top

import Control.Eternal
import Effect.System

version : String
version = "0.0.3"

help : IO ()
help = do
    putStrLn $ "Bikini v." ++ version
    putStrLn "--version:\t Display version"
    putStrLn "--help:\t\t Display help"
    putStrLn "-c:\t\t Compile file"
    putStrLn "-b:\t\t Build project"
    putStrLn "FILENAME:\t Generate C++ code"

bcompile : List String -> IO ()
bcompile args = case args # 2 of
                    Just f  => run $ compile f
                    Nothing => putStrLn "File is not specified"

bproject : List String -> IO ()
bproject args = case args # 2 of
                    Just f  => run $ build f
                    Nothing => putStrLn "File is not specified"

main : IO ()
main = System.getArgs >>= \args =>
    if length args > 1 then
      case args # 1 of
        Just cmd => case cmd of
                      "--version"   => putStrLn $ "Bikini v." ++ version
                      "--help"      => help
                      "-c"          => bcompile args
                      "-b"          => bproject args
                      file          => run $ codegen file
        _        => putStrLn "What?"
   else do putStrLn "Hi"
