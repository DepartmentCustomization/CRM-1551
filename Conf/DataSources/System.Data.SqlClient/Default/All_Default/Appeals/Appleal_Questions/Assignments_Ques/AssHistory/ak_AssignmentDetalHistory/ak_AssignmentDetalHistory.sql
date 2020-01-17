 -- declare @Id int = 5041083; 
  declare @assignment_id int=
  (select assignment_id from [CRM_1551_Analitics].[dbo].[Assignment_History] where Id=@Id);



with
main as
(SELECT top 2 ROW_NUMBER() over(order by [Assignment_History].[Id] desc) n,
[Assignment_History].[Id]
      ,[Assignment_History].[assignment_id]
      ,isnull(convert(nvarchar(500), [AssignmentTypes].name), N'') AssignmentTypes
	  ,isnull(convert(nvarchar(500), FORMAT([Assignment_History].[transfer_date], 'yyyy-MM-dd hh:mm')), N'') [transfer_date]
      --,convert(nvarchar(300),[Assignment_History].[transfer_date]) [transfer_date]
      ,isnull(convert(nvarchar(500), [AssignmentStates].name), N'') [AssignmentStates]
	  ,isnull(convert(nvarchar(500), FORMAT([Assignment_History].[close_date], 'yyyy-MM-dd hh:mm')), N'') [close_date]
      --,[Assignment_History].[close_date]
      ,isnull(convert(nvarchar(500), [Organizations2].short_name), N'') Organization
      ,isnull(convert(nvarchar(500), [Organizations].short_name), N'') [executor_organization]
      ,isnull(convert(nvarchar(500), [Assignment_History].[main_executor]), N'') [main_executor]
      --,[Assignment_History].[execution_date]
	  ,isnull(convert(nvarchar(500), format([Assignment_History].[execution_date], 'yyyy-MM-dd hh:mm')), N'') [execution_date]
      ,isnull(convert(nvarchar(500), [AssignmentResults].name), N'') [AssignmentResults]
      ,isnull(convert(nvarchar(500), [AssignmentResolutions].name), N'') [AssignmentResolution]
      ,[Assignment_History].[Log_Activity]
      ,isnull(convert(nvarchar(500), [Assignment_History].[short_answer]), N'') [short_answer]
  FROM [CRM_1551_Analitics].[dbo].[Assignment_History]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignment_History].assignment_state_id=[AssignmentStates].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignment_History].executor_organization_id=[Organizations].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignment_History].AssignmentResultsId=[AssignmentResults].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignment_History].AssignmentResolutionsId=[AssignmentResolutions].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignment_History].assignment_id=[AssignmentConsiderations].assignment_id
  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignment_History].assignment_type_id=[AssignmentTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] [Organizations2] on [Assignment_History].organization_id=[Organizations2].Id
  where [Assignment_History].assignment_id=@assignment_id and [Assignment_History].Id<=@Id
  ),

  table_history as
  (select assignment_id, [n], [sravnenie], [znachenie]
  from main
  unpivot(
  [sravnenie] for [znachenie]  in ([AssignmentTypes], [transfer_date], [AssignmentStates], 
  [close_date], [Organization], [executor_organization], [main_executor], 
  [execution_date], [AssignmentResults], [AssignmentResolution], [short_answer]
  )
  ) as unp)

  select t1.assignment_id Id, 
  case
  when t1.znachenie=N'AssignmentTypes' then N'Тип доручення'
  when t1.znachenie=N'transfer_date' then N'Дата передачі виконавцю'
  when t1.znachenie=N'AssignmentStates' then N'Стан доручення'
  when t1.znachenie=N'close_date' then N'Дата закриття доручення'
  when t1.znachenie=N'Organization' then N'Організація, до якої передано доручення за належністю'
  when t1.znachenie=N'executor_organization' then N'Відповідальна організація'
  when t1.znachenie=N'main_executor' then N'Головне'
  when t1.znachenie=N'execution_date' then N'Строк виконання'
  when t1.znachenie=N'AssignmentResults' then N'Результат доручення'
  when t1.znachenie=N'AssignmentResolution' then N'Резолюція доручення'
  when t1.znachenie=N'short_answer' then N'Коротка відповідь'
  end [znachenie],

  t2.sravnenie [bylo], t1.sravnenie [stalo]
  from (select * from table_history where n=1) t1
  inner join (select * from table_history where n=2) t2 on t1.znachenie=t2.znachenie and t1.sravnenie<>t2.sravnenie