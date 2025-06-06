: +-----------------------------+
: | Delete Temp Directories 1.1 |
: +-----------------------------+

: Deletes %userprofile%\local settings\temp
: Deletes %userprofile%\local settings\temporary internet files
: Deletes %userprofile%\cookies\*.txt
: FOR ALL PROFILES Excluding "All users"

: Takes command line option of text file that has a list of usernames / Location of temporary file to use
: DeleteUserTempDir.bat Userlist TempArea
: IE: DeleteUserTempDir.bat c:\userlist.txt c:\temp\tempUserlist.txt


: 1 user name per line
: eg:
: administrator
: all users
: user

@echo off

if "%1"=="" goto NotCorrectCommandLineParam
if "%2"=="" goto NotCorrectCommandLineParam
goto MainStartPoint

:NotCorrectCommandLineParam
echo.
echo Not Correct Command Line Parameters
echo Usage: DeleteUserTempDir.Bat userlistFile TempFiletoUse
echo IE: DeleteUserTempDir.bat c:\userlist.txt c:\temp\userlistttemp.txt
echo.
goto BailOut


: +------------------------------+
: | Read input file line by line |
: +------------------------------+

:MainStartPoint

@echo off
setlocal
set ctr=0

:line
ping -n 2 localhost > nul
set "line="
set /a ctr += 1
more /e +%ctr% "%~1">%2
set /p line=<%2
rem :if defined line echo %line%&goto :line

: If line is a valid line - jump to delete

if defined line goto :deletehere

del %2
goto :EOF

goto :bailout

: +------------------+
: | Delete the files |
: +------------------+

:deletehere

: Skip if the username is "all users"

if "%line%"=="All Users" goto:skipDelete

rd/s/q "c:\documents and settings\%line%\local settings\temp"
md "c:\documents and settings\%line%\local settings\temp"
erase "c:\documents and settings\%line%\cookies\*.txt
rd/s/q "c:\documents and settings\%line%\local settings\temporary internet files"
md "c:\documents and settings\%line%\local settings\temporary internet files"

:SkipDelete
goto :line

:bailout

