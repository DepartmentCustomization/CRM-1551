SELECT [id]
      ,[name]
  FROM [dbo].[SiteAppealsStates]
  where  #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only