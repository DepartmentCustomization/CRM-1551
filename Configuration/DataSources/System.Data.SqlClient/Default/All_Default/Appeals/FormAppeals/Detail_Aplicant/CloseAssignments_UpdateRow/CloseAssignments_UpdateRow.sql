/*
declare @AssignmentResultsId int = 5, @question_id int = 6689187, @UserId nvarchar(128) = N'Admin', @Question_Prew_Rating int = 1
,@Question_Prew_Comment nvarchar(100) = N'Test'
*/

-----------------------------
	declare @assignment_id int = (select  top 1  last_assignment_for_execution_id from Questions where Id = @question_id)
	declare @assignmentConsideration_id int = (select top 1 current_assignment_consideration_id from Assignments where Id = @assignment_id)
	declare @assignmentRevision_id int = (select  top 1  Id from AssignmentRevisions where assignment_consideration_іd = @assignmentConsideration_id)
	declare @first_executor_organization_id nvarchar(100) = (select  top 1  executor_organization_id from Assignments where Id = @assignment_id)
	

if @AssignmentResultsId = 5	/*На доопрацювання*/
begin
	declare @NEW_AssignmentStateId int,	 @NEW_AssignmentResultsId int,	 @NEW_AssignmentResolutionId int

	select top 1 @NEW_AssignmentStateId = [TransitionAssignmentStates].new_assignment_state_id,
	@NEW_AssignmentResultsId = [TransitionAssignmentStates].new_assignment_result_id,
	@NEW_AssignmentResolutionId = [TransitionAssignmentStates].new_assignment_resolution_id
	from [dbo].[Questions]
	inner join [dbo].[Assignments] on [Assignments].Id = [Questions].last_assignment_for_execution_id
	inner join [dbo].[AssignmentConsiderations] on [AssignmentConsiderations].Id =  [Assignments].[current_assignment_consideration_id]
	inner join [dbo].[AssignmentRevisions] on [AssignmentRevisions].assignment_consideration_іd =  [AssignmentConsiderations].[Id]
	left join [dbo].[TransitionAssignmentStates]  on 
		isnull([TransitionAssignmentStates].old_assignment_result_id,0) = isnull(Assignments.AssignmentResultsId,0) 
		and  isnull([TransitionAssignmentStates].old_assignment_resolution_id,0) = isnull(Assignments.AssignmentResolutionsId,0) 
		and isnull([TransitionAssignmentStates].old_assignment_state_id,0) = isnull(Assignments.assignment_state_id,0)
	    and isnull([TransitionAssignmentStates].new_assignment_result_id,0) = case when isnull([AssignmentRevisions].rework_counter,0)<=2 then 5 /*На доопрацювання*/ when isnull([AssignmentRevisions].rework_counter,0)>2 then 12 /*Фактично*/ end
	where [Questions].[Id] = @question_id
	and [Questions].[question_state_id] = 3	/*На перевірці*/
	and [Assignments].[AssignmentResultsId] in (SELECT [Id] FROM [dbo].[AssignmentResults]  where code in ( N'WasExplained', N'Done', N'ItIsNotPossibleToPerformThisPeriod')) /*Роз"яснено, Виконано, Не можливо виконати в данний період.*/
	
	
	--select @NEW_AssignmentStateId, @NEW_AssignmentResultsId, @NEW_AssignmentResolutionId
	update [dbo].[Assignments] set 
	    		 [AssignmentResultsId] = @NEW_AssignmentResultsId
	    		,[AssignmentResolutionsId] = @NEW_AssignmentResolutionId
	    		,[assignment_state_id] = @NEW_AssignmentStateId
	    		,[state_change_date] = GETUTCDATE()
	    		,[edit_date] = GETUTCDATE()
	    		,[user_edit_id] = @UserId
				,LogUpdated_Query = N'CloseAssignments_UpdateRow42'
	    	where Id = @assignment_id
	
	update dbo.AssignmentRevisions set
	    			 [assignment_resolution_id] = @NEW_AssignmentResolutionId
					 ,[rework_counter] = isnull([rework_counter],0)+1
	    			,[control_result_id] = null
					,[control_date] = GETUTCDATE()
	    			,[grade] = @Question_Prew_Rating
	    			,[grade_comment] = @Question_Prew_Comment
	    			,[edit_date] = GETUTCDATE()
	    			,[user_edit_id] = @UserId
	    		where id = @assignmentRevision_id

	 declare @output_con table (Id int);
	 insert into [dbo].[AssignmentConsiderations] ([assignment_id]
												  ,[consideration_date]
												  ,[assignment_result_id]
												  ,[assignment_resolution_id]
												  ,[first_executor_organization_id]
												  ,[transfer_to_organization_id]
												  ,[turn_organization_id]
												  ,[short_answer]
												  ,[user_id]
												  ,[edit_date]
												  ,[user_edit_id]
												  ,[counter]
												  ,[create_date]
												  ,[transfer_date])
	output inserted.Id into @output_con([Id])
	select @assignment_id as [assignment_id],
		   GETUTCDATE() as [consideration_date],
		   @NEW_AssignmentResultsId as [assignment_result_id],
		   @NEW_AssignmentResolutionId as [assignment_resolution_id],
		   @first_executor_organization_id as [first_executor_organization_id],
		   NULL as [transfer_to_organization_id],
		   NULL as [turn_organization_id],
		   NULL as [short_answer],
		   @UserId as [user_id],
		   GETUTCDATE() as [edit_date],
		   @UserId as [user_edit_id],
		   NULL as [counter],
		   GETUTCDATE() as [create_date],
		   NULL as [transfer_date]
		
		declare @new_con int
		set @new_con = (select top (1) Id from @output_con)
    	update [Assignments] 
		set current_assignment_consideration_id = @new_con
		,[edit_date]=GETUTCDATE()
		where Id = @assignment_id

end
else
begin

	declare @AssignmentResultsCode nvarchar(100) = (select top 1 code from [dbo].[AssignmentResults] where id = @AssignmentResultsId)
	declare @AssignmentResolutionsCode nvarchar(100)
	declare @AssignmentResolutionsId int 
	
	declare @AssignmentTypesToAttentionId int 
	declare @AssignmentResultsToAttentionId int 
	declare @AssignmentResolutionsToAttentionId int 
	
	set @AssignmentTypesToAttentionId = (SELECT top 1 [Id]  FROM [dbo].[AssignmentTypes] where code = N'ToAttention' /*До відома*/)
	set @AssignmentResultsToAttentionId = (select top 1 id from [dbo].[AssignmentResults] where code =  N'AcceptedToAttention' /*Прийнято до відома*/)
	set @AssignmentResolutionsToAttentionId = (SELECT top 1 [Id]  FROM [dbo].[AssignmentTypes] where code = N'GotToKnow' /*Ознайомився*/)
	
	if @AssignmentResultsCode = N'Done' /*Виконано*/
	begin
		set @AssignmentResolutionsId = (select top 1 id from [dbo].[AssignmentResolutions] where code =  N'ApprovedByTheApplicant' /*Підтверджено заявником*/)
		set @AssignmentResolutionsCode = (select top 1 code from [dbo].[AssignmentResolutions] where code =  N'ApprovedByTheApplicant' /*Підтверджено заявником*/)
	end
	if @AssignmentResultsCode = N'Independently' /*Самостійно*/
	begin
	 	set @AssignmentResolutionsId = (select top 1 id from [dbo].[AssignmentResolutions] where code =  N'TheApplicantHasSolvedTheProblemOnHisOwn' /*Заявник усунув проблему власними силами*/)
		set @AssignmentResolutionsCode = (select top 1 code from [dbo].[AssignmentResolutions] where code =  N'TheApplicantHasSolvedTheProblemOnHisOwn' /*Заявник усунув проблему власними силами*/)
	end 
	
	
	declare @output table (Id int)
	
	if (select question_state_id from Questions where Id = @question_id) = 
	    (select top 1 Id from [dbo].[QuestionStates] where code =  N'Closed' /*Закрито*/)
	    begin
	        return
	    end
	    else
	    begin
	
	    	update [dbo].[Questions] set 
	    		[question_state_id] = (select top 1 Id from [dbo].[QuestionStates] where code =  N'Closed' /*Закрито*/),
	    		[edit_date]= GETUTCDATE(),
	    		[user_edit_id] = @UserId
	    	where [Id] = @question_id
	    
	    	update [dbo].[Assignments] set 
	    		 [AssignmentResultsId] = case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResultsId end
	    		,[AssignmentResolutionsId] = case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResolutionsId end 
	    		,[assignment_state_id] = (select top 1 Id from [dbo].[AssignmentStates] where code =  N'Closed' /*Закрито*/)
	    		,[close_date] = GETUTCDATE()
	    		,[edit_date] = GETUTCDATE()
	    		,[user_edit_id] = @UserId
				,LogUpdated_Query = N'CloseAssignments_UpdateRow141'
	    	where Id = @assignment_id
	    
	    	update [dbo].[AssignmentConsiderations] set  
	    		[assignment_result_id] = case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResultsId end
	    		,[assignment_resolution_id] = case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResolutionsId end
	    		,[edit_date] = getutcdate()
	    		,[user_edit_id] = @UserId
	    	from [dbo].[AssignmentConsiderations]
	    	left join [dbo].[Assignments] on [AssignmentConsiderations].Id = [Assignments].current_assignment_consideration_id
	    	where [AssignmentConsiderations].Id = @assignmentConsideration_id									 
	    	
	    	-- если нет ревижина то insert, если есть то update
	    	if (select count(*) from [AssignmentRevisions] where assignment_consideration_іd = @assignmentConsideration_id) = 0
	    	begin --(insert revision)
	    		insert into [dbo].[AssignmentRevisions] 
	    			([assignment_consideration_іd]
	    			,[control_type_id]
	    			,[assignment_resolution_id]
	    			,[control_result_id]
	    			,[organization_id]
	    			,[control_comment]
	    			,[control_date]
	    			,[user_id]
	    			,[grade]
	    			,[grade_comment]
	    			,[rework_counter]
	    			,[edit_date]
	    			,[user_edit_id])
	    		select 
	    			   [AssignmentConsiderations].Id as [assignment_consideration_іd],
	    			   1 as [control_type_id], /*Контроль*/
	    			   case when [Assignments].[assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResolutionsId end as [assignment_resolution_id],
	    			   NULL as [control_result_id],
	    			   NULL as [organization_id],
	    			   NULL as [control_comment],
	    			   NULL as [control_date],
	    			   @UserId as [user_id],
	    			   @Question_Prew_Rating as [grade],
	    			   @Question_Prew_Comment as [grade_comment],
	    			   0 as [rework_counter],
	    			   getutcdate() as [edit_date],
	    			   @UserId as [user_edit_id]
	    		from [dbo].[AssignmentConsiderations]
	    		left join [dbo].[Assignments] on [AssignmentConsiderations].assignment_id = [Assignments].Id
	    		where [AssignmentConsiderations].Id = @assignmentConsideration_id
	    	end --(insert revision)
	    	else
	    	begin --(update revision)
	    		update dbo.AssignmentRevisions set
	    			 [assignment_resolution_id] = @AssignmentResolutionsId
	    			,[control_result_id] = null
					,control_date  = null
	    			,[grade] = @Question_Prew_Rating
	    			,[grade_comment] = @Question_Prew_Comment
	    			,[edit_date] = GETUTCDATE()
	    			,[user_edit_id] = @UserId
	    		where id = @assignmentRevision_id
	    		
	    	end --(update revision)
	    end
end

select 'OK' as TextRes



/*
до 18-06-2019

-- 
declare @AssignmentResultsId int = 4
declare @question_id int = 6688028
declare @UserId nvarchar(128) = N'29796543-b903-48a6-9399-4840f6eac396'
declare @Question_Prew_Rating int = 3
declare @Question_Prew_Comment nvarchar(128) = N'Test auto'



declare @AssignmentResultsCode nvarchar(100) = (select top 1 code from [dbo].[AssignmentResults] where id = @AssignmentResultsId)
declare @AssignmentResolutionsCode nvarchar(100)
declare @AssignmentResolutionsId int 

declare @AssignmentTypesToAttentionId int 
declare @AssignmentResultsToAttentionId int 
declare @AssignmentResolutionsToAttentionId int 

set @AssignmentTypesToAttentionId = (SELECT top 1 [Id]  FROM [dbo].[AssignmentTypes] where code = N'ToAttention' -- До відома)
set @AssignmentResultsToAttentionId = (select top 1 id from [dbo].[AssignmentResults] where code =  N'AcceptedToAttention' -- Прийнято до відома)
set @AssignmentResolutionsToAttentionId = (SELECT top 1 [Id]  FROM [dbo].[AssignmentTypes] where code = N'GotToKnow' -- Ознайомився)

if @AssignmentResultsCode = N'Done' -- Виконано
begin
	set @AssignmentResolutionsId = (select top 1 id from [dbo].[AssignmentResolutions] where code =  N'ApprovedByTheApplicant' -- Підтверджено заявником)
	set @AssignmentResolutionsCode = (select top 1 code from [dbo].[AssignmentResolutions] where code =  N'ApprovedByTheApplicant' -- Підтверджено заявником)
end
if @AssignmentResultsCode = N'Independently' -- Самостійно
begin
 	set @AssignmentResolutionsId = (select top 1 id from [dbo].[AssignmentResolutions] where code =  N'TheApplicantHasSolvedTheProblemOnHisOwn' -- Заявник усунув проблему власними силами)
	set @AssignmentResolutionsCode = (select top 1 code from [dbo].[AssignmentResolutions] where code =  N'TheApplicantHasSolvedTheProblemOnHisOwn' -- Заявник усунув проблему власними силами)
end 

update [dbo].[Assignments] set [AssignmentResultsId] = case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResultsId end
							  ,[AssignmentResolutionsId] = case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResolutionsId end 
							  ,[assignment_state_id] = (select top 1 Id from [dbo].[AssignmentStates] where code =  N'Closed' -- Закрито)
where [question_id] = @question_id


update [dbo].[Questions] set [question_state_id] = (select top 1 Id from [dbo].[QuestionStates] where code =  N'Closed' -- Закрито)
where [Id] = @question_id

declare @output table (Id int)

if (select count(1) from [dbo].[AssignmentConsiderations] where assignment_id in (select Id from [dbo].[Assignments] where [question_id] = @question_id)) = 0
begin
	insert into [dbo].[AssignmentConsiderations] ([assignment_id]
												 ,[consideration_date]
												 ,[assignment_result_id]
												 ,[assignment_resolution_id]
												 ,[first_executor_organization_id]
												 ,[transfer_to_organization_id]
												 ,[turn_organization_id]
												 ,[short_answer]
												 ,[user_id]
												 ,[edit_date]
												 ,[user_edit_id]
												 ,[counter])
output inserted.Id into @output (Id)
	select Id, 
		   getutcdate() as [consideration_date], 
		   case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResultsId end as [assignment_result_id],
		   case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResolutionsId end as [assignment_resolution_id],
		   (select top 1 [Id] from [dbo].[Organizations] where [name] = N'КБУ "Контактний центр міста Києва"') as [first_executor_organization_id],
		   NULL as [transfer_to_organization_id],
		   NULL as [turn_organization_id],
		   N'Створено автоматично' as [short_answer],
		   @UserId as [user_id],
		   getutcdate() as [edit_date],
		   @UserId as [user_edit_id],
		   NULL as [counter]		   
	from [dbo].[Assignments] 
	where [question_id] = @question_id

	insert into [dbo].[AssignmentRevisions] ([assignment_consideration_іd]
											,[control_type_id]
											,[assignment_resolution_id]
											,[control_result_id]
											,[organization_id]
											,[control_comment]
											,[control_date]
											,[user_id]
											,[grade]
											,[grade_comment]
											,[rework_counter]
											,[edit_date]
											,[user_edit_id])
	select t.Id as [assignment_consideration_іd],
		   1 as [control_type_id], -- Контроль
		   case when [Assignments].[assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResolutionsId end as [assignment_resolution_id],
		   NULL as [control_result_id],
		   NULL as [organization_id],
		   NULL as [control_comment],
		   NULL as [control_date],
		   @UserId as [user_id],
		   @Question_Prew_Rating as [grade],
		   @Question_Prew_Comment as [grade_comment],
		   0 as [rework_counter],
		   getutcdate() as [edit_date],
		   @UserId as [user_edit_id]
	from @output as t
	left join [dbo].[AssignmentConsiderations] on [AssignmentConsiderations].Id = t.Id
	left join [dbo].[Assignments] on [AssignmentConsiderations].assignment_id = [Assignments].Id
end
else
begin

	update [dbo].[AssignmentConsiderations] set  [assignment_result_id] = case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResultsId end
												,[assignment_resolution_id] = case when [assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResolutionsId end
												,[edit_date] = getutcdate()
												,[user_edit_id] = @UserId
	from [dbo].[AssignmentConsiderations]
	left join [dbo].[Assignments] on [AssignmentConsiderations].assignment_id = [Assignments].Id
	where [Assignments].[question_id] = @question_id										 
	
	insert into [dbo].[AssignmentRevisions] ([assignment_consideration_іd]
											,[control_type_id]
											,[assignment_resolution_id]
											,[control_result_id]
											,[organization_id]
											,[control_comment]
											,[control_date]
											,[user_id]
											,[grade]
											,[grade_comment]
											,[rework_counter]
											,[edit_date]
											,[user_edit_id])
	select [AssignmentConsiderations].Id as [assignment_consideration_іd],
		   1 as [control_type_id], -- Контроль
		   case when [Assignments].[assignment_type_id] = @AssignmentTypesToAttentionId then @AssignmentResultsToAttentionId else @AssignmentResolutionsId end as [assignment_resolution_id],
		   NULL as [control_result_id],
		   NULL as [organization_id],
		   NULL as [control_comment],
		   NULL as [control_date],
		   @UserId as [user_id],
		   @Question_Prew_Rating as [grade],
		   @Question_Prew_Comment as [grade_comment],
		   0 as [rework_counter],
		   getutcdate() as [edit_date],
		   @UserId as [user_edit_id]
	from [dbo].[AssignmentConsiderations]
	left join [dbo].[Assignments] on [AssignmentConsiderations].assignment_id = [Assignments].Id
	where [Assignments].[question_id] = @question_id
end


select 'OK' as TextRes
*/