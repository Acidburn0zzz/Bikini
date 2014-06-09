@echo off
Bikini Bikini.cxx > out.cpp

g++ -o test.exe out.cpp -O3 -Wall -std=c++1y

echo Tests:

::cat out.cpp
test.exe

rm -rf test.exe
rm -rf out.cpp

pause