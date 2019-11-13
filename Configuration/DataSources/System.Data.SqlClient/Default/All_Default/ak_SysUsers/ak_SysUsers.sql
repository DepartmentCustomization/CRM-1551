select [UserId], [UserName], [FirstName], LastName, Patronymic
, isnull(LastName, N'')+N' '+isnull([FirstName], N'')+N' '+isnull([Patronymic], N'') fio
  from [CRM_1551_System].[dbo].[User]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only