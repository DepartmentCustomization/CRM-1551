
SELECT [Questions].[Id]
      ,[Questions].[appeal_id] 
      ,[Questions].[registration_number] as [Номер питання]
      ,[QuestionTypes].[name] as [Тип питання]
      ,[Organizations_Execut].name as [Виконавець]
      ,[Questions].[control_date] as [Дата контролю]
      ,[QuestionTypes].[name] as [QuestionTypesName]
	  ,[Objects].Id as [ObjectId]
	  ,isnull([StreetTypes].shortname,N'')+N' '+isnull([Streets].name,N'')+N' '+isnull([Buildings].name,N'') as [ObjectName]  
	  ,[Questions].organization_id
	  ,[Organizations].name as organization_name
	  ,[Questions].question_content
	  ,[Questions].question_type_id
	  ,[Questions].[last_assignment_for_execution_id]
	  ,[Questions].[last_assignment_for_execution_id] as [last_assignment_for_execution_name]
	  ,[Questions].question_state_id
	  ,[QuestionStates].[name] as question_state_name
	  ,[AssignmentResults].name as result
	  ,NULL as last_assignment_for_execution_comment
	  ,[AssignmentResolutions].[name] as [AssignmentResolutionsName]
	  ,[Applicants].[full_name] as [ApplicantPIB]
	  ,[Applicants].[ApplicantAdress]
	  
  FROM [dbo].[Questions]
  left join [dbo].[QuestionTypes] on [QuestionTypes].Id = [Questions].question_type_id
  left join [dbo].[Objects] on [Objects].Id = [Questions].[object_id]
  left join [dbo].[Buildings] on [Buildings].Id = [Objects].[builbing_id]
   left join [dbo].[Streets] on [Streets].Id = [Buildings].street_id
  left join [dbo].[StreetTypes] on [StreetTypes].Id = [Streets].street_type_id
  left join [dbo].[Districts] on [Districts].Id = [Streets].district_id
  left join [dbo].[QuestionStates] on [QuestionStates].Id = [Questions].question_state_id
  left join [dbo].[Organizations] on [Organizations].Id = [Questions].organization_id
  left join [dbo].[Appeals] on [Appeals].Id = [Questions].[appeal_id] 
  left join [dbo].[Applicants] on [Applicants].Id = [Appeals].[applicant_id] 

  --   left join Assignments on Assignments.Id = Questions.last_assignment_for_execution_id
  left join Assignments on [Assignments].[question_id] = [Questions].[Id]
				and [Assignments].[main_executor] = 1
left join AssignmentResolutions on AssignmentResolutions.Id = Assignments.AssignmentResolutionsId
  left join [dbo].[AssignmentResults] on [AssignmentResults].Id = [Assignments].AssignmentResultsId
  left join [dbo].[Organizations] as [Organizations_Execut] on [Organizations_Execut].Id = [Assignments].executor_organization_id
 
  where [Questions].[Id] = @QuestionId
 