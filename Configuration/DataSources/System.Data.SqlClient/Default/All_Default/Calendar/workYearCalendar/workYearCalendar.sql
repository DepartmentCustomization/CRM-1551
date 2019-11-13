select Id, name
from
(
select 0 Id, N'2018' name union all
select 1 Id, N'2019' name union all
select 2 Id, N'2020' name union all
select 3 Id, N'2021' name union all
select 4 Id, N'2022' name union all
select 5 Id, N'2023' name union all
select 6 Id, N'2024' name union all
select 7 Id, N'2025' name union all
select 8 Id, N'2026' name union all
select 9 Id, N'2027' name union all
select 10 Id, N'2028' name union all
select 11 Id, N'2029' name union all
select 12 Id, N'2030' name ) a

 where #filter_columns#
  #sort_columns#
  
 --offset @pageOffsetRows rows fetch next @pageLimitRows rows only