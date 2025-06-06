@echo off

set SERVERNAME=smtp
set EMAILTO=recipient@example.com
set EMAILFROM=sender@example.com
set SUBJECT=subject
set ATTACHMENT=c:\backupapplications\logfile.log
set BACKUPAPPS=c:\backupapplications

rem this is to allow 9 copies to be kept.  Rather than trigger a full each time, rotate through so that copy number 9 becomes the next one to be overwritten
rem this allows only a diff to be created
rem copy 0 is used as a temp location during the rename

ren d:\backup\householdcopy9 householdcopy0
ren d:\backup\householdcopy8 householdcopy9
ren d:\backup\householdcopy7 householdcopy8
ren d:\backup\householdcopy6 householdcopy7
ren d:\backup\householdcopy5 householdcopy6
ren d:\backup\householdcopy4 householdcopy5
ren d:\backup\householdcopy3 householdcopy4
ren d:\backup\householdcopy2 householdcopy3
ren d:\backup\householdcopy1 householdcopy2
ren d:\backup\householdcopy0 householdcopy1

md "d:\backup\householdcopy1"

Robocopy "c:\serverdata\household" "d:\backup\householdcopy1" /MIR /R:5 > %ATTACHMENT%

call %BACKUPAPPS%\bmail -s %SERVERNAME% -t %EMAILTO% -f %EMAILFROM% -a %SUBJECT% -m "%ATTACHMENT%" -c


