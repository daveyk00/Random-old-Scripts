@echo off
dir %1|find "bytes"|find /v "bytes free"