
declare @output table (Id int)
declare @new_id int;

insert into [dbo].[ControlComments]
  (
  [name]
      ,[control_type_id]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date]
      ,[template_name]
  )

  output inserted.Id into @output(Id)

  select @name
      ,@control_type_id
      ,@user_id
      ,getutcdate() [create_date]
      ,@user_id [user_edit_id]
      ,getutcdate() [edit_date]
      ,@template_name

set @new_id = (select top 1 Id from @output)
select @new_id Id
return;