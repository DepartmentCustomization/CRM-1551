--declare @history_id int = 275
declare @history_id_old int = (select top 1 Id from [dbo].[Question_History] 
							   where [Log_Date] < (select Log_Date from [dbo].[Question_History] where Id = @history_id) 
							   and [question_id] = (select [question_id] from [dbo].[Question_History] where Id = @history_id)
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
select  t1.Id, N'Тип питання' as [history_type_name], 
	   qt2.[name] as [history_value_old],
	   qt1.[name] as [history_value_new]
from [dbo].[Question_History] as t1
left join [dbo].[Question_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[QuestionTypes] as qt1 on qt1.Id = t1.question_type_id
left join [dbo].[QuestionTypes] as qt2 on qt2.Id = t2.question_type_id
where t1.Id = @history_id

union all 
select t1.Id, N'Об`єкт' as [history_type_name], 
	   isnull([ObjectTypes2].[name]+N': ', N'')+isnull([StreetTypes2].[shortname]+' ',N'')+isnull([Streets2].[name]+N' ',N'')+isnull([Buildings2].[name],N'') as [history_value_old],
	   isnull([ObjectTypes1].[name]+N': ', N'')+isnull([StreetTypes1].[shortname]+' ',N'')+isnull([Streets1].[name]+N' ',N'')+isnull([Buildings1].[name],N'') as [history_value_new]
from [dbo].[Question_History] as t1
left join [dbo].[Question_History] as t2 on t2.Id = @history_id_old 
	left join [Objects] as [Objects1] on [Objects1].Id = t1.[object_id]
	left join [Buildings] as [Buildings1] on [Buildings1].Id = [Objects1].Id
	left join [Streets] as [Streets1] on [Streets1].Id = [Buildings1].street_id
	left join [StreetTypes] as [StreetTypes1] on [StreetTypes1].Id = [Streets1].street_type_id
	left join [ObjectTypes] as [ObjectTypes1] on [ObjectTypes1].Id = [Objects1].object_type_id	
	left join [Objects] as [Objects2] on [Objects2].Id = t2.[object_id]
	left join [Buildings] as [Buildings2] on [Buildings2].Id = [Objects2].Id
	left join [Streets] as [Streets2] on [Streets2].Id = [Buildings2].street_id
	left join [StreetTypes] as [StreetTypes2] on [StreetTypes2].Id = [Streets2].street_type_id
	left join [ObjectTypes] as [ObjectTypes2] on [ObjectTypes2].Id = [Objects2].object_type_id	
where t1.Id = @history_id

union all 
select t1.Id, N'Організація' as [history_type_name], 
	   qt2.[name] as [history_value_old],
	   qt1.[name] as [history_value_new]
from [dbo].[Question_History] as t1
left join [dbo].[Question_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[Organizations] as qt1 on qt1.Id = t1.organization_id
left join [dbo].[Organizations] as qt2 on qt2.Id = t2.organization_id
where t1.Id = @history_id

union all 
select t1.Id, N'Зміст' as [history_type_name], 
	   t2.[question_content] as [history_value_old],
	   t1.[question_content] as [history_value_new]
from [dbo].[Question_History] as t1
left join [dbo].[Question_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Виконавець' as [history_type_name], 
	   IIF(len([Organizations2].[head_name]) > 5,  isnull([Organizations2].[head_name],N''),  isnull([Organizations2].[short_name],N'')) as [history_value_old],
	   IIF(len([Organizations1].[head_name]) > 5,  isnull([Organizations1].[head_name],N''),  isnull([Organizations1].[short_name],N'')) as [history_value_new]
from [dbo].[Question_History] as t1
left join [dbo].[Question_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[Assignments] as [Assignments1] on [Assignments1].question_id = t1.question_id and [Assignments1].main_executor = 1
left join [dbo].[Organizations] as [Organizations1] on [Organizations1].Id = [Assignments1].[executor_organization_id]
left join [dbo].[Assignments] as [Assignments2] on [Assignments2].question_id = t2.question_id and [Assignments2].main_executor = 1
left join [dbo].[Organizations] as [Organizations2] on [Organizations2].Id = [Assignments2].[executor_organization_id]
where t1.Id = @history_id

union all 
select t1.Id, N'Дата контролю' as [history_type_name], 
	   convert(varchar,t2.[control_date],104) + ' ' +convert(varchar,t2.[control_date],108) as [history_value_old],
	   convert(varchar,t1.[control_date],104) + ' ' +convert(varchar,t1.[control_date],108) as [history_value_new]
from [dbo].[Question_History] as t1
left join [dbo].[Question_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all
select t1.Id, N'Стан питання' as [history_type_name], 
	   qt2.[name] as [history_value_old],
	   qt1.[name] as [history_value_new]
from [dbo].[Question_History] as t1
left join [dbo].[Question_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[QuestionStates] as qt1 on qt1.Id = t1.question_state_id
left join [dbo].[QuestionStates] as qt2 on qt2.Id = t2.question_state_id
where t1.Id = @history_id

union all
select t1.Id, N'Коментар оператора' as [history_operator_notes_name], 
	   t2.operator_notes as [history_value_old],
	   t1.operator_notes as [history_value_new]
from [dbo].[Question_History] as t1
left join [dbo].[Question_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id


select * 
from #temp_OUT
where isnull([history_value_old],N'') != isnull([history_value_new],N'')
and #filter_columns#
    --  #sort_columns#
    order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only