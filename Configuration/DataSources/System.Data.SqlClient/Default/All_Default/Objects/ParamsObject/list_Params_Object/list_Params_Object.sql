SELECT [Id]
      ,[name]
  FROM [dbo].[ParamsObjects]
  where #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only