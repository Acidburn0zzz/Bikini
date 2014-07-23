@echo off

echo building Prelude...

mkdir "lib/Prelude"
mkdir "lib/Tests"

Bikini bikini/Prelude/Bikini.h  > lib/Prelude/Bikini.hpp
Bikini bikini/Prelude/Memo.h    > lib/Prelude/Memo.hpp
Bikini bikini/Prelude/Test.h    > lib/Prelude/Test.hpp

Bikini bikini/Tests/Basics.h    > lib/Tests/Basics.hpp
Bikini bikini/Tests/Memo.h      > lib/Tests/Memo.hpp
Bikini bikini/Tests/Run.cxx     > lib/Tests/Run.cpp

echo Running Prelude tests...

g++ -Ilib -O3 -Wall -std=c++1y -o tests.exe lib/Tests/Run.cpp
tests.exe

echo building Test application...

Bikini bikini/tests.cxx > out.cpp
cat out.cpp

echo Compiling...

::Bikini -c bikini\tests.cxx
g++ -o bikini/tests.exe out.cpp -O3 -Wall -std=c++1y

echo Tests

bikini\tests.exe

echo Cleaning...

rm -rf tests.exe
rm -rf bikini/tests.exe
rm -rf out.cpp

pause