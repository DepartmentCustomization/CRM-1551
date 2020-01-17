if object_id('tempdb..#temp_Obj') is not null drop table #temp_Obj
create table #temp_Obj(
[history_id_old] int,
[history_id_new] int
)
--declare @object_id int = 125345;

insert into #temp_Obj ([history_id_new])
select t1.Id
  from [dbo].[Object_History] as t1
  where t1.[object_id] = @object_id
  order by t1.Id

update #temp_Obj set history_id_old = (select top 1 Id from [dbo].[Object_History] 
			where [Log_Date] < (select Log_Date from [dbo].[Object_History] where Id = #temp_Obj.history_id_new) 
			and [object_id] = (select [object_id] from [dbo].[Object_History] where Id = #temp_Obj.history_id_new)
			order by [Log_Date] desc)


SELECT [Object_History].[Id]
    --   ,[Applicant_History].[applicant_id]
      ,[Object_History].[Log_Date] as [operation_date]
      ,isnull([User].LastName,N'')+N' '+isnull([User].FirstName,N'') as [user_id]
      ,case when [Object_History].[Log_Activity] = N'UPDATE'then N'Оновлення даних'
	        when [Object_History].[Log_Activity] = N'INSERT' then N'Створення будинку'
		    end as [operation_name]
  FROM [dbo].[Object_History]
	left join [Objects] on [Objects].Id = [Object_History].[object_id]
	left join [#system_database_name#].[dbo].[User]  as [User] on [User].UserId = [Object_History].[Log_User]
WHERE [Object_History].[object_id] = @object_id
and  [Object_History].Id in (select t0.history_id_new
          from #temp_Obj as t0
          left join [dbo].[Object_History] as t1 on t1.Id = t0.history_id_new
          left join [dbo].[Object_History] as t2 on t2.Id = t0.history_id_old
		  )
   and #filter_columns#
    -- #sort_columns#
  order by [Object_History].[Log_Date] desc
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only