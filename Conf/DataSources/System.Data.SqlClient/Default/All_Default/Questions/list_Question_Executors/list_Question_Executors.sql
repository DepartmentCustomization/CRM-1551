  select [UserId] Id, ISNULL([LastName], N'') + N' ' + ISNULL([FirstName],N'')+N' '
  +ISNULL([Patronymic], N'') name
  from [#system_database_name#].[dbo].[User]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only