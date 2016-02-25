module XSyntax

import Control.Eternal
import Unicode

%access public export

||| Pre-rules
xrules : List (ℕ, String, Bool)
xrules = with List [
    (0, "[&]() { switch /* match */", True)
    ]

||| Post-rules
yrules : List (ℕ, String)
yrules = with List [
    (0, "} ()")
    ]

||| Replace
rpl : (List ℕ) → (ℕ) → (ℕ) → (List ℕ)
rpl xs i x = fore ⧺ (x :: aft)
  where fore : List ℕ
        fore = take i xs
        aft : List ℕ
        aft  = drop (i+1) xs

||| Safe replace function (with length checks)
srpl : (List ℕ) → (ℕ) → (ℕ) → (List ℕ)
srpl xs i x = if (i ≥ 0) ∧ (i < length xs)
                then rpl xs i x
                else xs

||| Find Rules to process
blockRules : (List ℕ) → (ℕ) → (List Char) → (List (ℕ, String, Bool)) → (List ℕ)
blockRules ln l w = map (
  \(nn, s, i) =>
    case ln ‼ nn of
      Just n =>
        if n ≡ 0
          then if i then if isInfixOf (❃ s) w then l
                                              else 0
                    else if isPrefixOf (❃ s) w then l
                                               else 0
          else n
      _ => 0)

blockRules' : (List ℕ) → (ℕ) → String → (List (ℕ, String)) → ((List ℕ), String)
blockRules' _ _ _ [] = ([], "")
blockRules' ln l rpl [(num, s)] = do
    case ln ‼ num of
        Just n => if (n > 0) ∧ (l ≤ n) then ((rr 0), "\n" ⧺ rpl ⧺ s)
                                       else ((rr n), "\n" ⧺ rpl ⧺ "")
        _ => ((rr 0), "\n" ⧺ rpl ⧺ s)
  where rr : Nat → (List ℕ)
        rr = srpl ln num
blockRules' ln l rpl (x::xs) = let (nlst, s) = blockRules' ln l rpl [x]
                               in blockRules' nlst l (s ⧺ rpl) xs

completeAuto : ((List ℕ), String) → ((List ℕ), String) → ((List ℕ), String)
completeAuto (lmu, a) (_, b) =
    if isSuffixOf op ua
        then let la    = length $ takeWhile (== ' ') ua
                 rl    = drop la ua
                 match = blockRules lmu la rl xrules
             in (match, (a ⧺ "\n" ⧺ b))
        else let cl : List Char = ['}']
             in if isSuffixOf cl ua
                    then let lb  = length $ takeWhile (== ' ') $ ❃ b
                             rpl = ◉ ( with List replicate lb ' ' )
                             (mn, semim) = blockRules' lmu lb rpl yrules
                         in (mn, (a ⧺ "\n" ⧺ b ⧺ semim))
                    else (lmu, (a ⧺ "\n" ⧺ b))
  where
    ua : List Char
    ua = unpack b

    op : List Char
    op = ['{']
