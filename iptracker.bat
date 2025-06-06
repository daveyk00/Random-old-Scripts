@Echo off
SET BASE_IP=192.168.0.
SET START_IP=%1
SET END_IP=%2
IF "%START_IP%"=="" SET START_IP=1
IF "%END_IP%"=="" SET END_IP=254
date /t > IPList.txt
Time /t >> IPList.txt
echo =========== >> IPList.txt
For /L %%f in (%START_IP%,1,%END_IP%) Do ECHO PINGing %BASE_IP%%%f && Ping.exe -w 125 -i 64 -n 1 %BASE_IP%%%f | Find "timed out" && echo %BASE_IP%%%f Timed Out >> IPList.txt && echo off
cls
REM --- CleanUp
SET BASE_IP=
SET START_IP=
SET END_IP=
Echo Finished!
@Echo on
Notepad.exe IPList.txt
