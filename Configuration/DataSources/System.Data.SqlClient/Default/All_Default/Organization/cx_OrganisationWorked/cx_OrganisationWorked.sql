select row_number() over(order by UserId) Id, [UserId], [PhoneNumber], UserName, [FirstName], LastName
  from [#system_database_name#].[dbo].[User]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 