declare @output_con table (Id int);
declare @new_con int;
declare @result_id int;
declare @resolution_id int;
declare @current_consid int;
declare @ass_state_id  int
	select @ass_state_id  = assignment_state_id
	, @result_id = AssignmentResultsId
	, @resolution_id = AssignmentResolutionsId
	, @current_consid = current_assignment_consideration_id 
	from Assignments where Id = @Id

-- 	if @result_id = 1 and @resolution_id is null and @executor_organization_id is not null
	if  @executor_organization_id is not null
	begin
    -- 	if @executor_organization_id <> (select organization_id from Assignments where Id = @Id)
    -- 	begin
    		
    		UPDATE  [dbo].[Assignments]
    			  set   --[assignment_state_id]= @ass_state_id 
    				    [executor_organization_id]= @executor_organization_id -- новый исполнитель на кого переопределили  
    				   ,[edit_date]= getutcdate()
    				   ,[user_edit_id]= @user_edit_id
					  ,[LogUpdated_Query] = N'Button_Nadiishlo_Rozpodility_Row24'
    				   --,[AssignmentResultsId] = @result_id
    				   --, AssignmentResolutionsId= @resolution_id
    		WHERE Id= @Id
    	
    		update dbo.AssignmentConsiderations
    				set	
    				    [edit_date] = getutcdate()
    				   ,[user_edit_id] = @user_edit_id
    				   ,[consideration_date] = getutcdate()
    		where Id = @current_consid 
    
    		delete from @output_con
    		insert into dbo.AssignmentConsiderations
    			(		[assignment_id]
    				   ,[consideration_date]
    				   ,[assignment_result_id]
    				   ,[assignment_resolution_id]
    				   ,[user_id]
    				   ,[edit_date]
    				   ,[user_edit_id]
    				   ,[first_executor_organization_id]
    				   ,create_date
    				   ,transfer_date
    			)
    			output inserted.Id into @output_con([Id])
    			values( @Id
    				    ,GETUTCDATE()
    				    ,@result_id
    				    ,@resolution_id
    				    ,@user_edit_id
    				    ,GETUTCDATE()
    				    ,@user_edit_id
    				    ,@executor_organization_id  -- новый исполнитель на кого переопределили
    				    ,GETUTCDATE()
    				    ,GETUTCDATE()
    				   )
    
    		set @new_con = (select top (1) Id from @output_con)
    		update [Assignments] set current_assignment_consideration_id = @new_con 
			,[edit_date]=GETUTCDATE()
			where Id = @Id
    -- 	end
	end