:: WSUS Maintenance
:: 1.1

:: This will:
:: Perform a reindex of the database if required, according to:
:: 		Page Count > 50 and Average Fragmentation > 15%, or
::		Page Count > 10 and Average Fragmentation > 80%, or
::		Average Page Space Used < 85% and the Average Page Space Used,
::		is low enough that pages can be freed up by rebuilding the index
:: stop the Updates Services Service and the WSUS SQL database service
:: Contig the database
:: start the Updates Services Serivce and the WSUS SQL database service
:: Reboot the server if required

:: Credit for the WsusDBMaintenance.sql file:
:: http://gallery.technet.microsoft.com/scriptcenter/6f8cde49-5c52-4abd-9820-f1d270ddea61

:: REQUIREMENTS:
::
:: contig.exe (http://technet.microsoft.com/en-au/sysinternals/bb897428.aspx)
:: sqlcmd.exe (If using Windows internal Database, install the Management Tools - http://www.microsoft.com/en-us/download/details.aspx?id=30438)
::

:: VARIABLES:
::
:: DATABASESERVICE - The SQL Instance name of the WSUS database
::      Server 2003 / 2008 / 2008r2 default MSSQL$MICROSOFT##SSEE
::      Server 2012 default MSSQL$MICROSOFT##WID
:: CONTIGFILEPATH - The location to contig.exe.  eg:  c:\maintenance\contig.exe
:: WSUSREBOOT - reboot after running.  If this is set to lowercase y, the server will reboot with 60 second timer
:: SQLCMDFILEPATH - path to sqlcmd.exe
:: DATABASEPATH - path to the database files

@echo off

Set DATABASESERVICE=MSSQL$MICROSOFT##SSEE
set CONTIGFILEPATH=c:\maintenance\contig.exe
set WSUSREBOOT=y
set SQLCMDFILEPATH="c:\program files (x86)\microsoft sql server\100\tools\binn\sqlcmd.exe"
set DATABASEPATH=c:\wsus\UpdateServicesDBFiles\






:: ----- DO NOT CHANGE BELOW THIS LINE -----



Set UPDATESERVICE=wuauserv

if NOT exist %CONTIGFILEPATH% goto :CONTIGMISSING
if NOT exist %SQLCMDFILEPATH% goto :SQLCMDFILEMISSING

echo USE SUSDB; > %TEMP%\WsusDBMaintenance.sql
echo GO >> %TEMP%\WsusDBMaintenance.sql
echo SET NOCOUNT ON; >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @work_to_do TABLE (objectid int, indexid int , pagedensity float, fragmentation float, numrows int) >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @objectid int; >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @indexid int; >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @schemaname nvarchar(130); >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @objectname nvarchar(130); >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @indexname nvarchar(130); >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @numrows int >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @density float; >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @fragmentation float; >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @command nvarchar(4000); >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @fillfactorset bit >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE @numpages int >> %TEMP%\WsusDBMaintenance.sql
echo PRINT 'Estimating fragmentation: Begin. ' + convert(nvarchar, getdate(), 121) >> %TEMP%\WsusDBMaintenance.sql
echo INSERT @work_to_do >> %TEMP%\WsusDBMaintenance.sql
echo SELECT f.object_id, index_id, avg_page_space_used_in_percent, avg_fragmentation_in_percent, record_count >> %TEMP%\WsusDBMaintenance.sql
echo FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'SAMPLED') AS f >> %TEMP%\WsusDBMaintenance.sql
echo WHERE (f.avg_page_space_used_in_percent ^< 85.0 and f.avg_page_space_used_in_percent/100.0 * page_count ^< page_count - 1) or (f.page_count ^> 50 and f.avg_fragmentation_in_percent ^> 15.0) or (f.page_count ^> 10 and f.avg_fragmentation_in_percent ^> 80.0) >> %TEMP%\WsusDBMaintenance.sql
echo PRINT 'Number of indexes to rebuild: ' + cast(@@ROWCOUNT as nvarchar(20)) >> %TEMP%\WsusDBMaintenance.sql
echo PRINT 'Estimating fragmentation: End. ' + convert(nvarchar, getdate(), 121) >> %TEMP%\WsusDBMaintenance.sql
echo SELECT @numpages = sum(ps.used_page_count) >> %TEMP%\WsusDBMaintenance.sql
echo FROM @work_to_do AS fi >> %TEMP%\WsusDBMaintenance.sql
echo INNER JOIN sys.indexes AS i ON fi.objectid = i.object_id and fi.indexid = i.index_id >> %TEMP%\WsusDBMaintenance.sql
echo INNER JOIN sys.dm_db_partition_stats AS ps on i.object_id = ps.object_id and i.index_id = ps.index_id >> %TEMP%\WsusDBMaintenance.sql
echo DECLARE curIndexes CURSOR FOR SELECT * FROM @work_to_do >> %TEMP%\WsusDBMaintenance.sql
echo OPEN curIndexes >> %TEMP%\WsusDBMaintenance.sql
echo WHILE (1=1) >> %TEMP%\WsusDBMaintenance.sql
echo BEGIN >> %TEMP%\WsusDBMaintenance.sql
echo FETCH NEXT FROM curIndexes >> %TEMP%\WsusDBMaintenance.sql
echo INTO @objectid, @indexid, @density, @fragmentation, @numrows; >> %TEMP%\WsusDBMaintenance.sql
echo IF @@FETCH_STATUS ^< 0 BREAK; >> %TEMP%\WsusDBMaintenance.sql
echo SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name) >> %TEMP%\WsusDBMaintenance.sql
echo FROM sys.objects AS o >> %TEMP%\WsusDBMaintenance.sql
echo INNER JOIN sys.schemas as s ON s.schema_id = o.schema_id >> %TEMP%\WsusDBMaintenance.sql
echo WHERE o.object_id = @objectid; >> %TEMP%\WsusDBMaintenance.sql
echo SELECT @indexname = QUOTENAME(name), @fillfactorset = CASE fill_factor WHEN 0 THEN 0 ELSE 1 END >> %TEMP%\WsusDBMaintenance.sql
echo FROM sys.indexes >> %TEMP%\WsusDBMaintenance.sql
echo WHERE object_id = @objectid AND index_id = @indexid; >> %TEMP%\WsusDBMaintenance.sql
echo IF ((@density BETWEEN 75.0 AND 85.0) AND @fillfactorset = 1) OR (@fragmentation ^< 30.0) SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE'; >> %TEMP%\WsusDBMaintenance.sql
echo ELSE IF @numrows ^>= 5000 AND @fillfactorset = 0 SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD WITH (FILLFACTOR = 90)'; >> %TEMP%\WsusDBMaintenance.sql
echo ELSE SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD'; >> %TEMP%\WsusDBMaintenance.sql
echo PRINT convert(nvarchar, getdate(), 121) + N' Executing: ' + @command; >> %TEMP%\WsusDBMaintenance.sql
echo EXEC (@command); >> %TEMP%\WsusDBMaintenance.sql
echo PRINT convert(nvarchar, getdate(), 121) + N' Done.'; >> %TEMP%\WsusDBMaintenance.sql
echo END >> %TEMP%\WsusDBMaintenance.sql
echo CLOSE curIndexes; >> %TEMP%\WsusDBMaintenance.sql
echo DEALLOCATE curIndexes; >> %TEMP%\WsusDBMaintenance.sql
echo IF EXISTS (SELECT * FROM @work_to_do) >> %TEMP%\WsusDBMaintenance.sql
echo BEGIN >> %TEMP%\WsusDBMaintenance.sql
echo PRINT 'Estimated number of pages in fragmented indexes: ' + cast(@numpages as nvarchar(20)) >> %TEMP%\WsusDBMaintenance.sql
echo SELECT @numpages = @numpages - sum(ps.used_page_count) >> %TEMP%\WsusDBMaintenance.sql
echo FROM @work_to_do AS fi >> %TEMP%\WsusDBMaintenance.sql
echo INNER JOIN sys.indexes AS i ON fi.objectid = i.object_id and fi.indexid = i.index_id >> %TEMP%\WsusDBMaintenance.sql
echo INNER JOIN sys.dm_db_partition_stats AS ps on i.object_id = ps.object_id and i.index_id = ps.index_id >> %TEMP%\WsusDBMaintenance.sql
echo PRINT 'Estimated number of pages freed: ' + cast(@numpages as nvarchar(20)) >> %TEMP%\WsusDBMaintenance.sql
echo END >> %TEMP%\WsusDBMaintenance.sql
echo GO >> %TEMP%\WsusDBMaintenance.sql
echo PRINT 'Updating all statistics.' + convert(nvarchar, getdate(), 121) >> %TEMP%\WsusDBMaintenance.sql
echo EXEC sp_updatestats >> %TEMP%\WsusDBMaintenance.sql
echo PRINT 'Done updating statistics.' + convert(nvarchar, getdate(), 121) >> %TEMP%\WsusDBMaintenance.sql
echo GO >> %TEMP%\WsusDBMaintenance.sql

%SQLCMDFILEPATH% -S np:\\.\pipe\%DATABASESERVICE%\sql\query -i %TEMP%\WsusDBMaintenance.sql

net stop %UPDATESERVICE%
net stop %DATABASESERVICE%
%CONTIGFILEPATH% -v -s %DATABASEPATH%

net start %DATABASESERVICE%
net start %UPDATESERVICE%

if %WSUSREBOOT%==y shutdown /r /f /t 60
goto :CLEANUP

:CONTIGMISSING
echo.
echo contig.exe is missing
echo Download from http://technet.microsoft.com/en-au/sysinternals/bb897428.aspx
echo Expected location is %CONTIGFILEPATH%
echo Edit variable CONTIGFILEPATH if necessary
goto :CLEANUP

:SQLCMDFILEMISSING
echo.
echo SQLCMD.EXE is missing
echo If using Windows internal Database, install the Management Tools
echo http://www.microsoft.com/en-us/download/details.aspx?id=30438
echo Expected location %SQLCMDFILEPATH%
echo Edit variable SQLCMDFILEPATH if necessary
goto :CLEANUP

:CLEANUP
echo.
     
