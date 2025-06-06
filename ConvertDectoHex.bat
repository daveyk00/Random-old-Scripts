::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                                                          ::
::  DecToHex.cmd                                                            ::
::                                                                          ::
::       Author: Richard K. Bussey, Copyright All Rights Reserved           ::
::        EMail: rkb@binary-construction.com                                ::
::         Date: 08.24.06                                                   ::
::                                                                          ::
::  Description: Convert a passed decimal value to its hexidecimal          ::
::               equivalent.                                                ::
::                                                                          ::
::      History:                                                            ::
::                                                                          ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
echo DecToHex.cmd v1.0
echo Copyright: 2006, Richard K. Bussey; All Rights Reserved
echo.
setlocal

::
:: If no command line options specified go immediately to SYNTAX
::
if "%1"=="" goto SYNTAX

::
:: Set Global Defaults
::
set QUIET=FALSE
set DEBUG=FALSE
set SEPERATOR=FALSE
set /a Value=-1

::
:: Parse Command Line
::
:PARSE
if /i "%1"=="" goto ENDPARSE
if /i "%1"=="-d" (echo on & set DEBUG=TRUE)
if /i "%1"=="-v" (if "%2"=="" (goto SYNTAX) else (set /a Value=%2))
if /i "%1"=="-u" (set UPPER=TRUE)
if /i "%1"=="-e" (if "%2"=="" (goto SYNTAX) else (set ENVVARIABLE= %~2))
if /i "%1"=="-q" (set QUIET=TRUE)
if /i "%1"=="-s" (set SEPERATOR=TRUE)
shift
goto PARSE
:ENDPARSE

if "%Value%" equ "-1" @echo Value (-v n) required! & goto SYNTAX
if "%DEBUG%"=="" @echo off

::
:: DOS has 32 bit precision
::
set /a POSITION=8
set /a OriginalValue=Value

::
:: Convert decimal values up to 268435455 (0xfffffff)
::
if %Value% gtr 0xfffffff echo Value too large! & goto FINISH
if %Value% gtr 0xffffff set /a Divisor=16777216 & goto LOOP
if %Value% gtr 0xfffff set /a Divisor=1048576 & goto LOOP
if %Value% gtr 0xffff set /a Divisor=65536 & goto LOOP
if %Value% gtr 0xfff set /a Divisor=4096 & goto LOOP
if %Value% gtr 0xff set /a Divisor=256 & goto LOOP
if %Value% gtr 0xf set /a Divisor=16 & goto LOOP
set /a Divisor=1

:LOOP
if %Divisor% equ 1 goto HEX
:HEX
set /a POSITION=%POSITION% - 1
set /a p="Value/Divisor"
if %p% equ 0xf (if "%UPPER%"=="TRUE" (set p%POSITION%=F) else (set p%POSITION%=f))
if %p% equ 0xe (if "%UPPER%"=="TRUE" (set p%POSITION%=E) else (set p%POSITION%=e))
if %p% equ 0xd (if "%UPPER%"=="TRUE" (set p%POSITION%=D) else (set p%POSITION%=d))
if %p% equ 0xc (if "%UPPER%"=="TRUE" (set p%POSITION%=C) else (set p%POSITION%=c))
if %p% equ 0xb (if "%UPPER%"=="TRUE" (set p%POSITION%=B) else (set p%POSITION%=b))
if %p% equ 0xa (if "%UPPER%"=="TRUE" (set p%POSITION%=A) else (set p%POSITION%=a))
if %p% lss 0xa (set p%POSITION%=%p%)
if %Divisor% equ 1 goto DISPLAY
:CONTINUE
set /a Value=%Value% - (%p% * %Divisor%)
set /a Divisor=%Divisor% / 16
goto LOOP

:DISPLAY
if %QUIET% equ FALSE (
 if %POSITION% lss 4 (
  if %SEPERATOR% equ TRUE (
   echo Value: %OriginalValue%; HEX: 0x%p7%%p6%%p5%:%p4%%p3%%p2%%p1%
  ) else (
   echo Value: %OriginalValue%; HEX: 0x%p7%%p6%%p5%%p4%%p3%%p2%%p1%
  )
 ) else (
  if %SEPERATOR% equ TRUE (
   echo Value: %OriginalValue%; HEX: 0x%p7%%p6%:%p5%%p4%
  ) else (
   echo Value: %OriginalValue%; HEX: 0x%p7%%p6%%p5%%p4%
  )
 )
)
if "%ENVVARIABLE%" NEQ "" (
 endlocal
 if %POSITION% lss 4 (
  if %SEPERATOR% equ TRUE (
   set %ENVVARIABLE%=0x%p7%%p6%%p5%:%p4%%p3%%p2%%p1%
  ) else (
   set %ENVVARIABLE%=0x%p7%%p6%%p5%%p4%%p3%%p2%%p1%
  )
 ) else (
  if %SEPERATOR% equ TRUE (
   set %ENVVARIABLE%=0x%p7%%p6%:%p5%%p4%
  ) else (
   set %ENVVARIABLE%=0x%p7%%p6%%p5%%p4%
  )
 )
)
goto FINISH

:SYNTAX
echo DecToHex -v n [-d] [-u] [-e] [-q] [-s]
echo.
echo    v   Decimal value to convert; where n is the decimal value
echo.
echo    d   Turn debugging on (turn echo on; display all commands)
echo.
echo    u   Show Hex values in upper-case
echo.
echo    e   Save Hex value in provided Environment Variable
echo.
echo    q   Quiet mode (do not display results)
echo.
echo    s   Enable seperator (:) in Hex value
echo.
echo i.e. DecToHex -v 23452234 -u

:FINISH