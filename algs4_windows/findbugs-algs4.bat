@echo off

:: ***************************************************
:: findbugs-algs4.bat
:: Hayk Martirosyan
:: ------------------
:: Launcher script for findbugs-algs4.ps1.
:: ***************************************************

set SCRIPT=. '%~dp0\findbugs-algs4.ps1'
set PS=%WINDIR%\System32\WindowsPowershell\v1.0\PowerShell.exe

:: Bugfix: escaping $ from arguments
set ARGS=%*
set ARGS=%ARGS:$=`$%

if exist "%PS%" (
"%PS%" -ExecutionPolicy Unrestricted -NoProfile -Command "%SCRIPT%" %ARGS%
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
