INSERT INTO [dbo].[QuestionDocFiles]
           (
           [name]
           ,[File]
           ,[create_date]
           ,[user_id]
           ,[edit_date]
           ,[edit_user_id]
           ,[question_id]
           )
	output [inserted].[Id]
     VALUES
           (
           @Name
           ,@File
           ,getutcdate() 
           ,@user_id
           ,getutcdate() 
           ,@user_id
           ,@question_id
           )
