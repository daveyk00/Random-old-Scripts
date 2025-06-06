@echo off
setlocal EnableDelayedExpansion

:: +-------------+
:: | Count Files |
:: +-------------+

:: Counts files, subfolders, directories

:: Variables:
:: DIRECTORY = directory to count files (no trailing slash)
:: INCLUDEDIR = include directories - yes or no (in lowercase)
:: INCLUDESUB = include sub folders - yes or no (in lowercase)
:: FILEMASK = the file mask to count - *.*, *.pdf, etc.


:: Tested:
:: Server 2008 r2 SP1 (ver 6.1.7601)
:: Windows XP SP3 (ver 5.1.2600)

:: ------------------ CONFIGURE SETTINGS BELOW THIS LINE ---------------------------

set DIRECTORY="c:\temp"
set INCLUDEDIR=yes
set INCLUDESUB=yes
set FILEMASK=*.*

:: ------------------ CONFIGURE SETTINGS ABOVE THIS LINE ---------------------------
:: ------------------ DO NOT MAKE ANY CHANGES BELOW THIS LINE ----------------------



set ARGUMENTS=
set ERRORCONDITION=

if not exist %DIRECTORY% (set ERRORCONDITION="Directory %DIRECTORY% does not exist" && goto :ERROR)
if %INCLUDEDIR%==yes set ARGUMENTS=/D
if %INCLUDESUB%==yes set ARGUMENTS=%ARGUMENTS% /s


attrib %ARGUMENTS% %DIRECTORY%\%FILEMASK% | find /c /v ""
goto :FINISH

:ERROR
echo An error has occurred
echo %ERRORCONDITION%
goto :FINISH


:FINISH