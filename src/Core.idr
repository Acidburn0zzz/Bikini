module Core

import public Control.Eternal
import public Unicode

%access public export

version : String
version = "0.1.2"

showVersion : String
showVersion = "Bikini v." ⧺ version

printVersion : IO ()
printVersion = ➢ showVersion
