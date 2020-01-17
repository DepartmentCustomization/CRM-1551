

  --declare @Id int=11;

  select [Appeals].Id as [AppealId], [Appeals].registration_date, [Appeals].registration_number, [AssignmentStates].name AssignmentStates,
  [AssignmentResults].name Results,
  [Objects].name adress
  ,[QuestionTypes].name QuestionTypes
  ,[Questions].question_content
  ,[Applicants].full_name
  ,[Questions].control_date
  ,[AssignmentConsDocuments].content
  ,count([AssignmentConsDocFiles].Id) CountFiles


  from [CRM_1551_Analitics].[dbo].[Appeals]
  inner join [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] on [Appeals].Id=[AppealsFromSite].Appeal_Id
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Appeals].Id=[Questions].appeal_id
  left join [CRM_1551_Analitics].[dbo].[Assignments] on [Questions].Id=[Assignments].question_id
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].AssignmentResultsId=[AssignmentResults].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsDocuments] on [AssignmentConsDocuments].assignment_сons_id=[AssignmentConsiderations].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentConsDocFiles] on [AssignmentConsDocuments].Id=[AssignmentConsDocFiles].assignment_cons_doc_id
  where [AppealsFromSite].ApplicantFromSiteId=@ApplicantFromSiteId and [AssignmentStates].code=N'Closed'
  group by [Appeals].Id, [Appeals].registration_date, [Appeals].registration_number, [AssignmentStates].name,
  [AssignmentResults].name,
  [Objects].name 
  ,[QuestionTypes].name 
  ,[Questions].question_content
  ,[Applicants].full_name
  ,[Questions].control_date
  ,[AssignmentConsDocuments].content