

--declare @history_id int = 5837297
declare @history_id_old int = (select top 1 Id from [dbo].[Assignment_History] 
							   where [Log_Date] < (select Log_Date from [dbo].[Assignment_History] where Id = @history_id) 
							   and [assignment_id] = (select [assignment_id] from [dbo].[Assignment_History] where Id = @history_id)
							   order by [Log_Date] desc)

--select @history_id, @history_id_old


if object_id('tempdb..#temp_OUT') is not null drop table #temp_OUT
create table #temp_OUT(
[history_id] int,
[history_type_name]  nvarchar(100),
[history_value_old]  nvarchar(500),
[history_value_new]  nvarchar(500),
)

insert into #temp_OUT([history_id], [history_type_name], [history_value_old],[history_value_new])
select  t1.Id, N'Стан доручення' as [history_type_name], 
	   qt2.[name] as [history_value_old],
	   qt1.[name] as [history_value_new]
from [dbo].[Assignment_History] as t1
left join [dbo].[Assignment_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[AssignmentStates] as qt1 on qt1.Id = t1.assignment_state_id
left join [dbo].[AssignmentStates] as qt2 on qt2.Id = t2.assignment_state_id
where t1.Id = @history_id

union all 
select t1.Id, N'Взято в роботу' as [history_type_name], 
	   convert(varchar,t2.[transfer_date],104) + ' ' +convert(varchar,t2.[transfer_date],108) as [history_value_old],
	   convert(varchar,t1.[transfer_date],104) + ' ' +convert(varchar,t1.[transfer_date],108) as [history_value_new]
from [dbo].[Assignment_History] as t1
left join [dbo].[Assignment_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Виконавець' as [history_type_name], 
	   IIF(len([Organizations2].[head_name]) > 5,  isnull([Organizations2].[head_name],N''),  isnull([Organizations2].[short_name],N'')) as [history_value_old],
	   IIF(len([Organizations1].[head_name]) > 5,  isnull([Organizations1].[head_name],N''),  isnull([Organizations1].[short_name],N'')) as [history_value_new]
from [dbo].[Assignment_History] as t1
left join [dbo].[Assignment_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[Organizations] as [Organizations1] on [Organizations1].Id = [t1].[executor_organization_id]
left join [dbo].[Organizations] as [Organizations2] on [Organizations2].Id = [t2].[executor_organization_id]
where t1.Id = @history_id

union all 
select t1.Id, N'Головний' as [history_type_name], 
	   case when t2.main_executor = 1 then N'Так' else N'Ні' end as [history_value_old],
	   case when t1.main_executor = 1 then N'Так' else N'Ні' end as [history_value_new]
from [dbo].[Assignment_History] as t1
left join [dbo].[Assignment_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all
select  t1.Id, N'Результат' as [history_type_name], 
	   qt2.[name] as [history_value_old],
	   qt1.[name] as [history_value_new]
from [dbo].[Assignment_History] as t1
left join [dbo].[Assignment_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[AssignmentResults] as qt1 on qt1.Id = t1.AssignmentResultsId
left join [dbo].[AssignmentResults] as qt2 on qt2.Id = t2.AssignmentResultsId
where t1.Id = @history_id

union all
select  t1.Id, N'Резолюція' as [history_type_name], 
	   qt2.[name] as [history_value_old],
	   qt1.[name] as [history_value_new]
from [dbo].[Assignment_History] as t1
left join [dbo].[Assignment_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[AssignmentResolutions] as qt1 on qt1.Id = t1.AssignmentResolutionsId
left join [dbo].[AssignmentResolutions] as qt2 on qt2.Id = t2.AssignmentResolutionsId
where t1.Id = @history_id

union all 
select t1.Id, N'Коментар' as [history_type_name], 
	   t2.short_answer as [history_value_old],
	   t1.short_answer as [history_value_new]
from [dbo].[Assignment_History] as t1
left join [dbo].[Assignment_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id


select * 
from #temp_OUT
where isnull([history_value_old],N'') != isnull([history_value_new],N'')
and #filter_columns#
    --  #sort_columns#
    order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only