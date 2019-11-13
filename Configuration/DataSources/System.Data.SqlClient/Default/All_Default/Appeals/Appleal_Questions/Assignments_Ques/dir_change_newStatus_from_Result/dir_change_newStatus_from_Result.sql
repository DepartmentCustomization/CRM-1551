SELECT distinct AssignmentStates.[Id]
      ,AssignmentStates.[name]
-- 	  ,AssignmentResults.Id as res_id
-- 	  ,AssignmentResults.name as res_name
  FROM [dbo].AssignmentStates
	left join [TransitionAssignmentStates] as tas on tas.new_assignment_state_id = AssignmentStates.Id
-- 	left join AssignmentResults on AssignmentResults.Id = tas.new_assignment_result_id
   WHERE  tas.new_assignment_result_id = @new_result and (tas.new_assignment_resolution_id = @new_resolution or tas.new_assignment_resolution_id is null)