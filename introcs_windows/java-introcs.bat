@echo off

:: ***************************************************
:: java-introcs
:: ------------------
:: Wrapper for java that includes stdlib.jar and
:: the Java3D files
:: ***************************************************

set install=%USERPROFILE%\introcs
set j3dlib=%install%\j3d\lib\ext

java -cp "%install%\stdlib.jar;%j3dlib%\vecmath.jar;%j3dlib%\j3dutils.jar;%j3dlib%\j3dcore.jar" %*