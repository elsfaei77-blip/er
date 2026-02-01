@echo off
cd server
if not exist build mkdir build
cd build
cmake .. -G "MinGW Makefiles"
cmake --build .
pause
