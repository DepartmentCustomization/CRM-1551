
SELECT [id], [Name]
  FROM [dbo].[Classes]
  WHERE #filter_columns#
  ORDER BY 1--#sort_columns#
 offset @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY