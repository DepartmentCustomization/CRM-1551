  declare @app_id int;
  declare @output table (Id int);
  
  insert into [QuestionTypeTemplates]
  (
  [template_id]
      ,[question_type_id]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date]
  )

  output [inserted].[Id] into @output (Id)
  
  select @template_Id
      ,@question_type_id
      ,@user_id
      ,GETUTCDATE()
      ,@user_id
      ,GETUTCDATE()

      set @app_id = (select top 1 Id from @output )


  select @app_id	as [Id]
return;