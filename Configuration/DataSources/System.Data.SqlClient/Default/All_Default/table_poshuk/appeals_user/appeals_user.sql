SELECT worker_user_id [Id]
      ,[name]
  FROM [CRM_1551_Analitics].[dbo].[Workers]
  where #filter_columns#
  #sort_columns#
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only