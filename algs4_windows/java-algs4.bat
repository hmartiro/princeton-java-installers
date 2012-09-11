@echo off

:: ***************************************************
:: java-algs4
:: ------------------
:: Wrapper for java that includes stdlib.jar 
:: and algs4.jar
:: ***************************************************

set install=%USERPROFILE%\algs4

java -cp "%install%\stdlib.jar;%install%\algs4.jar;." %*