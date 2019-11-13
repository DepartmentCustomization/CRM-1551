/*
SELECT [AssignmentHistory].[Id]
    --   ,[AssignmentHistory].[assignment_id]
      ,[AssignmentHistory].[operation_date]
      ,[AssignmentHistory].[user_id]
      ,[AssignmentHistory].[operation_name]
  FROM [dbo].[AssignmentHistory]
	left join Assignments on Assignments.Id = [AssignmentHistory].assignment_id
WHERE [AssignmentHistory].[assignment_id] = @Id
and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 */
 if object_id('tempdb..#temp_OUT') is not null drop table #temp_OUT
create table #temp_OUT(
[history_id_old] int,
[history_id_new] int
)

insert into #temp_OUT ([history_id_new])
select t1.Id
  from [dbo].[Assignment_History] as t1
  where t1.assignment_id = @Id
  order by t1.Id

update #temp_OUT set history_id_old = (select top 1 Id from [dbo].[Assignment_History] 
							   where [Log_Date] < (select Log_Date from [dbo].[Assignment_History] where Id = #temp_OUT.history_id_new) 
							   and [assignment_id] = (select [assignment_id] from [dbo].[Assignment_History] where Id = #temp_OUT.history_id_new)
							   order by [Log_Date] desc)

 
 SELECT [Assignment_History].[Id]
    --   ,[AssignmentHistory].[assignment_id]
      ,[Assignment_History].[Log_Date] as [operation_date]
      ,isnull([User].LastName,N'')+N' '+isnull([User].FirstName,N'') as [user_id]
      ,case when [Assignment_History].[Log_Activity] = N'UPDATE'then N'Зміни в дорученні'
	        when [Assignment_History].[Log_Activity] = N'INSERT' then N'Створення доручення'
		else N'Зміни в дорученні' end as [operation_name]
  FROM [dbo].[Assignment_History]
	left join Assignments on Assignments.Id = [Assignment_History].assignment_id
	left join [CRM_1551_System].[dbo].[User]  as [User] on [User].UserId = [Assignment_History].[Log_User]
WHERE [Assignment_History].[assignment_id] = @Id
and  [Assignment_History].Id in (select t0.history_id_new
          from #temp_OUT as t0
          left join [dbo].[Assignment_History] as t1 on t1.Id = t0.history_id_new
          left join [dbo].[Assignment_History] as t2 on t2.Id = t0.history_id_old
        left join [dbo].[Organizations] as [Organizations1] on [Organizations1].Id = t1.[executor_organization_id]
        left join [dbo].[Organizations] as [Organizations2] on [Organizations2].Id = t2.[executor_organization_id]
        where t1.assignment_state_id != t2.assignment_state_id
        or t1.transfer_date != t2.transfer_date
        or IIF(len([Organizations2].[head_name]) > 5,  isnull([Organizations2].[head_name],N''),  isnull([Organizations2].[short_name],N'')) ! = IIF(len([Organizations1].[head_name]) > 5,  isnull([Organizations1].[head_name],N''),  isnull([Organizations1].[short_name],N''))
        or t1.main_executor != t2.main_executor
        or t1.AssignmentResultsId != t2.AssignmentResultsId
        or t1.short_answer != t2.short_answer
        or t1.AssignmentResolutionsId != t2.AssignmentResolutionsId)

and #filter_columns#
    -- #sort_columns#
  order by [Assignment_History].[Log_Date] desc
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only