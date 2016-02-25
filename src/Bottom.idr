module Bottom

import public IOProcess

%access public export

-- Compile to C++ and save
bquestX : (List String) → Bool → String → FileIO () ()
bquestX file bra cpf =
    case parse (some bParser) (concat file) of
      Left err => ➢ ( "Failed to parse: " ⧺ err )
      Right v  => let sln = splitLines $ finalize v bra
                  in save sln cpf

-- coma intercalate
intercalateC : (List String) → String
intercalateC [] = ""
intercalateC [x] = x
intercalateC (x :: xs) = x ⧺ "," ⧺ intercalateC xs

-- recursive rm -rf
cleanUp : (List String) → { [SYSTEM] } ♬ ()
cleanUp []      = ❂ ()
cleanUp (x::xs) = do sys $ "rm -rf " ⧺ x
                     cleanUp xs

-- flex
lex : String → String → { [SYSTEM] } ♬ ()
lex cc f = sys $ cc ⧺ " " ⧺ f

-- bison
parse : String → String → { [SYSTEM] } ♬ ()
parse cc f = sys $ cc ⧺ " -y -d " ⧺ f

-- compile to executable
bquestY : String → String → (List String) → { [SYSTEM] } ♬ ()
bquestY cc f xs = let cpps = intercalateC $ filter (isSuffixOf "cpp") xs
        in do sys $ cc ⧺ " -I . -o " ⧺ f ⧺ " " ⧺ cpps ⧺ options
              cleanUp xs

-- just compile with -c flag
bquestYL : String → String → (List String) → { [SYSTEM] } ♬ ()
bquestYL cc f xs = let cpps = intercalateC $ filter (isSuffixOf "cpp") xs
        in do sys $ cc ⧺ " -I . -c -o " ⧺ f ⧺ " " ⧺ cpps ⧺ options
              cleanUp xs

-- Compile to C++ and save with bquestX
bcompileX : String → String → FileIO () ()
bcompileX f cpf = case !(open f Read) of
                      True  => do dat <- readFile
                                  close {- =<< -}
                                  bquestX dat True cpf
                      False => putStrLn ("File not found :" ⧺ f)

-- get module name
getModuleName : String → String → String
getModuleName "g++" x =
    case rff ‼ 1 of
        Just f => let ext = case head' rff of
                              Just "cxx"  => "cpp"
                              Just "hxx"  => "hpp"
                              Just "h"    => "hpp"
                              _           => "WTF"
                  in f ⧺ "." ⧺ ext
        _ => ""
  where rff : List String
        rff = reverse $ with String splitOn '.' x
getModuleName "gcc" x =
    case rff ‼ 1 of
        Just f => let ext = case head' rff of
                              Just "cxx"  => "c"
                              Just "hxx"  => "h"
                              _           => "WTF"
                  in f ⧺ "." ⧺ ext
        _ => ""
  where rff : List String
        rff = reverse $ with String splitOn '.' x
getModuleName "clang" x = getModuleName "gcc" x
getModuleName _ x = getModuleName "g++" x

-- Building source Point
srcCompile : String → String → String → FileIO () ()
srcCompile cc x m = do
    putStr $ "src: " ⧺ x
    case m of ""  => putStrLn "What?"
              cpf => do putStrLn $ " -> " ⧺ cpf
                        bcompileX x cpf

-- Building project Point
buildPoint : (String, String) → (List String) → String → FileIO () ()
buildPoint ("out",x) m cc   = bquestY cc x m
buildPoint ("lib",x) m cc   = bquestYL cc x m
buildPoint (_,_) _ _        = ➢ "What!?"

-- Recursive project Build
buildProject : (List (String, String)) → (List String) → String → FileIO () ()
buildProject [] _ _                     = ➢ "There is nothing to do"
buildProject (("cc",x) :: xs) m _       = buildProject xs m x
buildProject (("lex",x) :: xs) m cc     = do lex "flex" x
                                             buildProject xs m cc
buildProject (("parse",x) :: xs) m cc   = do parse "bison" x
                                             buildProject xs m cc
buildProject (("src",x) :: xs) m cc     = do let mn = getModuleName cc x
                                             srcCompile cc x mn
                                             buildProject xs (mn::m) cc
buildProject [(t,x)] m cc               = buildPoint (t,x) m cc
buildProject ((t,x) :: xs) m cc         = do buildProject [(t,x)] m cc
                                             buildProject xs m cc
