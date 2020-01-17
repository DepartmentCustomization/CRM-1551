select Id, name
from
(
select 0 Id, N'Усі' name union all
select 1 Id, N'Січень' name union all
select 2 Id, N'Лютий' name union all
select 3 Id, N'Березень' name union all
select 4 Id, N'Квітень' name union all
select 5 Id, N'Травень' name union all
select 6 Id, N'Червень' name union all
select 7 Id, N'Липень' name union all
select 8 Id, N'Серпень' name union all
select 9 Id, N'Вересень' name union all
select 10 Id, N'Жовтень' name union all
select 11 Id, N'Листопад' name union all
select 12 Id, N'Грудень' name ) a
 where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only