module Main
import Bottom

import Control.Eternal
import Effect.System

version : String
version = "0.0.1"

main : IO ()
main = System.getArgs >>= \args =>
    if length args > 1 then
      case args # 1 of
        Just cmd => case cmd of
                      "--version"   => putStrLn version
                      "--help"      => putStrLn "No way I can help"
                      file          => run $ compile file
        _        => putStrLn "What?"
   else do putStrLn "Hi"
