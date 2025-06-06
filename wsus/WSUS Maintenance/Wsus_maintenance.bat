@echo off
setLocal EnableDelayedExpansion

set LOGFILE=%TEMP%\%COMPUTERNAME%Maintenance-%RANDOM%.log
set EMAILTO=recipient@example.com
set EMAILFROM=sender@example.com
set EMAILSERVER=smtp
set SUBJECT=%COMPUTERNAME%_maintenance
set BACKUPDESTINATION=\\backupserver\sharename
set WSUSSERVER=wsus
set REBOOT=y

echo %COMPUTERNAME% Maintenance > %LOGFILE%
echo. >> %LOGFILE%
echo %DATE% %TIME% >> %LOGFILE%
echo. >> %LOGFILE%
echo. >> %LOGFILE%
echo Perform Backup... >> %LOGFILE%
echo. >> %LOGFILE%

rd /s /q %BACKUPDESTINATION%\%COMPUTERNAME%_03 >>  %LOGFILE%
ren %BACKUPDESTINATION%\%COMPUTERNAME%_02 %COMPUTERNAME%_03 >> %LOGFILE%
ren %BACKUPDESTINATION%\%COMPUTERNAME%_01 %COMPUTERNAME%_02 >>  %LOGFILE%
md %BACKUPDESTINATION%\%COMPUTERNAME%_01 >>  %LOGFILE%
wbadmin start backup -backupTarget:%BACKUPDESTINATION%\%COMPUTERNAME%_01\ -allcritical -include:c: -quiet -vssfull -systemstate >> %LOGFILE%

echo Run cleanup wizard... >> %LOGFILE%
echo. >> %LOGFILE%
wsus_cleanup_cl.exe %WSUSSERVER% f 80 superceded expired obsolete compress computers files
type cleanup_history.txt >> %LOGFILE%
erase cleanup_history.txt

echo. >> %LOGFILE%
echo Run Maintenance on SQL... >> %LOGFILE%
echo. >> %LOGFILE%

call wsusmaintenance.bat >> %LOGFILE%

echo. >> %LOGFILE%
echo Reboot status is '%REBOOT%' >> %LOGFILE%
if %REBOOT%==y echo Server will reboot >> %LOGFILE%
if NOT %REBOOT%==y echo Server will not reboot >> %LOGFILE%
echo. >> %LOGFILE%

echo. >> %LOGFILE%
echo %DATE% %TIME% >> %LOGFILE%
echo. >> %LOGFILE%
echo End %COMPUTERNAME% Maintenance report... >> %LOGFILE%
echo. >> %LOGFILE%

bmail -s %EMAILSERVER% -t %EMAILTO% -f %EMAILFROM% -a %SUBJECT% -m  %LOGFILE% -c

erase %LOGFILE%

if %REBOOT%==y shutdown /r /f /t 60
