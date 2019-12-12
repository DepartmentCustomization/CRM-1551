 select Id, Name
 from
 (select 1 Id, N'Жінка' Name
 union all
 select 2 Id, N'Чоловік' Name
 ) t
 where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only