SELECT 
	   [Assignments].[Id]
      ,[Assignments].[registration_date]
	  ,at.name as ass_type_name
      ,Organizations.short_name as performer
      ,[Assignments].[main_executor]
      ,ast.name as ass_state_name
     ,Assignments.execution_date
     ,Assignments.question_id
  FROM [dbo].[Assignments]
	left join AssignmentTypes at on at.Id = Assignments.assignment_type_id
	left join AssignmentStates ast on ast.Id = Assignments.assignment_state_id
	left join Organizations on Organizations.Id =Assignments.executor_organization_id
	where Assignments.question_id = @question
	    and [Assignments].[Id] <> @Id
	and #filter_columns#
    order by main_executor desc, ass_state_name
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only