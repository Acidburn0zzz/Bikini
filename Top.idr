module Top

import Control.IOExcept
import Control.Eternal

import Lightyear.Core
import Lightyear.Combinators
import Lightyear.Strings

import Helper

data BValue = BString String
            | BLet String
            | BMatch String
            | BMatchc String
            | BMatchd String
            | JustParse Char

caseProcess : Bool -> String -> String
caseProcess d s = do
    let sa   = unpack s
    let skp1 = 1 + (length $ takeWhile (== '[') sa)
    let cwd  = if d then "default "
                    else "case "
    let val1 = (unpack cwd) ++ (drop skp1 sa)
    let skp2 = length $ takeWhile (/= '=') val1
    let val2 = (take skp2 val1) ++ (unpack ": return ") ++ (drop (skp2 + 2) val1)
    (pack val2) ++ "\n"

instance Show BValue where
    show (BString s)    = show s
    show (BLet s)       = "auto "

    show (BMatch s)     = "[&]() { switch /* match */ "
    show (BMatchc s)    = caseProcess False s
    show (BMatchd s)    = caseProcess True s

    show (JustParse c)  = pack $ with List [c]

bString : Parser String
bString = char '"' $> map pack bString' <?> "Simple string"

bParser : Parser BValue
bParser =  (map BString bString)
       <|> (map BLet $ string "let" $> map pack parseWord' <?> "bLet")
       
       <|> (map BMatch  $ string "match"    $> map pack parseWord' <?> "bMatch")
       <|> (map BMatchc $ string "[="       $> map pack parseUntilLine <?> "bMatchc")
       <|> (map BMatchd $ string "[~"       $> map pack parseUntilLine <?> "bMatchd")
       
       <|> (map JustParse justParse)

complete : String -> String -> String
complete a b = do
    let ua  = unpack a
    let la  = length $ takeWhile (== ' ') ua
    let lb  = length $ takeWhile (== ' ') $ unpack b
    let fa  = length $ takeWhile (== '#') ua
    let len = length $ drop la ua

    if len == 0 || fa > 0
        then (a ++ "\n" ++ b)
        else if la == lb
                then (a ++ ";\n" ++ b)
                else if la > lb then let rpl = pack $ with List replicate lb ' '
                                     in (a ++ ";\n" ++ rpl ++ "}\n" ++ b)
                                else (a ++ " {\n" ++ b)

blockRule : Nat -> Nat -> String -> List Char -> Nat
blockRule n l s w =
    if n == 0
       then if isInfixOf (unpack s) w then l
                                      else 0
       else n
       
blockRule' : Nat -> Nat -> String -> (Nat, String)
blockRule' n l s =
    if n > 0 && l == n then (0, s)
                       else (n, "")

completeAuto : (Nat, Nat, String) -> (Nat, Nat, String) -> (Nat, Nat, String)
completeAuto (au, mu, a) (bu, mmu, b) = do
    let ua  = unpack b
    let op : List Char = ['{']
    if isSuffixOf op ua
        then do
             let la  = length $ takeWhile (== ' ') ua
             let rl = drop la ua
             let match = blockRule mu la "[&]() { switch /* match */" rl
             let auto  = blockRule au la "auto" rl
             (auto, match, (a ++ "\n" ++ b))
        else do let cl : List Char = ['}']
                if isSuffixOf cl ua
                    then do let lb  = length $ takeWhile (== ' ') $ unpack b
                            let rpl = pack $ with List replicate lb ' '
                            let (n, semi)   = blockRule' au lb ("\n" ++ rpl ++ ";")
                            let (mn, semim) = blockRule' mu lb ("\n" ++ rpl ++ "} ()")
                            (n, mn, (a ++ "\n" ++ b ++ semim ++ semi))
                    else (au, mu, (a ++ "\n" ++ b))

copenclose : String -> (Nat, Nat, Nat, String)
copenclose a = do
    let ua  = unpack a
    let op : List Char = ['{']
    let sz = length $ takeWhile (== ' ') ua
    if isSuffixOf op ua
        then (0, sz, 2, a)
        else let cl : List Char = ['}']
             in if isSuffixOf cl ua
                    then (0, sz, 1, a)
                    else (0, sz, 0, a)

replicateX : Nat -> Nat -> Nat -> Nat -> String -> String -> String
replicateX x st s r a b =
    if x > r then (a ++ "\n" ++ b)
             else let rpl = pack $ with List replicate (st + (s * x)) ' '
                  in replicateX (x + 1) st s r a (rpl ++ "}\n" ++ b)

complete2 : (Nat, Nat, Nat, String) -> (Nat, Nat, Nat, String) -> (Nat, Nat, Nat, String)
complete2 (sc, oa, ca, a) (sb, ob, cb, b) = do
    if ca > 1
        then do let step = if ca == 3 then ob - oa
                                      else if sc == 0 then 4
                                                      else sc
                if cb == 1
                    then if ca == 3
                            then (step, ob, 0, (a ++ "\n" ++ b))
                            else do let diff = ((oa - ob) `div` step) - 1
                                    let str = replicateX 1 ob step diff a b
                                    (step, ob, 0, str)
                    else if cb == 2 then (step, ob, ca + 1, (a ++ "\n" ++ b))
                                    else (step, ob, ca, (a ++ "\n" ++ b))
        else (0, ob, cb, (a ++ "\n" ++ b))

bracketBuilder : String -> String
bracketBuilder noBra = do
    let strlines  = splitLines noBra
    let cauto = foldr1 complete strlines
    let (_, _, cA) = foldl1 completeAuto $ map (\l => (0, 0, l)) (splitLines cauto)
    let mapopen = map copenclose (splitLines cA)
    let (_, _, _, brC) = foldl1 complete2 mapopen
    "#include \"lib/Bikini.h\"\n" ++ brC

finalize : (List BValue) -> Bool -> String
finalize v bra = do
    let noBra = concat $ map show v
    if bra then bracketBuilder noBra
           else noBra