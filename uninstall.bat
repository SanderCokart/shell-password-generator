@echo off
REM Password Generator Uninstaller for Windows
REM This script removes the installed password generator

setlocal enabledelayedexpansion

REM Configuration
set "INSTALL_DIR=%USERPROFILE%\password-generator"
set "SCRIPT_NAME=password-generator.bat"

echo [INFO] Password Generator Uninstaller for Windows
echo.

REM Check if installed
if not exist "%INSTALL_DIR%" (
    echo [WARNING] Password generator does not appear to be installed.
    echo [INFO] Nothing to uninstall.
    goto :end
)

REM Show what will be removed
echo The following will be removed:
echo   - Directory: %INSTALL_DIR%
echo   - All files in the directory
echo.

REM Confirm uninstallation
set /p "choice=Do you want to continue with uninstallation? (y/N): "
if /i not "!choice!"=="y" if /i not "!choice!"=="Y" (
    echo [INFO] Uninstallation cancelled.
    goto :end
)

REM Remove the installation directory
echo [INFO] Removing installation directory...
rmdir /s /q "%INSTALL_DIR%" 2>nul
if errorlevel 1 (
    echo [ERROR] Failed to remove installation directory: %INSTALL_DIR%
    echo [INFO] You may need to manually delete the directory.
    goto :error
)

echo [INFO] Installation directory removed successfully.
echo [INFO] Uninstallation completed successfully^^!
echo [INFO] The password generator has been removed from your system.

goto :end

:error
echo.
echo [ERROR] Uninstallation failed^^!
exit /b 1

:end
echo.
echo Press any key to continue...
pause >nul