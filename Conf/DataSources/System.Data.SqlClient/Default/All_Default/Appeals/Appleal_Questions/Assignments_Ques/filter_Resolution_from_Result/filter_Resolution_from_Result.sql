   SELECT distinct [AssignmentResolutions].[Id]
      ,[AssignmentResolutions].[name]
  FROM [dbo].[AssignmentResolutions]
  left join [TransitionAssignmentStates] as tas on tas.new_assignment_resolution_id = [AssignmentResolutions].Id
   WHERE tas.new_assignment_result_id = @new_result
   and
    #filter_columns#
    #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only
    
    /*dir_AssignmentResolutions_SelectRows*/