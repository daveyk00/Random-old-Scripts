: +-------------------+
: | XCOPY reports 1.0 |
: +-------------------+

: XCOPY Script that includes email notification

: Requires: bmail.exe

: Erase logfile %temp%\xcopyresults.log
: Perform the xcopy logging to %temp%\xcopyresults.log
: Execute bmail and send the email using the variables listed below.
: Erase the copy of the log files in %temp%\xcopyresults.log
: release environment variables

: Set variables:
: 	SERVERNAME is the smtp server used
:	EMAILTO / EMAILFROM / SUBJECT all self explanitory
:	ATTACHMENT is the name of the attachment to use in the body
:	BMAILDIR is the location of BMAIL.EXE

: +---------+
: |  START  |
: +---------+

@echo off

set SERVERNAME=mail.example.com
set EMAILTO=recipient@example.com
set EMAILFROM=sender@example.com
set SUBJECT=XCOPYReport
set ATTACHMENT=%TEMP%\xcopyresults.log
set BMAILDIR=c:\idebackup

erase %temp%\xcopyresults.log /f /q

erase g:\*.bkf /f /q
xcopy c:\IDEBackup\*.bkf g:\*.bkf /e /h /r /y > %temp%\xcopyResults.log

call %BMAILDIR%\bmail -s %SERVERNAME% -t %EMAILTO% -f %EMAILFROM% -a %SUBJECT% -m "%ATTACHMENT%" -c

erase %temp%\xcopyresults.log

set SERVERNAME=
set EMAILTO=
set EMAILFROM=
set SUBJECT=
set ATTACHMENT=
set BMAILDIR=

: +---------+
: |   END   |
: +---------+
