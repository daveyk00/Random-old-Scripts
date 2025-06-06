:: tee.bat
:: Example: tee logfile.log COPY "c:\myfolder\*.txt" "d:\backup\"
::          tee "My log.log" dir c:\*.sys /b
@ECHO OFF
set logfile="%~1"
if exist %logfile% del %logfile%
set "var=%*"
set "var=%var:*.log =%"
set "var=%var:*.log" =%"
for /F "tokens=1* delims=]" %%a IN (
'%var% 2^>^&1^|find /v /n ""'
) DO (
set /p"=%%b"<nul
echo.
set /p"=%%b"<nul>>%logfile%
echo.>>%logfile%
)
