
declare @output table (Id int);


insert into [PersonExecutorChoose]
  (
  [name]
      ,[organization_id]
      ,[position_id]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date]
  )

  output [inserted].[Id] into @output (Id)

  select @name
      ,@organization_id
      ,@position_id
      ,@user_id
      ,GETUTCDATE()
      ,@user_id
      ,GETUTCDATE()


select top 1 Id from @output
return;