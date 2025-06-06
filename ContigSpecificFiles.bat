:: Contig Specific Files

:: This batch file will take a text file for input and perform contig on the files and directories listed, recursively.
::
:: Requires - contig.exe
:: http://technet.microsoft.com/en-us/sysinternals/bb897428
:: Must be run as administrator
::
:: Usage:
:: ContigSpecificFiles.bat inputfile
:: eg:
:: ContigSpecificFiles.bat inputfile.txt
::
:: Input file must contain a file or directory on each line

:: Variables:
:: CONTIGLOCATION - location of contig.exe


@echo off

set CONTIGLOCATION=c:\temp\contig.exe





:: +-------------------------------+
:: | DO NOT CHANGE BELOW THIS LINE |
:: +-------------------------------+


if not exist %CONTIGLOCATION% goto :CONTIGNOTFOUND
if "%1"=="" goto :PARAMETERSNOTCORRECT
set INPUTFILE=%1
if not exist %INPUTFILE% goto :INPUTFILENOTFOUND


FOR /F  "tokens=*" %%i IN (%1) DO call :PERFORMCONTIG "%%i"
goto :FINISHED


:CONTIGNOTFOUND
echo.
echo %CONTIGLOCATION% not found
echo.
echo contig.exe was expected at %CONTIGLOCATION%
echo.
goto :FINISHED


:PARAMETERSNOTCORRECT
echo.
echo Incorrect parameters specified.
echo.
echo :: Contig Specific Files
echo.
echo :: This batch file will take a text file for input and perform contig on the files and directories listed, recursively.
echo ::
echo :: Requires - contig.exe
echo :: http://technet.microsoft.com/en-us/sysinternals/bb897428
echo :: Must be run as administrator
echo ::
echo :: Usage:
echo :: ContigSpecificFiles.bat inputfile
echo :: eg:
echo :: ContigSpecificFiles.bat inputfile.txt
echo ::
echo :: Input file must contain a file or directory on each line
echo.
echo :: Variables:
echo :: CONTIGLOCATION - location of contig.exe
echo.
goto :FINISHED

:INPUTFILENOTFOUND
echo.
echo %INPUTFILE% not found
echo.
echo Input file was expected at %INPUTFILE%
echo.
goto :FINISHED


:PERFORMCONTIG
contig -s -v %1
goto :EOF

:FINISHED