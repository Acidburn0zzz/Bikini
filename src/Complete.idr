module Complete

import public Control.Unicode

sck : (List Char) → (List (List Char)) → Bool
sck rl = ∀λ lc → isSuffixOf lc rl

pck : (List Char) → (List (List Char)) → Bool
pck rl = ∀λ lc → isPrefixOf lc rl

complete : String → String → String
complete a b =
    if (len ≡ 0) ∨ sfgo ∨ prgo
        then (a ⧺ "\n" ⧺ b)
        else if la ≡ lb
                then (a ⧺ scl ⧺ "\n" ⧺ b)
                else if la > lb then let rpl = pack $ with List replicate lb ' '
                                     in (a ⧺ scl ⧺ "\n" ⧺ rpl ⧺ "}\n" ⧺ b)
                                else (a ⧺ " {\n" ⧺ b)
  where
    ua : List Char
    ua = unpack a

    la : Nat
    la = length $ takeWhile (== ' ') ua

    lb : Nat
    lb = length $ takeWhile (== ' ') $ unpack b

    rl : List Char
    rl = drop la ua

    prgo : Bool
    prgo = pck rl [ ['#']
                  ]

    sfgo : Bool    
    sfgo = sck rl [ ['\\'], [','], ['&']
                  , [':'], ['='], ['{']
                  , ['('], (unpack "/*}*/")
                  , [';']
                  ]

    scl : String
    scl = if sck rl [ (unpack "/*;*/") ]
                    then ""
                    else ";"

    len : Nat
    len = length $ drop la ua
