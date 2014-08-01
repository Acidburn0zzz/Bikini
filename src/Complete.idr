module Complete

sck : List Char -> (List (List Char)) -> Bool
sck rl = any (\lc => isSuffixOf lc rl)

pck : List Char -> (List (List Char)) -> Bool
pck rl = any (\lc => isPrefixOf lc rl)

complete : String -> String -> String
complete a b = do
    let ua = unpack a
    let la = length $ takeWhile (== ' ') ua
    let lb = length $ takeWhile (== ' ') $ unpack b
    let rl = drop la ua

    let prgo = pck rl [ ['#']
                      ]
    let sfgo = sck rl [ ['\\'], [','], ['&']
                      , [':'],  ['='], ['{']
                      , ['('], (unpack "/*}*/")
                      ]

    let len = length $ drop la ua
    let scl = if sck rl [ (unpack "/*;*/") ]
                    then ""
                    else ";"

    if len == 0 || sfgo || prgo
        then (a ++ "\n" ++ b)
        else if la == lb
                then (a ++ scl ++ "\n" ++ b)
                else if la > lb then let rpl = pack $ with List replicate lb ' '
                                     in (a ++ scl ++ "\n" ++ rpl ++ "}\n" ++ b)
                                else (a ++ " {\n" ++ b)
