
INSERT INTO [dbo].[EventFiles]
           (
           [name]
           ,[file]
           ,[add_date]
           ,[event_id]
           ,[user]
           ,[edit_user_id]
           ,[edit_date])
           output [inserted].[Id]
     VALUES
           (
           @Name
           ,@File
           ,GETUTCDATE()
           ,@event_id
           ,@user
           ,@user
           ,GETUTCDATE()
           )

 
