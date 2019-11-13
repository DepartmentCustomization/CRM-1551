update [CRM_1551_Analitics].[dbo].[Events]
   set [File]=@File,
        [FileName] = @Name
   where Id=@EventId