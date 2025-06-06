:: +---------------+
:: | List Filesize |
:: +---------------+

:: This program will take a filename on command line, and list number of files matched and total size.
:: Running the program without parameters will list all files in current directory.

:: Usage: ListFileSize <Name of file>

:: EG: ListSizeByWildCard.bat wmilist.txt
@echo off

if "%1"=="" goto NotCorrectCommandLineParameters

@echo %~f1 has filesize of %~z1 bytes

goto end

:NotCorrectCommandLineParameters
echo.
echo Usage: ListFileSize.bat NameOfFile.ext
echo        ListFileSize.bat c:\wmilist.txt
echo.

:end