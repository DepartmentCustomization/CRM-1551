--declare @assignment_id int=2810705;

  select [Assignment_History].Id, [AssignmentStates].name AssignmentStates, [Assignment_History].transfer_date,
  [Organizations].short_name, case when [Assignment_History].main_executor=N'true' then N'Так' when [Assignment_History].main_executor=N'false' then N'Ні' end [main],
  [AssignmentResults].name AssignmentResult, [AssignmentResolutions].name [AssignmentResolution], [Assignment_History].short_answer
  from [CRM_1551_Analitics].[dbo].[Assignment_History]
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignment_History].assignment_state_id=[AssignmentStates].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignment_History].executor_organization_id=[Organizations].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignment_History].AssignmentResultsId=[AssignmentResults].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignment_History].AssignmentResolutionsId=[AssignmentResolutions].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignment_History].assignment_id=[AssignmentConsiderations].assignment_id
  where [Assignment_History].assignment_id=@assignment_id
  and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
   