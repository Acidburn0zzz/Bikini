module Top

import Effect.StdIO
import Effect.File

import Control.IOExcept
import Control.Eternal

quest : (List String) -> { [STDIO] } Eff IO ()
quest file = do
  putStr ">"
  let a = trim !getStr
  case choose (a /= "") of
       Left p  => case a of 
                      "q" => putStrLn "quit"
                      _   => do let fmap = map (\l => splitOn ' ' $ unpack l) file
                                let fw = find (\ls => do let Just fA = ls # 0
                                                         let fw = pack fA 
                                                         fw == a
                                             ) fmap

                                -- CASE IS BROKEN
                                {-
                                (4:54:41 PM) edwinb: okay, I can reproduce this strange behaviour Heather has found
                                (4:54:53 PM) edwinb: no idea what's going on but it'll keep me entertained on the train later
                                -}

                                --case f of Just (_, v) => do let c = replace a v [a]
                                --                            putStrLn $ concat c
                                --          _ => putStrLn "fregre"

                                quest file
       Right p => do putStrLn "Invalid input!"; quest file

FileIO : Type -> Type -> Type
FileIO st t = { [FILE_IO st, STDIO] } Eff IO t 

readFile : FileIO (OpenFile Read) (List String)
readFile = readAcc [] where
  readAcc : List String -> FileIO (OpenFile Read) (List String)
  readAcc acc = if (not !eof) then readAcc $ !readLine :: acc
                              else return  $ reverse acc

load : FileIO () ()
load = do case !(open "Bikini" Read) of
             True => do quest !readFile
                        close {- =<< -}
             False => putStrLn ("Error!")
