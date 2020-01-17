--declare @history_id int = 25
declare @history_id_old int = (select top 1 Id from [dbo].[Event_History] 
							   where [Log_Date] < (select Log_Date from [dbo].[Event_History] where Id = @history_id) 
							   and [event_id] = (select [event_id] from [dbo].[Event_History] where Id = @history_id)
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
select  t1.Id, N'Тип заходу' as [history_type_name], 
	   qt2.[name] as [history_value_old],
	   qt1.[name] as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[EventTypes] as qt1 on qt1.Id = t1.event_type_id
left join [dbo].[EventTypes] as qt2 on qt2.Id = t2.event_type_id
where t1.Id = @history_id

-- union all
-- select  t1.Id, N'Тип питання' as [history_type_name], 
-- 	   qt2.[name] as [history_value_old],
-- 	   qt1.[name] as [history_value_new]
-- from [dbo].[Event_History] as t1
-- left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old 
-- left join [dbo].[QuestionTypes] as qt1 on qt1.Id = t1.question_type_id
-- left join [dbo].[QuestionTypes] as qt2 on qt2.Id = t2.question_type_id
-- where t1.Id = @history_id

union all 
select t1.Id, N'Дата реєстрації' as [history_type_name], 
	   convert(varchar,t2.[registration_date],104) + ' ' +convert(varchar,t2.[registration_date],108) as [history_value_old],
	   convert(varchar,t1.[registration_date],104) + ' ' +convert(varchar,t1.[registration_date],108) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id


-- union all 
-- select t1.Id, N'Назва' as [history_type_name], 
-- 	   t2.[name] as [history_value_old],
-- 	   t1.[name] as [history_value_new]
-- from [dbo].[Event_History] as t1
-- left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
-- where t1.Id = @history_id


union all 
select t1.Id, N'Номер заяви Городка' as [history_type_name], 
	   rtrim(t2.[gorodok_id]) as [history_value_old],
	   rtrim(t1.[gorodok_id]) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id



union all 
select t1.Id, N'Дата початку' as [history_type_name], 
	   convert(varchar,t2.[start_date],104) + ' ' +convert(varchar,t2.[start_date],108) as [history_value_old],
	   convert(varchar,t1.[start_date],104) + ' ' +convert(varchar,t1.[start_date],108) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Планова дата завершення' as [history_type_name], 
	   convert(varchar,t2.[plan_end_date],104) + ' ' +convert(varchar,t2.[plan_end_date],108) as [history_value_old],
	   convert(varchar,t1.[plan_end_date],104) + ' ' +convert(varchar,t1.[plan_end_date],108) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Фактична дата завершення' as [history_type_name], 
	   convert(varchar,t2.[real_end_date],104) + ' ' +convert(varchar,t2.[real_end_date],108) as [history_value_old],
	   convert(varchar,t1.[real_end_date],104) + ' ' +convert(varchar,t1.[real_end_date],108) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Дата початку програвання' as [history_type_name], 
	   convert(varchar,t2.[audio_start_date],104) + ' ' +convert(varchar,t2.[audio_start_date],108) as [history_value_old],
	   convert(varchar,t1.[audio_start_date],104) + ' ' +convert(varchar,t1.[audio_start_date],108) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Дата закінчення програвання' as [history_type_name], 
	   convert(varchar,t2.[audio_end_date],104) + ' ' +convert(varchar,t2.[audio_end_date],108) as [history_value_old],
	   convert(varchar,t1.[audio_end_date],104) + ' ' +convert(varchar,t1.[audio_end_date],108) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Активний' as [history_type_name], 
	   case when t2.[active]=N'true' then N'Так' when t2.[active]=N'false' then N'Ні' end as [history_value_old],
	   case when t1.[active]=N'true' then N'Так' when t1.[active]=N'false' then N'Ні' end  as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Ділянка' as [history_type_name], 
	   rtrim(t2.[area]) as [history_value_old],
	   rtrim(t1.[area]) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Стандартний звук' as [history_type_name], 
	   case when t2.[Standart_audio]=N'true' then N'Так' when t2.[Standart_audio]=N'false' then N'Ні' end as [history_value_old],
	   case when t1.[Standart_audio]=N'true' then N'Так' when t1.[Standart_audio]=N'false' then N'Ні' end  as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Промовляти персональну адресу' as [history_type_name], 
	   case when t2.[say_liveAddress_id]=N'true' then N'Так' when t2.[say_liveAddress_id]=N'false' then N'Ні' end as [history_value_old],
	   case when t1.[say_liveAddress_id]=N'true' then N'Так' when t1.[say_liveAddress_id]=N'false' then N'Ні' end  as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Промовляти організацію, що проводить роботи' as [history_type_name], 
	   case when t2.[say_organization_id]=N'true' then N'Так' when t2.[say_organization_id]=N'false' then N'Ні' end as [history_value_old],
	   case when t1.[say_organization_id]=N'true' then N'Так' when t1.[say_organization_id]=N'false' then N'Ні' end  as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Промовляти телефон для довідок' as [history_type_name], 
	   case when t2.[say_phone_for_information]=N'true' then N'Так' when t2.[say_phone_for_information]=N'false' then N'Ні' end as [history_value_old],
	   case when t1.[say_phone_for_information]=N'true' then N'Так' when t1.[say_phone_for_information]=N'false' then N'Ні' end  as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Промовляти планову дату завершення' as [history_type_name], 
	   case when t2.[say_plan_end_date]=N'true' then N'Так' when t2.[say_plan_end_date]=N'false' then N'Ні' end as [history_value_old],
	   case when t1.[say_plan_end_date]=N'true' then N'Так' when t1.[say_plan_end_date]=N'false' then N'Ні' end  as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Телефон для довідок' as [history_type_name], 
	   rtrim(t2.phone_for_information) as [history_value_old],
	   rtrim(t1.phone_for_information) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Активувати аудіоінформатор' as [history_type_name], 
	   case when t2.[audio_on]=N'true' then N'Так' when t2.[audio_on]=N'false' then N'Ні' end as [history_value_old],
	   case when t1.[audio_on]=N'true' then N'Так' when t1.[audio_on]=N'false' then N'Ні' end  as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Файл аудіоінформатора' as [history_type_name], 
	   rtrim(t2.[File]) as [history_value_old],
	   rtrim(t2.[File]) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Назва файлу аудіоінформатора' as [history_type_name], 
	   rtrim(t2.[FileName]) as [history_value_old],
	   rtrim(t2.[FileName]) as [history_value_new]
from [dbo].[Event_History] as t1
left join [dbo].[Event_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id
----------------


select * 
from #temp_OUT
where isnull([history_value_old],N'') != isnull([history_value_new],N'')
and #filter_columns#
    --  #sort_columns#
    order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only