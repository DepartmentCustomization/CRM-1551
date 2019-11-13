select row_number() over(order by UserId) Id, [UserId], [PhoneNumber], UserName, [FirstName], LastName
  from [CRM_1551_System].[dbo].[User]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 