module Top

import Effect.StdIO
import Effect.System
import Effect.File

import IOProcess
import Yaml
import Bottom

import Control.IOExcept
import Control.Eternal

class BuildX a where
    partial buildX : a -> String

instance BuildX YamlValue where
  buildX (YamlString s)   = s
  buildX (YamlNumber x)   = ""
  buildX (YamlBool True ) = ""
  buildX (YamlBool False) = ""
  buildX  YamlNull        = ""
  buildX (YamlObject xs)  =
      "{" ++ intercalate ", " (map fmtItem $ SortedMap.toList xs) ++ "}"
    where
      intercalate : String -> List String -> String
      intercalate sep [] = ""
      intercalate sep [x] = x
      intercalate sep (x :: xs) = x ++ sep ++ intercalate sep xs

      fmtItem (k, v) = k ++ ": " ++ show v
  buildX (YamlArray  xs)  = show xs

class BuildY a where
    partial buildY : a -> List String

parseBuildConfig : String -> YamlValue -> List String
parseBuildConfig k v = case k of
                        "bikini"     => [ (buildX v) ++ ".h"
                                        , (buildX v) ++ ".cxx"
                                        ]
                        "executable" => [(buildX v) ++ ".exe"]
                        _            => []

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
      intercalate [x] = x
      intercalate (x :: xs) = x ++ (intercalate xs)
      fmtItem (k, v) = parseBuildConfig k v
  buildY (YamlArray xs) = concat $ map buildY xs

buildB : (List String) -> FileIO () ()
buildB file =
    let onestring = concat file
    in case parse yamlToplevelValue onestring of
       Left err => putStrLn $ "error: " ++ err
       Right v  => buildProject (buildY v) []

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
                True => do dat <- readFile
                           close {- =<< -}
                           buildB dat
                False => putStrLn ("Error!")
