-- declare @Id int = 4

select	[Appeals].Id as [AppealId],  
		[Appeals].registration_date, 
		[Appeals].registration_number, 
		[AssignmentStates].name AssignmentStates,
		[AssignmentResults].name Results,
		[Objects].name adress,
		[QuestionTypes].name QuestionTypes,
		[Questions].question_content,
		[Applicants].full_name,
		[Questions].control_date,
		case when [AssignmentStates].code=N'OnCheck' and [AssignmentResults].code=N'Done' then 1 else 0 end PossibleEvaluation
  from [CRM_1551_Analitics].[dbo].[Appeals]
  inner join [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] on [Appeals].Id=[AppealsFromSite].Appeal_Id
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Appeals].Id=[Questions].appeal_id
  left join [CRM_1551_Analitics].[dbo].[Assignments] on [Questions].last_assignment_for_execution_id =[Assignments].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].AssignmentResultsId=[AssignmentResults].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].object_id=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
 where [AppealsFromSite].ApplicantFromSiteId=@ApplicantFromSiteId 
 /*START CRM1551-397*/
	and [Questions].[question_state_id] = 3 /*На перевірці*/ 
	and [Assignments].AssignmentResultsId = 4 /*Виконано*/
 /*END CRM1551-397*/
 