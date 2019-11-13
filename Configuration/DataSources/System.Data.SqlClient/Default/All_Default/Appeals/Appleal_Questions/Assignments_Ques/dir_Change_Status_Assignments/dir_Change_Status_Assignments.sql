select tas.Id
	  ,[new_assignment_state_id]
	  ,st_new.name as st_new
      ,[new_assignment_result_id]
	  ,res_new.name as res_new
      ,[new_assignment_resolution_id]
	  ,resol_new.name as resol_new
	from [TransitionAssignmentStates] tas
	left join AssignmentStates st_new on st_new.Id = tas.new_assignment_state_id
	left join AssignmentResults as res_new on res_new.Id = tas.new_assignment_result_id
	left join AssignmentResolutions resol_new on resol_new.Id = tas.new_assignment_resolution_id
		where old_assignment_state_id = @old_assignment_state_id
			and old_assignment_result_id = @old_assignment_result_id