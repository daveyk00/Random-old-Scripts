@echo off
setlocal EnableDelayedExpansion

:: +-------------+
:: | Count Files |
:: +-------------+

:: Counts files (not directories in a specific directory)

:: Variables:
:: DIRECTORY = directory to count files
:: FILECOUNT = count of files


:: ------------------ CONFIGURE SETTINGS BELOW THIS LINE ---------------------------

set DIRECTORY=c:\temp

:: ------------------ CONFIGURE SETTINGS ABOVE THIS LINE ---------------------------
:: ------------------ DO NOT MAKE ANY CHANGES BELOW THIS LINE ----------------------


set FILECOUNT=0

FOR /f "tokens=*" %%P IN ('dir /A-d /b') do (call set /a FILECOUNT+=1)
echo %FILECOUNT%