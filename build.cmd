@echo off

pushd .
cd .\src
set ABS_PATH=%CD%
idris --clean Bikini.ipkg
idris --build Bikini.ipkg
mv Bikini.exe ..
popd

pause