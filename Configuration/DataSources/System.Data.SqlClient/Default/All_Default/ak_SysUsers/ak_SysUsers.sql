select [UserId], [UserName], [FirstName], LastName, Patronymic
, isnull(LastName, N'')+N' '+isnull([FirstName], N'')+N' '+isnull([Patronymic], N'') fio
  from [#system_database_name#].[dbo].[User]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only