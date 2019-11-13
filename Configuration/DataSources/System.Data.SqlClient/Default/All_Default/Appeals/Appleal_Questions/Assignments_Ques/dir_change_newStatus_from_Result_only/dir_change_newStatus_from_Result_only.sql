SELECT distinct AssignmentStates.[Id]
      ,AssignmentStates.[name]
  FROM [dbo].AssignmentStates
	left join [TransitionAssignmentStates] as tas on tas.new_assignment_state_id = AssignmentStates.Id
   WHERE  tas.new_assignment_result_id = @new_result