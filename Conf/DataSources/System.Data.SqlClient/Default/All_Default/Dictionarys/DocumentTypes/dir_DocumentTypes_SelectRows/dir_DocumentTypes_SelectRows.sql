
SELECT [Id]
      ,[name]
  FROM [dbo].[DocumentTypes]
  where 
  #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only