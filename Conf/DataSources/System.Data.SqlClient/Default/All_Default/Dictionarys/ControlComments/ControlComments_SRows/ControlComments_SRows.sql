select [ControlComments].Id, [ControlComments].[template_name], [ControlComments].[name],
  [ControlTypes].name control_type_name, 
  --[user_id],
  ISNULL([User].FirstName,N'')+ISNULL(N' '+[User].LastName, N'') [user_name],
  [create_date]
  from [dbo].[ControlComments]
  left join [dbo].[ControlTypes] on [ControlComments].control_type_id=[ControlTypes].Id
  left join [#system_database_name#].[dbo].[User] on [ControlComments].user_id=[User].UserId
  where 
  #filter_columns#
  #sort_columns#
  --order by 1
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only