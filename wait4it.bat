::Demo-WaitMsg.cmd:::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
Call :WaitMsg ....Whatever you want to display....
pause
goto :EOF
::Sub WaitMsg::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:WaitMsg messages containing no qoutes
setlocal&set "LoopCnt=1000"&set "cnt=0"&set "step=1"&set text=%*
:WaitMLoop
cls&echo.&set /A cnt+=step
call set txt=%%text:~-%cnt%%%
for %%a in (/ - \ ^| / - \ ^|) do (echo ^%%a%txt%
for /L %%b in (1,1,%LoopCnt%) do set dummy=%%b
cls & echo.)
if %cnt%. EQU 0. goto :eof
if "%txt%" NEQ "%text%" goto :WaitMLoop
echo %text%
ping -n 3 127.0.0.1 >nul
cls&echo.&set step=-1
goto :WaitMLoop
::Demo-WaitMsg.cmd::::::::::::::::::::::::::::::::::::::::::::::::::: 