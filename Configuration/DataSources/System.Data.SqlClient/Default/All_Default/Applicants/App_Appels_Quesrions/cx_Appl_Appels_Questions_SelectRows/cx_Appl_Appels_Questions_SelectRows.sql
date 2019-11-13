SELECT [Appeals].[Id]

	  ,Questions.registration_number
	  ,QuestionStates.name as question_state_name
	  ,QuestionTypes.name as question_type_name
	  ,Questions.question_content
	  ,Questions.registration_date
	  ,Questions.control_date

  FROM [dbo].[Appeals]
	left join Questions on Questions.appeal_id = Appeals.Id
	left join Applicants on Applicants.Id = Appeals.applicant_id
	left join QuestionStates on QuestionStates.Id = Questions.question_state_id
	left join QuestionTypes on QuestionTypes.Id = Questions.question_type_id
WHERE Appeals.applicant_id = @Id
and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only