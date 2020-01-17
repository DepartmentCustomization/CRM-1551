SELECT [Id]
      ,[name]
  FROM [dbo].[AssignmentTypes]
  where #filter_columns#
    #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only