@echo off
::since there is .o linking we need to get last souces of this thing
::from Control.Eternal.Idris
cp -rf ../Control.Eternal.Idris/*.c .
cp -rf ../Control.Eternal.Idris/*.h .
cp -rf ../Control.Eternal.Idris/Makefile .
make

idris --build Bikini.ipkg
pause