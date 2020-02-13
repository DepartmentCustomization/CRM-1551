
SELECT Id, Name
  FROM [dbo].[Categories]
  WHERE [is_emergensy]='true'
  AND #filter_columns#
  --#sort_columns#
  ORDER BY 1
 offset @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY