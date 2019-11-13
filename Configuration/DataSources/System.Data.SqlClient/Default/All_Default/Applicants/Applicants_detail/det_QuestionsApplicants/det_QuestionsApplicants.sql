  select [Questions].Id, 
		 Questions.registration_number,
         [Questions].[registration_date], 
         [QuestionStates].name as  QuestionStates, 
         [QuestionTypes].name as QuestionType,
         [Questions].control_date,
		 Organizations.short_name
  from [dbo].[Questions]
  left join [dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
  left join [dbo].[Applicants] on [Applicants].Id=[Appeals].applicant_id
  left join [dbo].[QuestionStates] on [Questions].question_state_id=[QuestionStates].Id
  left join [dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join Assignments on Assignments.Id = Questions.last_assignment_for_execution_id
  left join Organizations on Organizations.Id = Assignments.executor_organization_id
  where [Applicants].Id = @ApplicantsId 
  and 
   #filter_columns#
  order by [Questions].[registration_date]--#sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only