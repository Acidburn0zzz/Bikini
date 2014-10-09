module XSyntax

import Control.Eternal

xrules : List (Nat, String, Bool)
xrules = with List [
    (0, "[&]() { switch /* match */", True)
    ]

yrules : List (Nat, String)
yrules = with List [
    (0, "} ()")
    ]

rpl : List Nat -> Nat -> Nat -> List Nat
rpl xs i x = fore ++ (x :: aft)
  where
    fore : List Nat
    fore = take i xs
    
    aft : List Nat
    aft  = drop (i+1) xs
    
srpl : List Nat -> Nat -> Nat -> List Nat
srpl xs i x = if i >= 0 && i < length xs
                then rpl xs i x
                else xs

blockRules : (List Nat) -> Nat -> List Char -> List (Nat, String, Bool) -> (List Nat)
blockRules ln l w = map (\(nn, s, i) => case ln # nn of
                                          Just n => if n == 0 then if i then if isInfixOf (unpack s) w then l
                                                                                                       else 0
                                                                        else if isPrefixOf (unpack s) w then l
                                                                                                        else 0
                                                              else n
                                          _ => 0
                        )
                        
-- tracking issue: https://github.com/idris-lang/Idris-dev/issues/1418
{-
blockRulesFold' : ((List Nat), String, Nat, Str4ing) -> ((List Nat), String, Nat, String)
blockRulesFold' (ln, rpl, nn, s) (lnx, rplx, fn, fs) =
    case ln # fn of
          Just n => if n > 0 && l <= n then ((rr 0), s ++ ("\n" ++ rpl ++ fs))
                                       else ((rr n), s)
          _ => ((rr 0), s ++ ("\n" ++ rpl ++ fs))
  where rr : Nat -> List Nat
        rr = srpl ln nn
blockRules' : (List Nat) -> Nat -> String -> List (Nat, String) -> ((List Nat), String)
blockRules' ln l rpl lns = 
    let (lnx, _, _, strx) = foldr1 blockRulesFold' mappedlns
    in  (lnx, strx)
  where mappedlns : List ((List Nat), String, Nat, String)
        mappedlns = map (\(nn, s) => (ln, rpl, nn, s)) lns
-}

blockRule' : (List Nat) -> Nat -> Nat -> String -> ((List Nat), String)
blockRule' ln nn l s =
    case ln # nn of
        Just n => if n > 0 && l <= n then ((rr 0), s)
                                     else ((rr n), "")
        _ => ((rr 0), s)
  where rr : Nat -> List Nat
        rr = srpl ln nn

completeAuto : ((List Nat), String) -> ((List Nat), String) -> ((List Nat), String)
completeAuto (lmu, a) (_, b) =
    if isSuffixOf op ua
        then let la    = length $ takeWhile (== ' ') ua
                 rl    = drop la ua
                 match = blockRules lmu la rl xrules
             in (match, (a ++ "\n" ++ b))
        else let cl : List Char = ['}']
             in if isSuffixOf cl ua
                    then let lb  = length $ takeWhile (== ' ') $ unpack b
                             rpl = pack $ with List replicate lb ' '
                             --(mn, semim) = blockRules' lmu lb rpl yrules
                             (mn, semim) = blockRule' lmu 0 lb ("\n" ++ rpl ++ "} ()")
                         in (mn, (a ++ "\n" ++ b ++ semim))
                    else (lmu, (a ++ "\n" ++ b))
  where
    ua : List Char
    ua = unpack b
    
    op : List Char
    op = ['{']
