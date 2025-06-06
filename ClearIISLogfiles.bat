::  ClearIISLogFiles

::  Clears files based on date / older than

::  Specifically designed for IIS Logfiles

::  requires forfiles.exe

:: LOCATION = location to search for files
:: EXT = file extension to act on
:: DAYS = files older than

set LOCATION=%windir%\system32\logfiles\w3svc1
set EXT=*.log
set DAYS=30

forfiles.exe -p %LOCATION% /m %EXT% /d -%DAYS% /c "cmd.exe /c del @path\"


