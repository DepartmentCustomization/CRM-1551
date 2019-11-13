INSERT INTO [dbo].[QuestionDocFiles]
           ([create_date]
           ,[name]
           ,[File]
           ,[user_id]
           ,[edit_date]
           ,[edit_user_id]
           ,[question_id]
           )
	output [inserted].[Id]
     VALUES
           (getutcdate() 
           ,@Name
           ,@File
           ,@user_id
           ,getutcdate() 
           ,@user_id
           ,@question_id
           )
