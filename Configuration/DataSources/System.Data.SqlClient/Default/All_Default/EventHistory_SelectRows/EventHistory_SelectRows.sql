--declare @event_id int = 65


if object_id('tempdb..#temp_OUT') is not null drop table #temp_OUT
create table #temp_OUT(
[history_id_old] int,
[history_id_new] int
)

insert into #temp_OUT ([history_id_new])
select t1.Id
  from [dbo].[Event_History] as t1
  where t1.event_id = @event_id
  order by t1.Id

update #temp_OUT set history_id_old = (select top 1 Id from [dbo].[Event_History] 
							   where [Log_Date] < (select Log_Date from [dbo].[Event_History] where Id = #temp_OUT.history_id_new) 
							   and [event_id] = (select [event_id] from [dbo].[Event_History] where Id = #temp_OUT.history_id_new)
							   order by [Log_Date] desc)



SELECT [Event_History].[Id]
	  ,[Event_History].[Log_Date]
      ,isnull(LastName, N'')+N' '+isnull([FirstName], N'')+N' '+isnull([Patronymic], N'') as [Log_User_FIO]
	  ,case when [Event_History].[Log_Activity] = N'INSERT' then N'Створення'
			when [Event_History].[Log_Activity] = N'UPDATE' then N'Редагування'
			else [Event_History].[Log_Activity] end as [Log_Activity]
  FROM [dbo].[Event_History]
  left join [CRM_1551_System].[dbo].[User] on [User].UserId = [Event_History].[Log_User]
  where [Event_History].event_id = @event_id
  and [Event_History].Id in (select t0.history_id_new
              from #temp_OUT as t0
              left join [dbo].[Event_History] as t1 on t1.Id = t0.history_id_new
              left join [dbo].[Event_History] as t2 on t2.Id = t0.history_id_old
            where isnull(t1.[registration_date],getdate()) != isnull(t2.[registration_date],getdate())
            -- or isnull(t1.[name],N'') != isnull(t2.[name],N'')
			or isnull(t1.[event_type_id],1) != isnull(t2.[event_type_id],1)
			or isnull(t1.[event_class_id],1) != isnull(t2.[event_class_id],1)
			or isnull(t1.[gorodok_id],1) != isnull(t2.[gorodok_id],1)
			or isnull(t1.[start_date],getdate()) != isnull(t2.[start_date],getdate())
			or isnull(t1.[plan_end_date],getdate()) != isnull(t2.[plan_end_date],getdate())
			or isnull(t1.[real_end_date],getdate()) != isnull(t2.[real_end_date],getdate())
			or isnull(t1.[active],1) != isnull(t2.[active],1)
			or isnull(t1.[comment],N'') != isnull(t2.[comment],N'')
			or isnull(t1.[area],1) != isnull(t2.[area],1)
			or isnull(t1.[audio_start_date],getdate()) != isnull(t2.[audio_start_date],getdate())
			or isnull(t1.[audio_end_date],getdate()) != isnull(t2.[audio_end_date],getdate())
			or isnull(t1.[Standart_audio],1) != isnull(t2.[Standart_audio],1)
			or isnull(t1.[say_liveAddress_id],1) != isnull(t2.[say_liveAddress_id],1)
			or isnull(t1.[say_organization_id],1) != isnull(t2.[say_organization_id],1)
			or isnull(t1.[say_phone_for_information],1) != isnull(t2.[say_phone_for_information],1)
			or isnull(t1.[phone_for_information],N'') != isnull(t2.[phone_for_information],N'')
			or isnull(t1.[say_plan_end_date],1) != isnull(t2.[say_plan_end_date],1)
			or isnull(t1.[audio_on],1) != isnull(t2.[audio_on],1)
			or isnull(t1.[File],1) != isnull(t2.[File],1)
			or isnull(t1.[FileName],N'') != isnull(t2.[FileName],N'')
			)
  
   and #filter_columns#
 -- #sort_columns#
 order by [Event_History].[Log_Date] desc
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only