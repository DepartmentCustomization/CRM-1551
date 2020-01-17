select Id, [short_name]
  from [CRM_1551_Analitics].[dbo].[Organizations]
  where [programworker]=N'true'
--   and #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only