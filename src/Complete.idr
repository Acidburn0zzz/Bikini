module Complete

import public Unicode

%access public export

||| filter suffix
sck : (List Char)
    → (List (List Char))
    → Bool
sck rl = any (λ lc → isSuffixOf lc rl)

||| filter prefix
pck : (List Char)
    → (List (List Char))
    → Bool
pck rl = any (λ lc → isPrefixOf lc rl)

||| filter infix
ick : (List Char)
    → (List (List Char))
    → Bool
ick rl = any (λ lc → isInfixOf lc rl)

||| fold-process bracket endings
||| (first parsing step)
foldProcessLines : String -- first line
                 → String -- second line
                 → String -- folding
foldProcessLines fst snd =
  if ((length rfst) ≡ 0) ∨ sfgo ∨ prgo
    then (fst ⧺ "\n" ⧺ snd)
    else if lfst ≡ lsnd
          then (fst ⧺ end ⧺ "\n" ⧺ snd)
          else if lfst > lsnd
            -- TODO: avoid just blank lines
            then let rpl = pack $ with List replicate lsnd ' '
                 in (fst ⧺ end ⧺ "\n" ⧺ rpl ⧺ "}\n" ⧺ snd)
            else (fst ⧺ " {\n" ⧺ snd)
 where
  lfst : ℕ
  lfst = length $ takeWhile (== ' ') $ unpack fst

  lsnd : ℕ
  lsnd = length $ takeWhile (== ' ') $ unpack snd

  ||| first element without indentation
  rfst: List Char
  rfst = drop lfst $ unpack fst

  ||| do not end-complete with that prefix
  prgo : Bool
  prgo = pck rfst [ ['#'], ['/','/']
                  ]

  ||| do not end-complete with that suffix
  sfgo : Bool
  sfgo = sck rfst [ ['\\'], [','], ['&']
                  , [':'], ['='], ['{']
                  , ['('], (❃ "/*}*/")
                  , [';']
                  ]

  ||| ending semicolon
  end : String -- TODO: MultiWayIf
  end = if sck rfst [ (❃ "/*;*/") ]
          then ""
          else if (pck rfst [ (❃ "template") ])
                ∧ (not $ ick rfst [ ['='] ])
                then ""
                else ";"
