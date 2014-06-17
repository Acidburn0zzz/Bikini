@echo off
Bikini Bikini.cxx > out.cpp

cat out.cpp

echo Compiling...

g++ -o test.exe out.cpp -O3 -Wall -std=c++1y

echo Tests:

test.exe

echo Cleaning...

rm -rf test.exe
rm -rf out.cpp

pause