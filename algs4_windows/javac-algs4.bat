@echo off

:: ***************************************************
:: javac-algs4
:: ------------------
:: Wrapper for javac that includes stdlib.jar 
:: and algs4.jar
:: ***************************************************

set install=%USERPROFILE%\algs4

javac -cp "%install%\stdlib.jar;%install%\algs4.jar;." %*