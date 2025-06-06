: +--------------------+
: | Profile Backup 1.0 |
: +--------------------+

: Script that Backs up current users profile / Using RAR Compression / Keeping 7 runs

: requires winrar installed

: Keeps 7 runs:
:	delete number 7
:	rename 6->7, 5->6, 4->5......
:	backup using RAR to 1
: Release Environment Variables

: set Variables:
:	BACKUPLOCATION = Location of backups
:	RARLocation = location of rar.exe



: +---------+
: |  START  |
: +---------+

set BACKUPLOCATION=o:\profilebackup
set RARLOCATION="c:\program files\winrar\rar.exe"

erase %BACKUPLOCATION%\7.rar
ren %BACKUPLOCATION%\6.rar 7.rar
ren %BACKUPLOCATION%\5.rar 6.rar
ren %BACKUPLOCATION%\4.rar 5.rar
ren %BACKUPLOCATION%\3.rar 4.rar
ren %BACKUPLOCATION%\2.rar 3.rar
ren %BACKUPLOCATION%\1.rar 2.rar
%RARLOCATION% a -o+ -r %BACKUPLOCATION%\1.rar %userprofile%\*.*

set BACKUPLOCATIONS=
set RARLOCATION=

: +---------+
: |   END   |
: +---------+

