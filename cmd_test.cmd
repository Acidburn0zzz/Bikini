@echo off

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

echo Running Prelude tests...

g++ -Ilib -O3 -Wall -std=c++1y -o tests.exe lib/Tests/Run.cpp
tests.exe

echo building Test application...

pushd .
cd .\bikini/Project/
set ABS_PATH=%CD%
    "%ABS_PATH%/../../Bikini" -b %ABS_PATH%/test.bproj
popd

rm -rf bikini/Quickcheck/examples.exe
echo building Quickcheck examples...

pushd .
cd .\bikini/Quickcheck/
set ABS_PATH=%CD%
    "%ABS_PATH%/../../Bikini" -b %ABS_PATH%/examples.bproj
popd

echo Tests

bikini\Project\test.exe

echo Cleaning...

rm -rf tests.exe
rm -rf bikini/Project/test.exe

rm -rf out.cpp
rm -rf test.h

bikini\Quickcheck\examples.exe
