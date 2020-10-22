select [ControlComments].Id, [ControlComments].[template_name], [ControlComments].[name],
  [ControlComments].control_type_id, [ControlTypes].name control_type_name, 
  --[user_id],
  ISNULL([User].FirstName,N'')+ISNULL(N' '+[User].LastName, N'') [user_create],
  [create_date],
  ISNULL([User_Edit].FirstName,N'')+ISNULL(N' '+[User_Edit].LastName, N'') [user_edit],
  [ControlComments].[edit_date]
  from [dbo].[ControlComments]
  left join [dbo].[ControlTypes] on [ControlComments].control_type_id=[ControlTypes].Id
  left join [#system_database_name#].[dbo].[User] on [ControlComments].user_id=[User].UserId
  left join [#system_database_name#].[dbo].[User] [User_Edit] on [ControlComments].[user_edit_id]=[User_Edit].UserId
  where [ControlComments].Id=@Id