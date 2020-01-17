select [Organizations].Id
, [Organizations].short_name

  from [dbo].[Organizations]
  where  [programworker] = 1
  
  and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only