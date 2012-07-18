ECHO OFF
REM  QBFC Project Options Begin
REM  HasVersionInfo: Yes
REM  Companyname: Princeton University
REM  Productname: Java Programming Environment Setup
REM  Filedescription: Downloads, installs, and configures the Princeton University introductory Java programming environment on a Windows operating system.
REM  Copyrights: Princeton University
REM  Trademarks: Princeton University
REM  Originalname: Java Programming Environment Setup
REM  Comments: For Microsoft Windows only.
REM  Productversion:  1. 0. 0. 0
REM  Fileversion:  1. 0. 0. 0
REM  Internalname: Java Programming Environment Setup
REM  Appicon: favicon.ico
REM  Embeddedfile: introcs.ps1
REM  Embeddedfile: unzip.exe
REM  QBFC Project Options End
ECHO ON
@ECHO OFF
:: ***************************************************
:: launcher.bat
:: Hayk Martirosyan
:: ------------------
:: Launches the IntroCS automatic installer.
:: Last edited: November 2, 2011
:: ***************************************************

echo Launching the automatic installer introcs.exe...
echo.

set SCRIPT=. '%MYFILES%\introcs.ps1'
set PS=%WINDIR%\System32\WindowsPowershell\v1.0\PowerShell.exe

if exist "%PS%" (
"%PS%" -ExecutionPolicy Unrestricted -NoProfile -Command "%SCRIPT%"
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

exit

