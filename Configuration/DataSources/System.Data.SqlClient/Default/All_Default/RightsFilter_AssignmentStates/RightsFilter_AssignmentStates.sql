--declare @programuser_id nvarchar(128) = N'45d2f527-bd52-47ef-bc6c-4e0943d8e333'
declare @form nvarchar(128) = N'Assignment'

declare @old_assignment_state_id int = (select Assignments.assignment_state_id from [dbo].[Assignments] where Id = @AssignmentId)
declare @old_assignment_result_id int = (select Assignments.AssignmentResultsId from [dbo].[Assignments] where Id = @AssignmentId)
declare @old_assignment_resolution_id int = (select Assignments.AssignmentResolutionsId from [dbo].[Assignments] where Id = @AssignmentId)

;with AssResult as(
    SELECT  distinct [TransitionAssignmentStates].[new_assignment_result_id] as [Id],
                     [AssignmentResults].[name] as [Name],
                     [TransitionAssignmentStates].[new_assignment_result_id] 
    FROM [dbo].[TransitionAssignmentStates]
    inner join [dbo].[AssignmentResults] on [AssignmentResults].Id = [TransitionAssignmentStates].new_assignment_result_id
    where [AssignmentResults].code in (select result_code from [AssignmentResultInType] where [assignment_type_id] = (select [assignment_type_id] from [dbo].[Assignments] where Id = @AssignmentId))
	and [TransitionAssignmentStates].id in (
			select referencevalue_id  
			FROM [dbo].[PosibilitiesForRoles]
			where role_id in (SELECT 
			      [role_id]
			  FROM [dbo].[Positions]
			  where programuser_id = @programuser_id)
			and RulesforRightsId in (SELECT [id]
			  FROM [dbo].[RulesforRights]
			  where formcode = @form)
			and [PosibilitiesForRoles].colunmcode = N'transitionassignmentstate'
			)
		and isnull([TransitionAssignmentStates].old_assignment_state_id,0) = isnull(@old_assignment_state_id,0) 
		and isnull([TransitionAssignmentStates].old_assignment_result_id,0) = isnull(@old_assignment_result_id,0)
		and isnull([TransitionAssignmentStates].old_assignment_resolution_id,0) = isnull(@old_assignment_resolution_id,0)
		        
        except
        
        SELECT distinct [TransitionAssignmentStates].[new_assignment_result_id] as [Id],
                        [AssignmentResults].[name] as [Name],
                        [TransitionAssignmentStates].[new_assignment_result_id] 
        FROM [dbo].[TransitionAssignmentStates]
        inner join [dbo].[AssignmentResults] on [AssignmentResults].Id = [TransitionAssignmentStates].new_assignment_result_id
        where [AssignmentResults].code in (select result_code from [AssignmentResultInType] where [assignment_type_id] = (select [assignment_type_id] from [dbo].[Assignments] where Id = @AssignmentId))
		and [TransitionAssignmentStates].id in (
	    		select referencevalue_id  
	    		FROM [dbo].[PosibilitiesForRoles]
	    		where role_id in (SELECT 
	    		      [role_id]
	    		  FROM [dbo].[Positions]
	    		  where programuser_id = @programuser_id)
	    		and RulesforRightsId in (SELECT [id]
	    		  FROM [dbo].[RulesforRights]
	    		  where formcode = @form)
	    		and [PosibilitiesForRoles].colunmcode = N'transitionassignmentstate'
	    		)
	    	and isnull([TransitionAssignmentStates].old_assignment_state_id,0) = isnull(@old_assignment_state_id,0) 
	    	and isnull([TransitionAssignmentStates].old_assignment_result_id,0) = isnull(@old_assignment_result_id,0)
	    	and isnull([TransitionAssignmentStates].old_assignment_resolution_id,0) = isnull(@old_assignment_resolution_id,0)
            and [TransitionAssignmentStates].[new_assignment_result_id] = @res_id
		
)

 select Id, 
 Name 
 from AssResult
  where #filter_columns#
order by AssResult.[new_assignment_result_id] 
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only