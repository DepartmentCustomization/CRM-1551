SELECT  [AssignmentResults].[Id]
      ,[AssignmentResults].[name]
  FROM [dbo].[AssignmentResults]
  left join [TransitionAssignmentStates] as tas on tas.new_assignment_result_id = AssignmentResults.Id
   WHERE tas.old_assignment_state_id = @old_assignment_state_id
  and
    #filter_columns#
    #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only
    
    /*dir_AssignmentResults_SelectRows*/