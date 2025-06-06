: +--------------+
: | Cleanup v1.2 |
: +--------------+

: Script that deletes *.tmp, *.dmp, %temp%, %windir%\temp, and then defrags

: Erase *.tmp
: Erase *.dmp
: Erase %temp%
: Erase %windir%\temp
: Perform forced defrag on all volumes

: +---------+
: |  START  |
: +---------+

c:
cd\
erase /s /f *.tmp
erase /s /f *.dmp
rd /q/s %temp%
rd /q/s %windir%\temp
defrag -c -f -v

: +---------+
: |   END   |
: +---------+