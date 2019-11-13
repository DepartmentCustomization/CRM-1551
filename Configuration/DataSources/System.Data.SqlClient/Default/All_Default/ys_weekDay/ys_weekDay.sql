select Id, name
from
(
select 0 Id, N'Усі' name union all
select 1 Id, N'Понедiлок' name union all
select 2 Id, N'Вiвторок' name union all
select 3 Id, N'Середа' name union all
select 4 Id, N'Четвер' name union all
select 5 Id, N'П`ятниця' name union all
select 6 Id, N'Субота' name union all
select 7 Id, N'Недiля' name ) a
  
 where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only