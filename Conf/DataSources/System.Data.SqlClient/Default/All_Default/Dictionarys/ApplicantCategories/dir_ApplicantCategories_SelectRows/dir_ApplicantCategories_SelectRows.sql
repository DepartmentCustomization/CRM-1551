SELECT [Id]
      ,[name]
  FROM [dbo].[CategoryType]
    WHERE 
    #filter_columns#
    #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only