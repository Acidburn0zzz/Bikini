module Main
import Top

import Control.Eternal
import Effect.System

version : String
version = "0.0.1"

main : IO ()
main = System.getArgs >>= \args =>
    if length args > 1 then
      case args # 1 of
        Just cmd => case cmd of
                      "--version" => putStrLn version
        _        => putStrLn "What?"
   else do putStrLn "REPL"
           run load
