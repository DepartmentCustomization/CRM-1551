
declare @UserBot nvarchar(128) = (select top 1 UserId from [#system_database_name#].[dbo].[User] where [UserName] = N'api_bot1551')

    INSERT INTO [CRM_1551_Analitics].[dbo].[QuestionDocFiles]
           ([create_date]
           ,[name]
           ,[File]
           ,[user_id]
           ,[edit_date]
           ,[edit_user_id]
           ,[question_id]
           )
    VALUES
           (getutcdate() 
           ,@Name
           ,@File
           ,@UserBot
           ,getutcdate() 
           ,@UserBot
           ,@question_id
           )

select N'ok' as [result]