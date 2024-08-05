@echo off
net session >nul 2>&1
if %errorlevel% == 0 (
    reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
    echo Press Enter to close this window.
) else (
    echo You must run this script as an administrator! Press Enter to close this window.
)
pause >nul
