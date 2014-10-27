@echo off

Bikini --version

echo building Prelude...

mkdir "lib/Prelude"
mkdir "lib/Tests"

Bikini bikini/Prelude/Bikini.h  > lib/Prelude/Bikini.hpp
Bikini bikini/Prelude/Memo.h    > lib/Prelude/Memo.hpp
Bikini bikini/Prelude/Test.h    > lib/Prelude/Test.hpp
Bikini bikini/Prelude/GC.h      > lib/Prelude/GC.hpp
Bikini bikini/Prelude/GC.cxx    > lib/Prelude/GC.cpp

Bikini bikini/Tests/Basics.h    > lib/Tests/Basics.hpp
Bikini bikini/Tests/Memo.h      > lib/Tests/Memo.hpp
Bikini bikini/Tests/Run.cxx     > lib/Tests/Run.cpp

::pushd .
::cd .\bikini/Bikini2/
::set ABS_PATH=%CD%
::    "%ABS_PATH%/../../Bikini" %ABS_PATH%/b2.bproj
::popd

pushd .
cd .\bikini/Bikini2/
set ABS_PATH=%CD%
    "%ABS_PATH%/../../Bikini" %ABS_PATH%/b2.hxx > %ABS_PATH%/b2.h
    "%ABS_PATH%/../../Bikini" %ABS_PATH%/b2.cxx > %ABS_PATH%/b2.c
    bison -y -d parse.y
    flex lex.l
    clang -c y.tab.c lex.yy.c
    clang y.tab.o lex.yy.o b2.c -o b2.exe
popd

pause