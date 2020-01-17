
--declare @history_id int = 2
declare @history_id_old int = (select top 1 Id from [dbo].[Applicant_History] 
							   where [Log_Date] < (select Log_Date from [dbo].[Applicant_History] where Id = @history_id) 
							   and applicant_id = (select applicant_id from [dbo].[Applicant_History] where Id = @history_id)
							   order by [Log_Date] desc)

--select @history_id, @history_id_old


if object_id('tempdb..#temp_Applicant2') is not null drop table #temp_Applicant2
create table #temp_Applicant2(
[history_id] int,
[history_type_name]  nvarchar(100),
[history_value_old]  nvarchar(500),
[history_value_new]  nvarchar(500),
)

insert into #temp_Applicant2([history_id], [history_type_name], [history_value_old],[history_value_new])
select  t1.Id, N'Тип заявника' as [history_type_name], 
	   at2.[name] as [history_value_old],
	   at1.[name] as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old 
left join [dbo].[ApplicantTypes] as at1 on at1.Id = t1.applicant_type_id
left join [dbo].[ApplicantTypes] as at2 on at2.Id = t2.applicant_type_id
where t1.Id = @history_id

union all 
select t1.Id, N'Категорія заявника' as [history_type_name], 
	   ac2.[name] as [history_value_old],
	   ac1.[name] as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old
left join [dbo].CategoryType as ac1 on ac1.Id = t1.category_type_id
left join [dbo].CategoryType as ac2 on ac2.Id = t2.category_type_id
where t1.Id = @history_id

union all 
select t1.Id, N'Соціальний стан' as [history_type_name], 
	   sc2.[name] as [history_value_old],
	   sc1.[name] as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old 
left join SocialStates as sc1 on sc1.Id = t1.social_state_id
left join SocialStates as sc2 on sc2.Id = t2.social_state_id
where t1.Id = @history_id

union all 
select t1.Id, N'Пільги' as [history_type_name], 
	  ap2.[Name] as [history_value_old],
	  ap1.[Name] as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old
left join ApplicantPrivilege as ap1 on ap1.Id = t1.applicant_privilage_id
left join ApplicantPrivilege as ap2 on ap2.Id = t2.applicant_privilage_id
where t1.Id = @history_id

union all
select  t1.Id, N'Стать' as [history_type_name], 
	   case when t2.sex = 2 then 'Чоловік' when t2.sex = 1 then 'Жінка' end as [history_value_old],
	   case when t1.sex = 2 then 'Чоловік' when t1.sex = 1 then 'Жінка' end as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old 
where t1.Id = @history_id

union all
select  t1.Id, N'Дата народження' as [history_type_name], 
	   convert(varchar, t2.birth_date, 23)  as [history_value_old],
	   convert(varchar, t1.birth_date, 23) as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old 
where t1.Id = @history_id

union all 
select t1.Id, N'Нотатки' as [history_type_name], 
	   t2.comment as [history_value_old],
	   t1.comment as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'Адреса' as [history_type_name], 
	   t2.ApplicantAdress as [history_value_old],
	   t1.ApplicantAdress as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'E-mail' as [history_type_name], 
	   t2.mail as [history_value_old],
	   t1.mail as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id

union all 
select t1.Id, N'ПІБ' as [history_type_name], 
	   t2.full_name as [history_value_old],
	   t1.full_name as [history_value_new]
from [dbo].[Applicant_History] as t1
left join [dbo].[Applicant_History] as t2 on t2.Id = @history_id_old
where t1.Id = @history_id


select * 
from #temp_Applicant2
where isnull([history_value_old],N'') != isnull([history_value_new],N'')
  and #filter_columns#
    --  #sort_columns#
    order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only