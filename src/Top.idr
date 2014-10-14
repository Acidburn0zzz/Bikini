module Top

import Effect.StdIO
import Effect.System
import Effect.File

import IOProcess
import Yaml
import Bottom

import Control.IOExcept
import Control.Eternal

-- Treat YML value as String
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
    partial buildY : a -> List (Nat, String)

-- parse map .bproj YML
parseBuildConfig : String -> YamlValue -> List (Nat, String)
parseBuildConfig k v = case k of
                        "bikini"     => [ (0, (buildX v) ++ ".h")
                                        , (0, (buildX v) ++ ".cxx")
                                        ]
                        "compiler"   => [ (1, (buildX v)) ]
                        "executable" => [ (5, (buildX v) ++ ".exe") ]
                        "library"    => [ (6, (buildX v) ++ ".o")
                                        ]
                        _            => []

-- bproj YML parser
instance BuildY YamlValue where
  buildY (YamlString s)   = []
  buildY (YamlNumber x)   = []
  buildY (YamlBool True)  = []
  buildY (YamlBool False) = []
  buildY  YamlNull        = []
  buildY (YamlObject xs)  =
   intercalate (map fmtItem $ SortedMap.toList xs)
    where
      intercalate : List (List (Nat, String)) -> List (Nat, String)
      intercalate [] = []
      intercalate [x] = x
      intercalate (x :: xs) = x ++ (intercalate xs)
      fmtItem (k, v) = parseBuildConfig k v
  buildY (YamlArray xs) = concat $ map buildY xs

-- Parse bprj YML and run recursive building
buildB : (List String) -> FileIO () ()
buildB file =
    case parse yamlToplevelValue onestring of
       Left err => putStrLn $ "Error parsing project YML: " ++ err
       Right v  => let parsedConfig = buildY v
                       source = map (\(n,s) => s) (filter (\(n,s) => n == 0) parsedConfig)
                       modules = map srcCompileNoEffect source
                   in buildProject parsedConfig modules
  where onestring : String
        onestring = concat file

-- Generate C++ code
codegen : String -> FileIO () ()
codegen f = case !(open f Read) of
                True => do quest !readFile True
                           close {- =<< -}
                False => putStrLn $ "Codegen Error on file:" ++ f

-- Compile cimple CXX file {- Deprecated -}
compile : String -> FileIO () ()
compile f = case !(open f Read) of
                True  => do dat <- readFile
                            close {- =<< -}
                            questC dat True f
                False => putStrLn $ "Compile Error on file:" ++ f

-- Build project: .bproj => FileIO
build : String -> FileIO () ()
build f = case !(open f Read) of
                True => do dat <- readFile
                           close {- =<< -}
                           buildB dat
                False => putStrLn $ "Project file error:" ++ f
