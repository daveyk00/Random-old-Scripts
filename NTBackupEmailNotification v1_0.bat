: +--------------------------+
: | Email backup reports 1.0 |
: +--------------------------+

: Backup script that includes email notification

: Requires: bmail.exe

: Removes the archive bit from all current reports
: Perform the backup (by default the report is set with the archive bit)
: copy reports with the archive bit to %BACKUPAPPS\*.log (will only be 1 report)
: rename reports to results.log
: Execute bmail and send the email using the variables listed below.
: Erase the copy of the log files in %BACKUPAPPS%
: release environment variables

: Set variables:
: 	SERVERNAME is the smtp server used
:	EMAILTO / EMAILFROM / SUBJECT all self explanitory
:	ATTACHMENT is the name of the attachment to use in the body
:	BACKUPLOGSLOCATION is the default location in SBS2003 that backup reports are stored
:	BACKUPAPPS is the location of bmail and the temporary storage location of the reports

: +---------+
: |  START  |
: +---------+

@echo off

set SERVERNAME=smtp
set EMAILTO=recipient@example.com
set EMAILFROM=sendder@example.com
set SUBJECT=BackupReport
set ATTACHMENT=c:\backupapplications\recent.log
set BACKUPLOGSLOCATION=C:\Documents and Settings\Administrator\Local Settings\Application Data\Microsoft\Windows NT\NTBackup\data
set BACKUPAPPS=c:\backupapplications

attrib -a "%BACKUPLOGSLOCATION%\*.*"

C:\WINDOWS\system32\ntbackup.exe backup "@c:\test.bks" /n "TEST" /d "Testing Purposes only" /v:no /r:no /rs:no /hc:off /m normal /j "system" /l:s /f "c:\test.bkf"

xcopy "%BACKUPLOGSLOCATION%\*.log" "%BACKUPAPPS%" /y /m
ren %BACKUPAPPS%\backup??.log recent.log

call %BACKUPAPPS%\bmail -s %SERVERNAME% -t %EMAILTO% -f %EMAILFROM% -a %SUBJECT% -m "%ATTACHMENT%" -c

erase %BACKUPAPPS%\*.log

set SERVERNAME=
set EMAILTO=
set EMAILFROM=
set SUBJECT=
set ATTACHMENT=
set BACKUPLOGSLOCATION=
set BACKUPAPPS=


: +---------+
: |   END   |
: +---------+
