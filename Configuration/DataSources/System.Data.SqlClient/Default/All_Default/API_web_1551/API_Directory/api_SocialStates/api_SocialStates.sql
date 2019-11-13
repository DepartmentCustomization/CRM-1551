SELECT [Id]
      ,[name]
  FROM [dbo].[SocialStates]
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only