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

||| fold-process bracket endings
complete : String -- first line
         → String -- second line
         → String -- folding
complete fst snd =
  if ((length rfst) ≡ 0) ∨ sfgo ∨ prgo
    then (fst ⧺ "\n" ⧺ snd)
    else if lfst ≡ lsnd
          then (fst ⧺ end ⧺ "\n" ⧺ snd)
          else if lfst > lsnd
            then let rpl = pack $ with List replicate lsnd ' '
                 in (fst ⧺ end ⧺ "\n" ⧺ rpl ⧺ "}\n" ⧺ snd)
            else (fst ⧺ " {\n" ⧺ snd)
 where
  ufst : List Char
  ufst = unpack fst

  lfst : ℕ
  lfst = length $ takeWhile (== ' ') ufst

  lsnd : ℕ
  lsnd = length $ takeWhile (== ' ') $ unpack snd

  ||| first element without indentation
  rfst: List Char
  rfst = drop lfst ufst

  ||| do not end-complete with that prefix
  prgo : Bool
  prgo = pck rfst [ ['#']
                  ]

  ||| do not end-complete with that suffix
  sfgo : Bool
  sfgo = sck rfst [ ['\\'], [','], ['&']
                  , [':'], ['='], ['{']
                  , ['('], (❃ "/*}*/")
                  , [';']
                  ]

  ||| ending semicolon
  end : String
  end = if sck rfst [ (❃ "/*;*/") ]
            then ""
            else ";"
