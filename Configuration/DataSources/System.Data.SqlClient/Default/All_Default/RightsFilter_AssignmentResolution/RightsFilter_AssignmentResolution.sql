-- declare @programuser_id nvarchar(128) = N'dc61a839-2cbc-4822-bfb5-5ca157487ced'
-- declare @AssignmentId int = 2074071
-- declare @new_assignment_result_id int = 7


declare @form nvarchar(128) = N'Assignment'

declare @old_assignment_state_id int = (select Assignments.assignment_state_id from [dbo].[Assignments] where Id = @AssignmentId)
declare @old_assignment_result_id int = (select Assignments.AssignmentResultsId from [dbo].[Assignments] where Id = @AssignmentId)
declare @old_assignment_resolution_id int = (select Assignments.AssignmentResolutionsId from [dbo].[Assignments] where Id = @AssignmentId)

/*
 SELECT  distinct [TransitionAssignmentStates].[new_assignment_resolution_id] as [Id],
                     [AssignmentResolutions].[name] as [Name],
                     [TransitionAssignmentStates].[new_assignment_result_id],
					 isnull([TransitionAssignmentStates].old_assignment_state_id,0) as old_assignment_state_id,
					 isnull([TransitionAssignmentStates].old_assignment_result_id,0) as old_assignment_result_id,
					 isnull([TransitionAssignmentStates].old_assignment_resolution_id,0) as old_assignment_resolution_id,
					 @old_assignment_state_id old1, 
					 @old_assignment_result_id old2,
					 @old_assignment_resolution_id old3
    FROM [dbo].[TransitionAssignmentStates]
    inner join [dbo].[AssignmentResolutions] on [AssignmentResolutions].Id = [TransitionAssignmentStates].new_assignment_resolution_id
    where [TransitionAssignmentStates].id in (
			select referencevalue_id  
			FROM [dbo].[PosibilitiesForRoles]
			where role_id in (SELECT 
			      [role_id]
			  FROM [dbo].[Positions]
			  where programuser_id = @programuser_id
			  )
			and RulesforRightsId in (SELECT [id]
			  FROM [dbo].[RulesforRights]
			  where formcode = @form)
			and [PosibilitiesForRoles].colunmcode = N'transitionassignmentstate'
			)
		and isnull([TransitionAssignmentStates].old_assignment_state_id,0) = isnull(@old_assignment_state_id,0) 
		and isnull([TransitionAssignmentStates].old_assignment_result_id,0) = isnull(@old_assignment_result_id,0)
		and isnull([TransitionAssignmentStates].old_assignment_resolution_id,0) = isnull(@old_assignment_resolution_id,0)
        and isnull([TransitionAssignmentStates].new_assignment_result_id,0) = isnull(@new_assignment_result_id,0)
*/

;with AssResult as(
    SELECT  distinct [TransitionAssignmentStates].[new_assignment_resolution_id] as [Id],
                     [AssignmentResolutions].[name] as [Name],
                     [TransitionAssignmentStates].[new_assignment_result_id] 
    FROM [dbo].[TransitionAssignmentStates]
    left join [dbo].[AssignmentResolutions] on [AssignmentResolutions].Id = [TransitionAssignmentStates].new_assignment_resolution_id
    where [TransitionAssignmentStates].id in (
			select referencevalue_id  
			FROM [dbo].[PosibilitiesForRoles]
			where role_id in (SELECT 
			      [role_id]
			  FROM [dbo].[Positions]
			  where programuser_id = @programuser_id
			  and role_id is not null)
			and RulesforRightsId in (SELECT [id]
			  FROM [dbo].[RulesforRights]
			  where formcode = @form)
			and [PosibilitiesForRoles].colunmcode = N'transitionassignmentstate'
			)
		and isnull([TransitionAssignmentStates].old_assignment_state_id,0) = isnull(@old_assignment_state_id,0) 
		and isnull([TransitionAssignmentStates].old_assignment_result_id,0) = isnull(@old_assignment_result_id,0)
		and isnull([TransitionAssignmentStates].old_assignment_resolution_id,0) = isnull(@old_assignment_resolution_id,0)
        and isnull([TransitionAssignmentStates].new_assignment_result_id,0) = isnull(@new_assignment_result_id,0)
   
)

 select Id, 
 Name 
 from AssResult
  where #filter_columns#
order by AssResult.[new_assignment_result_id] 
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only