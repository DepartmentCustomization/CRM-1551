
SELECT [Questions].[Id]
      ,[Questions].[registration_number]
      ,[Questions].[registration_date]
      ,QuestionStates.name as q_state_name
      ,QuestionTypes.name as q_type_name
	  ,Organizations.short_name
      ,[Questions].[control_date]
      
  FROM [dbo].[Questions]
	left join QuestionStates on QuestionStates.Id = [Questions].question_state_id
	left join QuestionTypes on QuestionTypes.Id = [Questions].question_type_id
	left join Assignments on Assignments.Id = [Questions].last_assignment_for_execution_id
	left join Organizations on Organizations.Id = Assignments.executor_organization_id
  where [Questions].object_id = @Id
and  #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only