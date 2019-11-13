delete  FROM MyFirstTable_FILESTREAM where Id = @Id  CHECKPOINT

declare @SqlText nvarchar(max)
set @SqlText = N'
USE [CRM_1551_Analitics];
/*Create a checkpoint on current database*/
CHECKPOINT;
/*Execute Garbage Collector after a checkpoint created*/
EXEC sp_filestream_force_garbage_collection  ''CRM_1551_Analitics'';
'
exec sp_executesql  @SqlText