SELECT  [Id]
      ,[short_name]
  FROM [dbo].[Organizations]
  WHERE programworker = 1 ;
--   and  #filter_columns#
--      #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only