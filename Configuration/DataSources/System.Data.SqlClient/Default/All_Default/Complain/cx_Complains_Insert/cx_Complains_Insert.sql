INSERT INTO [dbo].[Complain]
           ([registration_date]
           ,[complain_type_id]
           ,[culpritname]
           ,[guilty]
           ,[text]
           ,[user_id])
     VALUES
           (GETUTCDATE()
           ,@complain_type_id
           ,@culpritname
           ,@guilty
           ,@text
           ,@user_id)