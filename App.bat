@echo off
SETLOCAL

:: Check if Python is installed
@REM python --version >nul 2>&1
@REM IF %ERRORLEVEL% NEQ 0 (
@REM     echo Python not found. Downloading Python 3.12.2 installer...
@REM     powershell -Command "Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe -OutFile python_installer.exe"

@REM     echo Installing Python silently... Please wait.
@REM     :: 'start /wait' ensures the script waits until the installation is 100% finished
@REM     :: InstallAllUsers=0 allows it to run without Admin rights
@REM     start /wait python_installer.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0
    
@REM     echo.
@REM     echo Installation complete! 
@REM     echo Please close this window and run this script again to apply the new system paths.
@REM     pause
@REM     exit /b
@REM )

:: Start server
echo Starting local server on port 8000...
start "" "http://localhost:8000/src/app-page.html"
python -m http.server 8000

ENDLOCAL