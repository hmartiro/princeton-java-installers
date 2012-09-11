@echo off

:: ***************************************************
:: checkstyle-algs4.bat
:: Hayk Martirosyan
:: ------------------
:: Launcher script for checkstyle-algs4.ps1.
:: ***************************************************

set SCRIPT=. '%~dp0\checkstyle-algs4.ps1'
set PS=%WINDIR%\System32\WindowsPowershell\v1.0\PowerShell.exe

if exist "%PS%" (
"%PS%" -ExecutionPolicy Unrestricted -NoProfile -Command "%SCRIPT%" %*
) else (
echo You do not have Microsoft PowerShell installed.
echo Please run Windows Update.
echo.
echo If that does not help, manually install the
echo Windows Management Framework Core
echo.
echo http://support.microsoft.com/kb/968929
echo.
pause
)
