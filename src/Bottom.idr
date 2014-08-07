module Bottom

import Effect.StdIO
import Effect.System
import Effect.File

import IOProcess

import Control.IOExcept
import Control.Eternal

buildProject : List String -> { [STDIO] } Eff ()
buildProject []  = putStrLn "There is nothing to do"
buildProject [x] = putStrLn $ "out is: " ++ x
buildProject (x :: xs) = do putStrLn $ "compile: " ++ x
                            buildProject xs