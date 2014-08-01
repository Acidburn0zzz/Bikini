module Top

import Effect.StdIO
import Effect.System
import Effect.File

import IOProcess
import Yaml

import Control.IOExcept
import Control.Eternal

buildB : (List String) -> { [STDIO] } Eff ()
buildB file =
    let onestring = concat file
    in case parse yamlToplevelValue onestring of
       Left err => putStrLn $ "error: " ++ err
       Right v  => putStrLn $ show v -- TODO: Stuff

codegen : String -> FileIO () ()
codegen f = do case !(open f Read) of
                True => do quest !readFile True
                           close {- =<< -}
                False => putStrLn ("Error!")

compile : String -> FileIO () ()
compile f = do case !(open f Read) of
                True  => do dat <- readFile
                            close {- =<< -}
                            questC dat True f
                False => putStrLn ("Error!")

build : String -> FileIO () ()
build f = do case !(open f Read) of
                True => do buildB !readFile
                           close {- =<< -}
                False => putStrLn ("Error!")
