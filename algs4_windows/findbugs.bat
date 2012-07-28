@echo off

:: ***************************************************
:: findbugs.bat (algs4)
:: Hayk Martirosyan
:: ------------------
:: Easy-to-understand wrapper for using findbugs.
:: ***************************************************

:: Enables unicode support by changing the codepage
for /f "tokens=2 delims=:." %%x in ('chcp') do set cp=%%x
chcp 1252 > NUL

:: Sets the path to the install directory (done by the installer)
set BASE=INSTALL_DIR

:: Finds the findbugs folder using a wildcard match (findbugs-?.?.?)
set FIND_FOLDER=dir /b /s "%BASE%"\findbugs-?.?.?
for /f "delims=" %%i in ('%FIND_FOLDER%') do set FINDBUGS=%%i

:: Sets the paths to the checkstyle jar and xml files
set JAR="%FINDBUGS%\lib\findbugs.jar"
set XML="%FINDBUGS%\findbugs.xml"
set AUX="%BASE%\stdlib.jar;%BASE%\algs4.jar;"

:: If there are no arguments
if [%1] equ [] (
  echo Specify .class or .jar files as arguments.
  echo Usage: 'findbugs Test.class'
  GOTO:END
)

:: If the first argument is a .class file that exists, runs findbugs
if [%~x1] equ [.class] (
  if exist %1 (
    echo Running findbugs on %*:
    java -jar %JAR% -textui -longBugCodes -exclude %XML% -auxclasspath %AUX% %*
  ) else (
    echo File not found! Make sure you are specifying the path correctly.
    echo The filename is case sensitive.
  )
  GOTO:END
)

:: If the first argument is a .jar file that exists, runs findbugs
if [%~x1] equ [.jar] (
  if exist %1 (
    echo Running findbugs on %*:
    java -jar %JAR% -textui -longBugCodes -exclude %XML% -auxclasspath %AUX% %*
  ) else (
    echo File not found! Make sure you are specifying the path correctly.
    echo The filename is case sensitive.
  )
  GOTO:END
)

echo Findbugs needs .class or .jar files as arguments!
echo The filename is case sensitive.

:END
:: Restores the original codepage
chcp %cp% > NUL
