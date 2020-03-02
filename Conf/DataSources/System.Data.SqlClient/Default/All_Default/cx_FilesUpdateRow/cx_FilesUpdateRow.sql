UPDATE
     [CRM_1551_Analitics].[dbo].[Events]
SET
     [File] = @File,
     [FileName] = @Name
WHERE
     Id = @EventId ;