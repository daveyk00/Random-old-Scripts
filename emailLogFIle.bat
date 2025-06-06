: +--------------------------+
: |    Email log file 1.0    |
: +--------------------------+

: Script that includes emails designated log file

: Requires: bmail.exe

: Close required application (if necessary)
: wait to ensure app is fully closed
: Force close aPP
: execute bmail and send the email using variables listed below
: Erase the original log file
: Start required application (if necessary)
: release environment variables

: Set variables:
: 	SERVERNAME is the smtp server used
:	EMAILTO / EMAILFROM / SUBJECT all self explanitory
:	ATTACHMENT is the name of the attachment to use in the body
:	APPSLOCATION is the location of bmail
:	APPNAME is the name of application to close
:	APPTOSTART is the name / location of application to start

: +---------+
: |  START  |
: +---------+

@echo off

set SERVERNAME=smtp
set EMAILTO=recipient@example.com
set EMAILFROM=sender@example.com
set SUBJECT=Outgoing
set ATTACHMENT=c:\RouterLogs\incoming.log
set APPSLOCATION=c:\backupapplications
set APPNAME=logviewer.exe
set APPTOSTART="C:\Program Files\Linksys\LogViewer\LogViewer.exe"

call taskkill /IM %APPNAME%

ping 127.0.0.1

call taskkill /F /IM %APPNAME% /T

call %APPSLOCATION%\bmail -s %SERVERNAME% -t %EMAILTO% -f %EMAILFROM% -a %SUBJECT% -m "%ATTACHMENT%" -c

erase %ATTACHMENT% /f /q

call %APPTOSTART%

set SERVERNAME=
set EMAILTO=
set EMAILFROM=
set SUBJECT=
set ATTACHMENT=
set APPSLOCATION=
set APPNAME=
set APPTOSTART=


: +---------+
: |   END   |
: +---------+
