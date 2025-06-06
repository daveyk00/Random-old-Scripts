:: Calendar.cmd   2008-12-30  Matthias Tacke
:: This batch is based on code posted in this thread:
:: <http://groups.google.com/group/alt.msdos.batch.nt/browse_thread/thread/f4a8fb93d94583a1>
@echo off&setlocal
if "%~1"=="" goto :Usage
:loop
if /I "%1"=="/?" goto :Usage
if /I "%1"=="/S" shift&set /A "cStOfWeek=0,ofs=1"&shift&goto loop
if /I "%1"=="/M" shift&set /A "cStOfWeek=3,ofs=0"&shift&goto loop
for %%A in (EN ES DE FR
  ) do if /I "%1"=="%%A" set "cLocale=%%A"&Shift&goto loop
IF %1. GEQ 1900. if %1. LEQ 2099. set Year=%1&shift&goto loop
shift
if NOT "%1"=="" goto loop
if NOT defined Year set year=%date:~-4%
if NOT defined ofs set /A "cStOfWeek=3,ofs=0"
if Not defined cLocale set cLocale=EN
:: option processing ready, prepare vars
call :Getlocale %cLocale% sMon sWeek
for %%A in (%sMon%) do set /A n+=1 & call set sMon[%%n%%]=%%A
set "sSpc=          "
for /L %%A in (1 1 4) do call set sSpc=%%sSpc%%%%sSpc%%
for /L %%A in (1 1 31
  ) do set /A _=100+%%A &call set "sDay=%%sday%% %%_:~-2%%"
set sDay=%sDay: 0=  %
:: Get strings for whole year
for /L %%A in (1 1 12) do (
call :GetsMonth %year% %%A %%A sDisp
)
:: Output prepared months in 4 rows and 3 cols
echo/&echo/
for /l %%r in (0 3 9) do (
  for /l %%i in (0,21,189) do (
    for /l %%c in (0 1 2) do (
      call set /A "X=%%r+%%c+1"
      call call set /P _=%%%%sDisp[%%X%%]:~%%i,21%%%%  <NUL
    )
  echo/)
)
goto :eof
:GetsMonth %year% %mon% %X% sDisp
setlocal&set Year=%1&set Mon=%2
set /A "YxD=(Year-1901)*365,LeapYs=(Year-1901)/4"
set /A "MLeapDay=(!(Year %% 4))*(!((Mon-3)&16))"
set /A "DoY=(Mon-1)*30-1+((0x3E92524>>(Mon*2))&3)+2*(!((Mon-7)&16))"
set /A "MoWD1st=(YxD+LeapYs+DoY+MLeapDay+ofs-6)%%7"
set /A "MoDays=28+(0x3BBEECC>>(Mon*2)&3)+(!(Year %%4))*(!(Mon-2))"
set /A "Pre=MoWD1st*3,Len=MoDays*3
call set sDisp=     %%sMon[%2]%% %Year%%sSpc%
call set sDisp=%sDisp:~0,42%%%sWeek:~%cStofWeek%,21%%
call set sDisp=%sDisp%%%sSpc:~0,%Pre%%%%%sDay:~0,%Len%%%%sSpc%
endlocal&set "%4[%3]=%sDisp%"&goto :eof
::
:GetLocale cLocale
setlocal
::  ----- cLocale DE presets -----
set "sWeekDE= So Mo Di Mi Do Fr Sa So "
set "sMonDE=Januar Februar Maerz April Mai Juni Juli August"
set "sMonDE=%sMonDE% September Oktober November Dezember"
::  ----- cLocale EN presets -----
set "sWeekEN= Su Mo Tu We Th Fr Sa Su "
set "sMonEN=January February March April May June July August"
set "sMonEN=%sMonEN% September October November December"
::  ----- cLocale FR presets -----
set "sWeekFR= Di Lu Ma Me Je Ve Sa Di "
set "sMonFR=Janvier Fevrier Mars Avril Mai Juin Juillet Aout"
set "sMonFR=%sMonFR% Septembre Octobre Novembre D+cembre"
::  ----- cLocale ES presets -----
set "sWeekES= Do Lu Ma Mi Ju Vi Sa Do "
set "sMonES=Enero Febrero Marzo Abril Mayo Junio Julio Agosto"
set "sMonES=%sMonES% Septiembre Octubre Noviembre Diciembre"
::
call set sMon=%%sMon%1%%
call set sWeek=%%sWeek%1%%
endlocal&set "%2=%sMon%"&set "%3=%sWeek%"&goto :eof
:Usage
echo =====================================================
echo.Usage:   %~f0 4digitYear
echo/
echo          Outputs a year calendar, months arranged in
echo          3 columns and 4 rows
echo/
echo options: [/M^|/S] [EN^|DE^|ES^|FR] [/?]
echo          Order of Options doesn't matter
echo          [/M^|/S] Week starts on [/S]unday [/M]onday
echo          [EN^|DE^|ES^|FR] Language to use
echo          [/?] output this help screen
echo          Defalts are /M and EN
echo =====================================================
set /P Year=Enter 4 digit Year between 1901 and 2099 :
endlocal&%~f0 %Year% 