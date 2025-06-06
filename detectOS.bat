@echo off

ver | find "5.2.3" > nul
if %ERRORLEVEL% == 0 goto ver_2003

ver | find "6.0.6" > nul
if %ERRORLEVEL% == 0 goto ver_2008Vista

ver | find "XP" > nul
if %ERRORLEVEL% == 0 goto ver_xp

ver | find "2000" > nul
if %ERRORLEVEL% == 0 goto ver_2000


:ver_2003
:: 2003 Specific commands
goto OSDetectionComplete

:ver_2008Vista
:: 2008Vista Specific commands
goto OSDetectionComplete

:ver_xp
:: XP Specific commands
goto OSDetectionComplete

:Ver_2000
:: 2000 Specific commands
goto OSDetectionComplete

echo OS is not recognised

:OSDetectionComplete