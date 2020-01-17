SELECT [Id]
      ,[name]
  FROM [dbo].[ObjectTypes]
  WHERE Id not between 100 and 124
  and
     #filter_columns#
    #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only