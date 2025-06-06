:: +------------------------------------+
:: | List Filesize using wildcards v1.0 |
:: +------------------------------------+

:: This program will take a filename on command line, and list number of files matched and total size.
:: Running the program without parameters will list all files in current directory.

:: Usage: ListSizeByWildCard.bat <Name of file>

:: EG: ListSizeByWildCard.bat *.txt
::   : ListSizeByWildCard.bat wmilist.txt

@echo off
dir %1|find "bytes"|find /v "bytes free"