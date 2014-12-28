module XSyntax

import Control.Eternal

||| Pre-rules
xrules : List (Nat, String, Bool)
xrules = with List [
    (0, "[&]() { switch /* match */", True)
    ]

||| Post-rules
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

blockRules' : (List Nat) -> Nat -> String -> List (Nat, String) -> ((List Nat), String)
blockRules' _ _ _ [] = ([], "")
blockRules' ln l rpl [(num, s)] = do
    case ln # num of
        Just n => if n > 0 && l <= n then ((rr 0), "\n" ++ rpl ++ s)
                                     else ((rr n), "\n" ++ rpl ++ "")
        _ => ((rr 0), "\n" ++ rpl ++ s)
  where rr : Nat -> List Nat
        rr = srpl ln num
blockRules' ln l rpl (x::xs) = do let (nlst, s) = blockRules' ln l rpl [x]
                                  blockRules' nlst l (s ++ rpl) xs

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
                             (mn, semim) = blockRules' lmu lb rpl yrules
                         in (mn, (a ++ "\n" ++ b ++ semim))
                    else (lmu, (a ++ "\n" ++ b))
  where
    ua : List Char
    ua = unpack b
    
    op : List Char
    op = ['{']
