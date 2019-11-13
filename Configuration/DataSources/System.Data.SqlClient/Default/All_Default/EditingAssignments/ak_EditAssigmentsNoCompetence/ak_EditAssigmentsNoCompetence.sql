
  --declare @Id int= 2809496;

  declare @resultId int=(select [AssignmentResultsId] from [Assignments] where Id=@Id);
  declare @resolutionId int=(select [AssignmentResolutionsId] from [Assignments] where Id=@Id);
  declare @stateId int=(select [assignment_state_id] from [Assignments] where Id=@Id);

  if @resultId=3 and @resolutionId=3 and @stateId=5
  begin

  declare @Id_cons int=(select top 1 [current_assignment_consideration_id]
  from [Assignments] inner join
  [AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
  where [Assignments].Id=@Id
  order by [AssignmentConsiderations].Id);



  declare @result_Id int=(select [new_assignment_result_id]
  from [TransitionAssignmentStates]
  where [old_assignment_state_id] =@stateId
  and [old_assignment_result_id]=@resultId
  and [old_assignment_resolution_id]=@resolutionId)

  declare @resolution_Id int=(
  select [new_assignment_resolution_id]
  from [TransitionAssignmentStates]
  where [old_assignment_state_id] =@stateId
  and [old_assignment_result_id]=@resultId
  and [old_assignment_resolution_id]=@resolutionId
  )

  declare @state_Id int=(
  select [new_assignment_state_id]
  from [TransitionAssignmentStates]
  where [old_assignment_state_id] =@stateId
  and [old_assignment_result_id]=@resultId
  and [old_assignment_resolution_id]=@resolutionId
  )

  
  --select @Id, @Id_cons, @result_Id, @resolution_Id, @state_Id
  
  update [Assignments]
  set [assignment_state_id]=@state_Id,
	  [AssignmentResultsId]=@result_Id,
	  [AssignmentResolutionsId]=@resolution_Id,
	  [edit_date]=GETUTCDATE(),
      [user_edit_id]=@user_id,
      [LogUpdated_Query] = N'ak_EditAssigmentsNoCompetence_ROW50'
  where Id=@Id

  update [AssignmentConsiderations]
  set [assignment_result_id]=@result_Id
      ,[assignment_resolution_id]=@resolution_Id
	  ,[edit_date]=GETUTCDATE()
      ,[user_edit_id]=@user_id
  where Id=@Id_cons

  update [AssignmentRevisions]
  set [assignment_resolution_id]=@resolution_Id
      ,[control_result_id]=@result_Id
	   ,control_date = GETUTCDATE()
	  ,[edit_date]=GETUTCDATE()
      ,[user_edit_id]=@user_id
  where assignment_consideration_іd=@Id_cons
  
  end