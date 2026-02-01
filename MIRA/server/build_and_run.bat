@echo off
setlocal enabledelayedexpansion

:: 1. تفعيل بيئة المطور
echo [1/5] Setting up VS 2026 Environment...
set "VS_PATH=C:\Program Files\Microsoft Visual Studio\18\Insiders\VC\Auxiliary\Build\vcvarsall.bat"
call "%VS_PATH%" x64
cd /d "%~dp0"

:: 2. تنظيف وبناء المجلد
echo [2/5] Cleaning and Creating Build Folder...
if exist build (rd /s /q build)
mkdir build
cd build

:: 3. التهيئة والبناء
echo [3/5] Configuring and Building...
cmake .. "-DCMAKE_TOOLCHAIN_FILE=C:/Users/S.F/vcpkg/scripts/buildsystems/vcpkg.cmake"
cmake --build . --config Debug

:: 4. نسخ ملف الإعدادات (config.json)
echo [4/5] Copying configuration file...
:: سأقوم بالبحث عن مجلد Debug أو Release الذي يحتوي على الملف التنفيذي
set "TARGET_DIR="
if exist "Debug" (set "TARGET_DIR=Debug") else (if exist "Release" (set "TARGET_DIR=Release") else (set "TARGET_DIR=."))

copy /Y "C:\Users\S.F\Desktop\sd\MIRA\server\config.json" "%TARGET_DIR%\"
if not exist "%TARGET_DIR%\static" mkdir "%TARGET_DIR%\static"
if not exist "%TARGET_DIR%\static\uploads" mkdir "%TARGET_DIR%\static\uploads"
xcopy /E /I /Y "C:\Users\S.F\Desktop\sd\MIRA\server\static" "%TARGET_DIR%\static"

:: 5. تشغيل السيرفر
echo [5/5] Starting the Server...
cd "%TARGET_DIR%"
:: البحث عن ملف السيرفر وتشغيله
for %%f in (*.exe) do (
    echo [RUNNING] Found %%f, launching now...
    "%%f"
    goto :end
)

:end
pause