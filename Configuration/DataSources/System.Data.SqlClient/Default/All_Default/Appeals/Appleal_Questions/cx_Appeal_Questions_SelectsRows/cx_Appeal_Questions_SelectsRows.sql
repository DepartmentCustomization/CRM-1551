SELECT [Questions].[Id]
      ,[Questions].[registration_number]
      ,[Questions].[registration_date]
      ,QuestionStates.name as question_state_name
      ,[Questions].[control_date]
      ,QuestionTypes.name as question_type_name
      ,[Questions].[question_content]
  FROM [dbo].[Questions]
	left join Appeals on Appeals.Id = Questions.appeal_id
	left join QuestionStates on QuestionStates.Id = Questions.question_state_id
	left join QuestionTypes on QuestionTypes.Id = Questions.question_type_id
	WHERE Questions.appeal_id = @Id
	and #filter_columns#
    --  #sort_columns#
    order by registration_date desc
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only