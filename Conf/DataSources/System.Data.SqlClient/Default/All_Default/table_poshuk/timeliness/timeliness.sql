SELECT Id, Name FROM (

    select 1 Id, N'Вчасно' Name
    union all
    select 2 Id, N'Не вчасно' Name
) t

where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only