declare @ConfigDB varchar(255);
declare @ConfigDBLog varchar(255);
declare @ConfigDBCmd varchar(255);
select @ConfigDB =  name from sys.databases where name like 'SharePoint_Config_%';
set @ConfigDBCmd = 'BACKUP database [' + RTRIM(@ConfigDB) + '] to disk=''C:\windows\temp\before.bkf''';
execute(@ConfigDBCmd);
set @ConfigDBCmd = 'use [' + RTRIM(@COnfigDB) + ']';
execute(@ConfigDBCmd);
set @ConfigDBCmd = 'BACKUP LOG [' + RTRIM(@ConfigDB) + '] WITH TRUNCATE_ONLY';
execute(@ConfigDBCmd);
set @ConfigDBCmd = 'use [' + RTRIM(@COnfigDB) + ']';
execute(@ConfigDBCmd);
select @ConfigDBLog =  name from sys.database_files where name like 'SharePoint_Config%_log';
set @ConfigDBCmd = 'use [' +  RTRIM(@ConfigDB) + '] DBCC SHRINKFILE([' + RTRIM(@ConfigDB) + '_log],1)';
execute(@ConfigDBCmd);
set @ConfigDBCmd = 'BACKUP database [' + RTRIM(@ConfigDB) + '] to disk=''C:\windows\temp\after.bkf''';
execute(@ConfigDBCmd);
go