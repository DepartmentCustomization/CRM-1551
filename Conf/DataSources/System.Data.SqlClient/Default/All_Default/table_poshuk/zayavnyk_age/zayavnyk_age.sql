select Id, name
from
(select 1 Id, N'16-20' name
union all
select 2 Id, N'21-30' name
union all
select 3 Id, N'31-40' name
union all
select 4 Id, N'41-50' name
union all
select 5 Id, N'51-60' name
union all
select 6 Id, N'61-70' name
union all
select 7 Id, N'71-80' name
union all
select 8 Id, N'81-90' name
union all
select 9 Id, N'91-100' name
union all
select 10 Id, N'101-110' name) t
where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only

