@echo off
echo ========================================
echo MIRA Diagnostic Tool
echo ========================================
echo.
echo Current Directory: %CD%
echo.
if exist "..\server\main.cc" (
    echo [OK] Found server source in parent directory.
) else (
    echo [ERROR] Could not find server source. Are you running from Desktop\sd\MIRA?
)
echo.
echo Please ensure you are running the server and client from:
echo C:\Users\S.F\Desktop\sd\MIRA
echo.
pause
