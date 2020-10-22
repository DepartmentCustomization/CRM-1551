SELECT worker_user_id [Id]
      ,[name]
  FROM   [dbo].[Workers]
  where len(isnull(worker_user_id,N'')) > 0 
  and #filter_columns#
  #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only