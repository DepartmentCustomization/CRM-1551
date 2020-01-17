SELECT 
	   [Assignments].[Id]
      ,[Assignments].[registration_date]
	  ,at.name as ass_type_name
    --   ,Organizations.short_name as performer
      ,IIF (len([head_name]) > 5,  concat([head_name] , ' ( ' , [short_name] , ')'),  [short_name]) as performer
      ,[Assignments].[main_executor]
      ,ast.name as ass_state_name
     ,Assignments.execution_date
    -- ,Questions.control_date as execution_date
    ,'Перегляд' as ed
  FROM [dbo].[Assignments]
	left join AssignmentTypes at on at.Id = Assignments.assignment_type_id
	left join AssignmentStates ast on ast.Id = Assignments.assignment_state_id
	left join Organizations on Organizations.Id =Assignments.executor_organization_id
	left join Questions on Questions.Id = Assignments.question_id
	where Assignments.question_id = @question
	    
     order by case when ast.name <> 'Закрито' then 1
		           when ast.name = 'Закрито' then  2 
		           end,  
		           main_executor desc   
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only