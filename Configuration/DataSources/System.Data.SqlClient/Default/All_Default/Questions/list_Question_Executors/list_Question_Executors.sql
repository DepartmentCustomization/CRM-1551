  select [UserId] Id, ISNULL([LastName], N'') + N' ' + ISNULL([FirstName],N'')+N' '
  +ISNULL([Patronymic], N'') name
  from [CRM_1551_System].[dbo].[User]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only