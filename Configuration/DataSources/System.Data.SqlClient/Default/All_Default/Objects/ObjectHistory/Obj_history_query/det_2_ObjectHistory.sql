-- declare @history_id int = 2
declare @history_id_old int = (select top 1 Id from [dbo].[Object_History] 
							   where [Log_Date] < (select Log_Date from [dbo].[Object_History] where Id = @history_id) 
							   and building_id = (select building_id from [dbo].[Object_History] where Id = @history_id)
							   order by [Log_Date] desc)

-- select @history_id, @history_id_old

if object_id('tempdb..#temp_Obj2') is not null drop table #temp_Obj2
create table #temp_Obj2(
[history_id] int,
[history_type_name]  nvarchar(100),
[history_value_old]  nvarchar(500),
[history_value_new]  nvarchar(500),
)

insert into #temp_Obj2([history_id], [history_type_name], [history_value_old],[history_value_new])
select  t1.Id, N'Тип об`єкта' as [history_type_name], 
	   at2.[name] as [history_value_old],
	   at1.[name] as [history_value_new]
from [dbo].[Object_History] as t1
left join [dbo].[Object_History] as t2 on t2.Id = @history_id_old 
left join [dbo].ObjectTypes as at1 on at1.Id = t1.object_type_id
left join [dbo].ObjectTypes as at2 on at2.Id = t2.object_type_id
where t1.Id = @history_id

union all 
select t1.Id, N'Назва об`єкта' as [history_type_name], 
	   t2.[name] as [history_value_old],
	   t1.[name] as [history_value_new] 
from [dbo].[Object_History] as t1
left join [dbo].[Object_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Будинок' as [history_type_name], 
	st2.shortname + ' ' + s2.[name] + ' ' + at2.[name] as [history_value_old],
    st1.shortname + ' ' + s1.[name] + ' ' + at1.[name] as [history_value_new]
from [dbo].[Object_History] as t1
left join [dbo].[Object_History] as t2 on t2.Id = @history_id_old 
left join [dbo].Buildings as at1 on at1.Id = t1.building_id
left join [dbo].Buildings as at2 on at2.Id = t2.building_id
left join Streets s1 on s1.Id = at1.street_id
left join Streets s2 on s2.Id = at2.street_id
left join StreetTypes st1 on st1.Id = s1.street_type_id
left join StreetTypes st2 on st2.Id = s2.street_type_id
where t1.Id = @history_id

union all 
select t1.Id, N'Значення активності' as [history_type_name], 
       case when t2.is_active = 1 then 'Так' when t2.is_active = 0 then 'Ні' end as [history_value_old],
	   case when t1.is_active = 1 then 'Так' when t1.is_active = 0 then 'Ні' end as [history_value_old]
from [dbo].[Object_History] as t1
left join [dbo].[Object_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id


select * 
from #temp_Obj2
where isnull([history_value_old],N'') != isnull([history_value_new],N'')
  and #filter_columns#
    --  #sort_columns#
    order by 1
-- offset @pageOffsetRows rows fetch next @pageLimitRows rows only