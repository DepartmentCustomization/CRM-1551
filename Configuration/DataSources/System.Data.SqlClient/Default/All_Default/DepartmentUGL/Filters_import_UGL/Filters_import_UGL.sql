SELECT Id, Name FROM
(
SELECT  N'Неопрацьованi' Name, 0 Id 
union all 
SELECT  N'Опрацьованi' Name, 1 Id
union all
SELECT  N'Усi' Name, null Id
) t where #filter_columns#  
--#sort_columns#
order by case when Id = 0 then 1
when Id = 1 then 2 else 3 end
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only

