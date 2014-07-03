@echo off

rm -rf Bikini.exe

idris --clean Bikini.ipkg
idris --build Bikini.ipkg
pause