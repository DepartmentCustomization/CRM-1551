
  SELECT ROW_NUMBER() OVER(ORDER BY UserName) Id, [UserId], UserName, UserFIO
  FROM
  (
  SELECT DISTINCT [UserId], UserName, 
	ISNULL([LastName]+N' ', N'')+ISNULL([FirstName], N'')+ISNULL(N' '+[Patronymic], N'') UserFIO
  FROM [dbo].[Звернення УГЛ] zu
  INNER JOIN [#system_database_name#].[dbo].[User] u ON zu.[Опрацював]=u.UserId) t
  WHERE #filter_columns#
  ORDER BY UserName
  OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS only
