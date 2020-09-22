
--declare @house_id int = 9820

if object_id('tempdb..#addressObject') is not null drop table #addressObject
create table #addressObject(
[RowNumb] int identity(1,1),
[Id]   int,
[Name] nvarchar(2000)
)

declare @sql nvarchar(max)
	set @sql = 'select * from
	OPENQUERY([213.186.192.201,1433],
	''select * from OPENQUERY([ODS_KIEV],''''select flats.id as value, flats.name as label from flats
	where house_id = '+convert(nvarchar(max),@house_id)+'
	order by LENGTH(flats.name),flats.name '''')'')'

insert into #addressObject ([Id], [Name])
exec sp_executesql @sql

select Id, Name 
from #addressObject
where #filter_columns#
--#sort_columns#
order by RowNumb
offset @pageOffsetRows rows fetch next @pageLimitRows rows only
