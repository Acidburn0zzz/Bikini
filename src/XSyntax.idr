module XSyntax

import Control.Eternal

xrules : List (Nat, String)
xrules = [
    (0, "[&]() { switch /* match */")
    ]
yrules : List (Nat, String)
yrules = [
    (0, "} ()")
    ]

rpl : (List Nat) -> Nat -> Nat -> (List Nat)
rpl xs i x = do
    let fore = take i xs
    let aft  = drop (i+1) xs
    fore ++ (x :: aft)
    
srpl : (List Nat) -> Nat -> Nat -> (List Nat)
srpl xs i x = if i >= 0 && i < length xs
                then rpl xs i x
                else xs

blockRule : (List Nat) -> Nat -> Nat -> String -> List Char -> (List Nat)
blockRule ln nn l s w =
    let rr = srpl ln nn
    in case ln # nn of
        Just n => if n == 0 then if isInfixOf (unpack s) w then rr l
                                                           else rr 0
                            else rr n
        _ => rr 0

blockRule' : (List Nat) -> Nat -> Nat -> String -> ((List Nat), String)
blockRule' ln nn l s =
    let rr = srpl ln nn
    in case ln # nn of
        Just n => if n > 0 && l <= n then ((rr 0), s)
                                     else ((rr n), "")
        _ => ((rr 0), s)

blockRules : (List Nat) -> Nat -> List Char -> List (Nat, String) -> (List Nat)
blockRules ln l w = map (\(nn, s) => case ln # nn of
                                      Just n => if n == 0 then if isInfixOf (unpack s) w then l
                                                                                         else 0
                                                          else n
                                      _ => 0
                        )
                        
-- Track idris issue to fix it
{-
blockRules' : (List Nat) -> Nat -> List (Nat, String) -> List (Nat, String)
blockRules' ln l = map (\(nn, s) => case ln # nn of
                                      Just n => if n > 0 && l <= n then (0, s)
                                                                   else (n, "")
                                      _ => (0, s)
                       )
-}

completeAuto : ((List Nat), String) -> ((List Nat), String) -> ((List Nat), String)
completeAuto (lmu, a) (_, b) = do
    let ua  = unpack b
    let op : List Char = ['{']
    if isSuffixOf op ua
        then do
             let la  = length $ takeWhile (== ' ') ua
             let rl = drop la ua
             let match = blockRules lmu la rl xrules
             (match, (a ++ "\n" ++ b))
        else do let cl : List Char = ['}']
                if isSuffixOf cl ua
                    then do let lb  = length $ takeWhile (== ' ') $ unpack b
                            let rpl = pack $ with List replicate lb ' '
                            
                            -- let (mn, semim) = blockRules' lmu lb rpl yrules
                            let (mn, semim) = blockRule' lmu 0 lb ("\n" ++ rpl ++ "} ();")
                            
                            (mn, (a ++ "\n" ++ b ++ semim))
                    else (lmu, (a ++ "\n" ++ b))