SELECT Id, [Name]
FROM
(
SELECT 0 Id, N'Усі' [Name]
UNION ALL
SELECT Id, [Name]
FROM [dbo].[Districts]
) t
where #filter_columns#
  --#sort_columns#
  order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only