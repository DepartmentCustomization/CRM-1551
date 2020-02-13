SELECT ROW_NUMBER() OVER(ORDER BY CASE WHEN UserId=@user_id THEN N'...aaaaa' ELSE UserName END) Id, [UserId], UserName, 
ISNULL([LastName]+N' ', N'')+ISNULL([FirstName], N'')+ISNULL(N' '+[Patronymic], N'') UserFIO
FROM [#system_database_name#].[dbo].[User]
WHERE  #filter_columns#
ORDER BY CASE WHEN UserId=@user_id THEN N'...aaaaa' ELSE UserName END
OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS only


