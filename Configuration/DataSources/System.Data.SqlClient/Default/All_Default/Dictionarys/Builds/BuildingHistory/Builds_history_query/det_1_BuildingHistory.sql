if object_id('tempdb..#temp_Building') is not null drop table #temp_Building
create table #temp_Building(
[history_id_old] int,
[history_id_new] int
)
--declare @building_id int = 69578;

insert into #temp_Building ([history_id_new])
select t1.Id
  from [dbo].[Building_History] as t1
  where t1.building_id = @building_id
  order by t1.Id

update #temp_Building set history_id_old = (select top 1 Id from [dbo].[Building_History] 
			where [Log_Date] < (select Log_Date from [dbo].[Building_History] where Id = #temp_Building.history_id_new) 
			and building_id = (select building_id from [dbo].[Building_History] where Id = #temp_Building.history_id_new)
			order by [Log_Date] desc)


SELECT [Building_History].[Id]
    --   ,[Applicant_History].[applicant_id]
      ,[Building_History].[Log_Date] as [operation_date]
      ,isnull([User].LastName,N'')+N' '+isnull([User].FirstName,N'') as [user_id]
      ,case when [Building_History].[Log_Activity] = N'UPDATE'then N'Оновлення даних'
	        when [Building_History].[Log_Activity] = N'INSERT' then N'Створення будинку'
		    end as [operation_name]
  FROM [dbo].[Building_History]
	left join Buildings on Buildings.Id = [Building_History].building_id
	left join [CRM_1551_System].[dbo].[User]  as [User] on [User].UserId = [Building_History].[Log_User]
WHERE [Building_History].building_id = @building_id
and  [Building_History].Id in (select t0.history_id_new
          from #temp_Building as t0
          left join [dbo].[Building_History] as t1 on t1.Id = t0.history_id_new
          left join [dbo].[Building_History] as t2 on t2.Id = t0.history_id_old
		  )
   and #filter_columns#
    -- #sort_columns#
  order by [Building_History].[Log_Date] desc
-- offset @pageOffsetRows rows fetch next @pageLimitRows rows only