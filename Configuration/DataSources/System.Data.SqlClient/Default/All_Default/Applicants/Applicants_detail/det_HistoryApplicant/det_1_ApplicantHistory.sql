 if object_id('tempdb..#temp_Applicant') is not null drop table #temp_Applicant
create table #temp_Applicant(
[history_id_old] int,
[history_id_new] int
)
--declare @applicant_id int = 1494317;

insert into #temp_Applicant ([history_id_new])
select t1.Id
  from [dbo].[Applicant_History] as t1
  where t1.applicant_id = @applicant_id
  order by t1.Id

update #temp_Applicant set history_id_old = (select top 1 Id from [dbo].[Applicant_History] 
			where [Log_Date] < (select Log_Date from [dbo].[Applicant_History] where Id = #temp_Applicant.history_id_new) 
			and [applicant_id] = (select [applicant_id] from [dbo].[Applicant_History] where Id = #temp_Applicant.history_id_new)
			order by [Log_Date] desc)


SELECT [Applicant_History].[Id]
    --   ,[Applicant_History].[applicant_id]
      ,[Applicant_History].[Log_Date] as [operation_date]
      ,isnull([User].LastName,N'')+N' '+isnull([User].FirstName,N'') as [user_id]
      ,case when [Applicant_History].[Log_Activity] = N'UPDATE'then N'Оновлення даних'
	        when [Applicant_History].[Log_Activity] = N'INSERT' then N'Створення заявника'
		    end as [operation_name]
  FROM [dbo].[Applicant_History]
	left join Applicants on Applicants.Id = [Applicant_History].applicant_id
	left join [CRM_1551_System].[dbo].[User]  as [User] on [User].UserId = [Applicant_History].[Log_User]
WHERE [Applicant_History].[applicant_id] = @applicant_id
and  [Applicant_History].Id in (select t0.history_id_new
          from #temp_Applicant as t0
          left join [dbo].[Applicant_History] as t1 on t1.Id = t0.history_id_new
          left join [dbo].[Applicant_History] as t2 on t2.Id = t0.history_id_old
		  )
and #filter_columns#
    -- #sort_columns#
  order by [Applicant_History].[Log_Date] desc
offset @pageOffsetRows rows fetch next @pageLimitRows rows only