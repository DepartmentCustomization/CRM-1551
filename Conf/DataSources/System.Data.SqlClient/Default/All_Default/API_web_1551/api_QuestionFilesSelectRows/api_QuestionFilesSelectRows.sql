select [AssignmentConsDocFiles].Id as [AssignmentConsDocId], 
[AssignmentConsDocFiles].name as [AssignmentConsDocName], 
[AssignmentConsDocFiles].[File] as [AssignmentConsDocFile]
  from [CRM_1551_Analitics].[dbo].[AssignmentConsDocFiles]
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsDocuments] on [AssignmentConsDocFiles].assignment_cons_doc_id=[AssignmentConsDocuments].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [AssignmentConsDocuments].assignment_сons_id=[AssignmentConsiderations].Id
  left join [CRM_1551_Analitics].[dbo].[Assignments] on [AssignmentConsiderations].assignment_id=[Assignments].Id
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  where [Questions].appeal_id=@appeal_id