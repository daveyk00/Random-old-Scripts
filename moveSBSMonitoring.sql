-- https://docs.microsoft.com/en-us/sql/relational-databases/databases/move-user-databases?view=sql-server-2017

-- stop SQL copy the databases to the new location, start SQL and run this script to modify the SQL file location

USE master;  
GO  
-- Return the logical file name.  
SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files  
WHERE database_id = DB_ID(N'SBSMonitoring')  
GO  


-- Physically move the file to a new location.  
-- In the following statement, modify the path specified in FILENAME to  
-- the new location of the file on your server.  
ALTER DATABASE SBSMonitoring   
    MODIFY FILE ( NAME = SBSMonitoring_Log,   
                  FILENAME = 'F:\Program Files\Microsoft SQL Server\MSSQL10_50.SBSMONITORING\MSSQL\DATA\SBSMonitoring_Log.LDF');  
GO  

ALTER DATABASE SBSMonitoring   
    MODIFY FILE ( NAME = SBSMonitoring,   
                  FILENAME = 'F:\Program Files\Microsoft SQL Server\MSSQL10_50.SBSMONITORING\MSSQL\DATA\SBSMonitoring.MDF');  
GO  


ALTER DATABASE SBSMonitoring SET OFFLINE;  
GO  

ALTER DATABASE SBSMonitoring SET ONLINE;  
GO  
--Verify the new location.  
SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files  
WHERE database_id = DB_ID(N'SBSMonitoring') 
GO