@echo off
REM Password Generator Installer for Windows
REM This script downloads and installs the password generator shell script

setlocal enabledelayedexpansion

REM Configuration
set "REPO_URL=https://raw.githubusercontent.com/SanderCokart/shell-password-generator/main/script.sh"
set "INSTALL_DIR=%USERPROFILE%\password-generator"
set "SCRIPT_NAME=pwgen.bat"
set "TEMP_FILE=%TEMP%\password-generator-script.sh"

REM Colors (using mode con for Windows)
REM Note: Windows CMD doesn't have built-in colors like Unix, but we can use simple text

echo [INFO] Password Generator Installer for Windows
echo.

REM Create install directory
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%" 2>nul
    if errorlevel 1 (
        echo [ERROR] Failed to create installation directory: %INSTALL_DIR%
        goto :error
    )
)

REM Check if curl or PowerShell is available for downloading
where curl >nul 2>nul
if %errorlevel% equ 0 (
    set "DOWNLOADER=curl -fsSL"
    goto :download
)

REM Try PowerShell as fallback
powershell -command "exit 0" >nul 2>nul
if %errorlevel% equ 0 (
    set "DOWNLOADER=powershell -Command \"Invoke-WebRequest -Uri"
    goto :download
)

echo [ERROR] Neither curl nor PowerShell is available for downloading.
echo Please install curl or ensure PowerShell is available.
goto :error

:download
echo [INFO] Downloading password generator script...

REM Download the script
if "%DOWNLOADER%"=="curl -fsSL" (
    curl -fsSL "%REPO_URL%" -o "%TEMP_FILE%"
) else (
    powershell -Command "Invoke-WebRequest -Uri '%REPO_URL%' -OutFile '%TEMP_FILE%'"
)

if errorlevel 1 (
    echo [ERROR] Failed to download the script from %REPO_URL%
    goto :error
)

REM Verify the downloaded script
if not exist "%TEMP_FILE%" (
    echo [ERROR] Downloaded file does not exist
    goto :error
)

for %%A in ("%TEMP_FILE%") do if %%~zA equ 0 (
    echo [ERROR] Downloaded file is empty
    del "%TEMP_FILE%" 2>nul
    goto :error
)

REM Check if script is already installed
if exist "%INSTALL_DIR%\%SCRIPT_NAME%" (
    echo [WARNING] Password generator is already installed at %INSTALL_DIR%\%SCRIPT_NAME%
    set /p "choice=Do you want to overwrite it? (y/N): "
    if /i not "!choice!"=="y" if /i not "!choice!"=="Y" (
        echo [INFO] Installation cancelled.
        del "%TEMP_FILE%" 2>nul
        goto :end
    )
)

REM Create batch wrapper for the shell script
echo [INFO] Creating Windows batch wrapper...
(
echo @echo off
echo REM Password Generator Batch Wrapper
echo REM This wrapper runs the shell script using WSL, Git Bash, or MSYS2
echo.
echo setlocal
echo.
echo REM Find bash executable
echo where bash ^>nul 2^>nul
echo if %%errorlevel%% equ 0 ^(
echo     set "BASH_CMD=bash"
echo ^) else ^(
echo     REM Try common locations for bash
echo     if exist "C:\Program Files\Git\bin\bash.exe" ^(
echo         set "BASH_CMD=C:\Program Files\Git\bin\bash.exe"
echo     ^) else if exist "C:\Program Files (x86)\Git\bin\bash.exe" ^(
echo         set "BASH_CMD=C:\Program Files (x86)\Git\bin\bash.exe"
echo     ^) else if exist "C:\msys64\usr\bin\bash.exe" ^(
echo         set "BASH_CMD=C:\msys64\usr\bin\bash.exe"
echo     ^) else ^(
echo         echo [ERROR] bash not found. Please install Git for Windows, WSL, or MSYS2.
echo         pause
echo         exit /b 1
echo     ^)
echo ^)
echo.
echo REM Run the shell script with all arguments
echo "%%BASH_CMD%%" "%INSTALL_DIR%\script.sh" %%*
echo.
echo endlocal
) > "%INSTALL_DIR%\%SCRIPT_NAME%"

REM Copy the actual script
echo [INFO] Installing script to %INSTALL_DIR%\script.sh...
copy "%TEMP_FILE%" "%INSTALL_DIR%\script.sh" >nul
if errorlevel 1 (
    echo [ERROR] Failed to install the script
    del "%TEMP_FILE%" 2>nul
    goto :error
)

REM Clean up temp file
del "%TEMP_FILE%" 2>nul

REM Add to PATH check
echo [INFO] Installation completed successfully^^!
echo.
echo The password generator has been installed to: %INSTALL_DIR%
echo.
echo To use it from anywhere, you can either:
echo 1. Add %INSTALL_DIR% to your PATH environment variable
echo 2. Run it directly: "%INSTALL_DIR%\%SCRIPT_NAME%"
echo.
echo Testing installation...

REM Test the installation
call "%INSTALL_DIR%\%SCRIPT_NAME%" --help >nul 2>nul
if %errorlevel% equ 0 (
    echo [INFO] Installation test passed^^!
) else (
    echo [WARNING] Installation test failed, but script was installed.
    echo Make sure you have bash available (Git for Windows, WSL, or MSYS2).
)

echo.
echo You can now use the password generator with: %SCRIPT_NAME%
echo Or run: "%INSTALL_DIR%\%SCRIPT_NAME%"

goto :end

:error
echo.
echo [ERROR] Installation failed^^!
exit /b 1

:end
echo.
echo Press any key to continue...
pause >nul