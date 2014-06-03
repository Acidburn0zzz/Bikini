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

                                -- .>>= : Eff m a xs xs' -> ((val : a) -> Eff m b (xs' val) xs'') -> Eff m b xs xs''
                                -- And there we got recursive type inference! So we should specify the type
                                let out : String = case fw of
                                                    Just f => do let Just f1 = f # 1
                                                                 let fs = splitOn '\n' f1
                                                                 let Just fs1 = fs # 0
                                                                 (pack fs1)
                                                    _      => a
                                                    
                                putStrLn out
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
