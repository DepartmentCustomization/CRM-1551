select Id, Name
from (

select 1 Id, N'1' name
union all
select 2 Id, N'2' name
union all
select 3 Id, N'3' name
union all
select 4 Id, N'4' name
union all
select 5 Id, N'5 і більше' name) t
 where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
