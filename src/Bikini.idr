module Main

import Top
import Prelude.Interactive

help : ໒ ()
help = do
    printVersion
    ➢ "-v / --version:\t Display version"
    ➢ "-h / --help:\t Display help"
    ➢ "-c:\t\t Compile file"
    ➢ "-b:\t\t Build project"
    ➢ "FILENAME:\t Generate C++ code"
    ➢ "FILENAME.bproj:\t Build project"

bcompile : (List String) → ໒ ()
bcompile args = case args ‼ 2 of
                    Just f  => ✇ ( compile f )
                    Nothing => ➢ "File is not specified"

bproject : (List String) → ໒ ()
bproject args = case args ‼ 2 of
                    Just f  => ✇ ( build f )
                    Nothing => ➢ "File is not specified"

noArgsFile : String → ໒ ()
noArgsFile file = run
  $ if isSuffixOf ".bproj" file
      then build file
      else codegen file

main : ໒ ()
main = getArgs >>= λ args →
    if length args <= 1 then help
      else case args ‼ 1 of
        Just cmd => case cmd of
                      "--version"   => printVersion
                      "-v"          => printVersion
                      "--help"      => help
                      "-h"          => help
                      "-c"          => bcompile args
                      "-b"          => bproject args
                      file          => noArgsFile file
        _ => help
