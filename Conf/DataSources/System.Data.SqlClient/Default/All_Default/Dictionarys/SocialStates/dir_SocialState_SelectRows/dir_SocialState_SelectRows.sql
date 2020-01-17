SELECT [Id]
      ,[name]
  FROM [dbo].[SocialStates]
  WHERE 
    #filter_columns#
    #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only