module Top

import Effect.StdIO
import Effect.System
import Effect.File

import IOProcess
import Yaml

import Control.IOExcept
import Control.Eternal

class BuildY a where
    partial buildY : a -> List String

instance BuildY YamlValue where
  buildY (YamlString s)   = []
  buildY (YamlNumber x)   = []
  buildY (YamlBool True)  = []
  buildY (YamlBool False) = []
  buildY  YamlNull        = []
  buildY (YamlObject xs)  =
   intercalate (map fmtItem $ SortedMap.toList xs)
    where
      intercalate : List (List String) -> List String
      intercalate [] = []
      intercalate [x] = [show x]
      intercalate (x :: xs) = [show x] -- ++ intercalate sep xs

      fmtItem (k, v) = case (show k) of
                        "\"bikini\"" => [ (show v) ++ ".h"
                                        , (show v) ++ ".cxx"
                                        ]
                        _            => []
  buildY (YamlArray xs) = [show xs]

buildB : (List String) -> { [STDIO] } Eff ()
buildB file =
    let onestring = concat file
    in case parse yamlToplevelValue onestring of
       Left err => putStrLn $ "error: " ++ err
       Right v  => putStrLn $ concat $ buildY v -- TODO: Stuff

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
