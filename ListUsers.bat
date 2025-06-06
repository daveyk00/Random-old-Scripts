:: List Users v1.1
:: Creates a log of user profiles
:: Log location and name is a parameter from command line
:: IE: ListUsers.bat c:\userlist.log
@echo off

if "%1"=="" goto NotCorrectCommandLine
c:
cd\
cd\documents and settings
rem Add Fake username to list first
echo IGNORE_Fake_User > %1
dir/b >> %1

goto Finish

:NotCorrectCommandLine
echo.
echo usage: Listusers.bat loglocation
echo IE: Listusers.bat c:\userlist.log
echo.


:FINISH

