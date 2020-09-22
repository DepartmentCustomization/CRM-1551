if object_id('tempdb..#addressObject') is not null drop table #addressObject
create table #addressObject(
[Id]   int,
[Name] nvarchar(2000)
)
	declare @sql nvarchar(max)
	set @sql = 'select * from
	OPENQUERY([213.186.192.201,1433],
	''select * from OPENQUERY([ODS_KIEV],''''select houses.id as value, concat(houses.number,houses.letter) as label from houses
	where street_id = '+convert(nvarchar(max),@street_id)+'
	order by 2 asc'''')'')'

insert into #addressObject ([Id], [Name])
exec sp_executesql @sql

select * 
from #addressObject
where #filter_columns#
--#sort_columns#
order by 2
offset @pageOffsetRows rows fetch next @pageLimitRows rows only