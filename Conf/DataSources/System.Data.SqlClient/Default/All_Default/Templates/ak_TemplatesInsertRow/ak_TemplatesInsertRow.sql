  declare @app_id int;
  declare @output table (Id int);

  insert into [Templates]
  (
  [name]
      ,[organization_id]
      ,[content]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date]
  )

output [inserted].[Id] into @output (Id)

  select @name 
  ,(select top 1 organizations_id from [Positions] where active='true' and programuser_id=@user_Id)
  ,@content
  ,@user_Id
  ,GETUTCDATE()
  ,@user_Id
  ,GETUTCDATE()

  set @app_id = (select top 1 Id from @output )


  select @app_id	as [Id]
return;