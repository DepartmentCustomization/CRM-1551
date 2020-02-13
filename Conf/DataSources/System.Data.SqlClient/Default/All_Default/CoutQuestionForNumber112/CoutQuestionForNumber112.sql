
--DECLARE @Phone NVARCHAR='0444111010';

DECLARE @ApplicantsId INT =(SELECT TOP 1 applicant_id FROM [dbo].[ApplicantPhones] WHERE applicant_id IS NOT NULL AND
 phone_number=@Phone);



SELECT 1 Id, @ApplicantsId ApplicantId, COUNT(t.Id) count_questions
FROM   
(  SELECT [Questions].Id, 
		 Questions.registration_number,
         [Questions].[registration_date], 
         [QuestionStates].name  QuestionStates, 
         [QuestionTypes].name QuestionType,
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
  ) t