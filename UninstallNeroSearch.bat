rem Turn off Nero Scout and remove the search bar if Nero 7 is installed
if not exist "C:\Program Files\Nero\Nero 7\Core\nero.exe" goto :FINISHED
regsvr32 /u /s "%ProgramFiles%\Common Files\Ahead\Lib\NeroSearch.dll"
regsvr32 /u /s "%ProgramFiles%\Common Files\Ahead\Lib\NeroSearchBar.dll"
regsvr32 /u /s "%ProgramFiles%\Common Files\Ahead\Lib\NeroSearchTray.dll"
goto :FINISHED

:FINISHED