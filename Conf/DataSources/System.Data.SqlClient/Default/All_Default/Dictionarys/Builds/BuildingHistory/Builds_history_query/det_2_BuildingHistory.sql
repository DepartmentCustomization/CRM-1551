--declare @history_id int = 2
declare @history_id_old int = (select top 1 Id from [dbo].[Building_History] 
							   where [Log_Date] < (select Log_Date from [dbo].[Building_History] where Id = @history_id) 
							   and building_id = (select building_id from [dbo].[Building_History] where Id = @history_id)
							   order by [Log_Date] desc)

-- select @history_id, @history_id_old

if object_id('tempdb..#temp_Building2') is not null drop table #temp_Building2
create table #temp_Building2(
[history_id] int,
[history_type_name]  nvarchar(100),
[history_value_old]  nvarchar(500),
[history_value_new]  nvarchar(500),
)

insert into #temp_Building2([history_id], [history_type_name], [history_value_old],[history_value_new])
select  t1.Id, N'Район' as [history_type_name], 
	   at2.[name] as [history_value_old],
	   at1.[name] as [history_value_new]
from [dbo].[Building_History] as t1
left join [dbo].[Building_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[Districts] as at1 on at1.Id = t1.district_id
left join [dbo].[Districts] as at2 on at2.Id = t2.district_id
where t1.Id = @history_id

union all 
select t1.Id, N'Номер' as [history_type_name], 
	   t2.number as [history_value_old],
	   t1.number as [history_value_new]
from [dbo].[Building_History] as t1
left join [dbo].[Building_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Літера' as [history_type_name], 
	   t2.letter as [history_value_old],
	   t1.letter as [history_value_new]
from [dbo].[Building_History] as t1
left join [dbo].[Building_History] as t2 on t2.Id = @history_id_old 
where t1.Id = @history_id

union all 
select t1.Id, N'Індекс' as [history_type_name], 
	  t2.[index] as [history_value_old],
	  t1.[index] as [history_value_new]
from [dbo].[Building_History] as t1
left join [dbo].[Building_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all
select  t1.Id, N'Корпус' as [history_type_name], 
	    t2.bsecondname as [history_value_old],
	    t1.bsecondname as [history_value_new]
from [dbo].[Building_History] as t1
left join [dbo].[Building_History] as t2 on t2.Id = @history_id_old 
where t1.Id = @history_id

union all
select  t1.Id, N'Значення активності' as [history_type_name], 
	   case when t2.is_active = 1 then 'Так' when t2.is_active = 0 then 'Ні' end as [history_value_old],
	   case when t1.is_active = 1 then 'Так' when t1.is_active = 0 then 'Ні' end as [history_value_old]
from [dbo].[Building_History] as t1
left join [dbo].[Building_History] as t2 on t2.Id = @history_id_old 
where t1.Id = @history_id

select * 
from #temp_Building2
where isnull([history_value_old],N'') != isnull([history_value_new],N'')
  and #filter_columns#
    --  #sort_columns#
    order by 1
-- offset @pageOffsetRows rows fetch next @pageLimitRows rows only