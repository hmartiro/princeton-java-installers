@echo off

:: ***************************************************
:: checkstyle.bat (algs4)
:: Hayk Martirosyan
:: ------------------
:: Easy-to-understand wrapper for using checkstyle.
:: ***************************************************

:: Enables unicode support by changing the codepage
for /f "tokens=2 delims=:." %%x in ('chcp') do set cp=%%x
chcp 1252 > NUL

:: Sets the path to the install directory (done by the installer)
set BASE=INSTALL_DIR

:: Finds the checkstyle folder using a wildcard match (checkstyle-?.?)
set FIND_FOLDER=dir /b "%BASE%"\checkstyle-?.?
for /f "delims=" %%i in ('%FIND_FOLDER%') do set CHECKSTYLE=%%i

:: Sets the paths to the checkstyle jar and xml files
set JAR="%BASE%\%CHECKSTYLE%\%CHECKSTYLE%-all.jar"
set XML="%BASE%\%CHECKSTYLE%\checkstyle.xml"

:: If there are no arguments
if [%1] equ [] (
  echo Specify .java files as arguments.
  echo Usage: 'checkstyle Test.java'
  GOTO:END
)

:: If the first argument is a .java file that exists, runs checkstyle
if [%~x1] equ [.java] (
  if exist %1 (
    echo Running checkstyle on %*:
    java -jar %JAR% -c %XML% %*
  ) else (
    echo File not found! Make sure you are specifying the path correctly.
    echo The filename is case sensitive.
  )
) else (
  echo Checkstyle needs a .java file as an argument!
  echo The filename is case sensitive.
)

:END
:: Restores the original codepage
chcp %cp% > NUL
