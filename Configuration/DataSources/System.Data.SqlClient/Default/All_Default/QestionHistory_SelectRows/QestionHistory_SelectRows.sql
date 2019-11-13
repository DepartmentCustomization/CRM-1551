if object_id('tempdb..#temp_OUT') is not null drop table #temp_OUT
create table #temp_OUT(
[history_id_old] int,
[history_id_new] int
)

insert into #temp_OUT ([history_id_new])
select t1.Id
  from [dbo].[Question_History] as t1
  where t1.question_id = @question_id
  order by t1.Id

update #temp_OUT set history_id_old = (select top 1 Id from [dbo].[Question_History] 
							   where [Log_Date] < (select Log_Date from [dbo].[Question_History] where Id = #temp_OUT.history_id_new) 
							   and [question_id] = (select [question_id] from [dbo].[Question_History] where Id = #temp_OUT.history_id_new)
							   order by [Log_Date] desc)



SELECT 
      [Question_History].[Id],
	  [Question_History].[Log_Date]
      ,isnull(LastName, N'')+N' '+isnull([FirstName], N'')+N' '+isnull([Patronymic], N'') as [Log_User_FIO]
	  ,case when [Question_History].[Log_Activity] = N'INSERT' then N'Створення'
			when [Question_History].[Log_Activity] = N'UPDATE' then N'Редагування'
			else [Question_History].[Log_Activity] end as [Log_Activity]
  FROM [dbo].[Question_History]
  left join [CRM_1551_System].[dbo].[User] on [User].UserId = [Question_History].[Log_User]
  where [Question_History].question_id = @question_id
  and [Question_History].Id in (select t0.history_id_new
              from #temp_OUT as t0
              left join [dbo].[Question_History] as t1 on t1.Id = t0.history_id_new
              left join [dbo].[Question_History] as t2 on t2.Id = t0.history_id_old
            left join [dbo].[Assignments] as [Assignments1] on [Assignments1].question_id = t1.question_id and [Assignments1].main_executor = 1
            left join [dbo].[Organizations] as [Organizations1] on [Organizations1].Id = [Assignments1].[executor_organization_id]
            left join [dbo].[Assignments] as [Assignments2] on [Assignments2].question_id = t2.question_id and [Assignments2].main_executor = 1
            left join [dbo].[Organizations] as [Organizations2] on [Organizations2].Id = [Assignments2].[executor_organization_id]
            where t1.question_type_id != t2.question_type_id
            or t1.[object_id] != t2.[object_id]
            or t1.organization_id != t2.organization_id
            or t1.question_content != t2.question_content
            or t1.control_date != t2.control_date
            or t1.question_state_id != t2.question_state_id
			or t1.operator_notes != isnull(t2.operator_notes, '')
            or IIF(len([Organizations2].[head_name]) > 5,  isnull([Organizations2].[head_name],N''),  isnull([Organizations2].[short_name],N'')) ! = IIF(len([Organizations1].[head_name]) > 5,  isnull([Organizations1].[head_name],N''),  isnull([Organizations1].[short_name],N'')))
  
   and #filter_columns#
 -- #sort_columns#
 order by [Question_History].[Log_Date] desc
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only