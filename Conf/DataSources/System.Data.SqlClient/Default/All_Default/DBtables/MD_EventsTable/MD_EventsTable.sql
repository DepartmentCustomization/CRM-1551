  select [Questions].Id, [Questions].question_content, [Organizations].name, [Questions].event_id
  from [CRM_1551_Analitics].[dbo].[Questions]
  left join [CRM_1551_Analitics].[dbo].[Assignments] on [Questions].last_assignment_for_execution_id=[Assignments].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
  where [Questions].event_id=@eventId