@echo off
echo Starting server from src directory...
cd /d "%~dp0src"
echo.
echo Server will start at: http://localhost:8000/index.html
echo.
echo Press Ctrl+C to stop the server
echo.
python -m http.server 8000
