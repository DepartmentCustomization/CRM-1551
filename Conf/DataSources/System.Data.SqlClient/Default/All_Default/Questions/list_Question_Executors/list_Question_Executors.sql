SELECT
  [UserId] Id,
  ISNULL([LastName], N'') + N' ' + ISNULL([FirstName], N'') + N' ' + ISNULL([Patronymic], N'') name
FROM
  [#system_database_name#].[dbo].[User]
WHERE
  #filter_columns#
  #sort_columns#
  OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY ;