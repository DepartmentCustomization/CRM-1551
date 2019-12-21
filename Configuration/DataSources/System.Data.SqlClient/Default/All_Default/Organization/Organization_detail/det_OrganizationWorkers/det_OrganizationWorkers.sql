SELECT
  [Positions].Id,
  isnull([User].FirstName, N'') + N' ' + isnull([User].LastName, N'') + N' ' + isnull([User].Patronymic, N'') name,
  [User].PhoneNumber,
  [Positions].position,
  [Positions].active,
  [Positions].organizations_id organization_id,
  [Positions].role_id,
  [Positions].programuser_id
FROM
  [CRM_1551_Analitics].[dbo].[Positions]
  LEFT JOIN [#system_database_name#].[dbo].[User] ON [Positions].programuser_id = [User].UserId
WHERE
  [Positions].organizations_id = @organization_id
  AND #filter_columns#
      #sort_columns#
  OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY