-- declare @Question_ControlDate datetime = @control_date
declare @ass_for_check int = (select last_assignment_for_execution_id from Questions where Id = @Id)

UPDATE [dbo].[Questions]
   SET [control_date] = @control_date
      ,[question_type_id] = @question_type_id
      ,[edit_date] = getutcdate()
      ,[user_edit_id] = @user_edit_id
      ,question_content = @question_content
      ,object_id = @object_id
      ,organization_id = @organization_id
      ,[answer_form_id] = @answer_type_id
      ,[answer_phone] = @answer_phone
      ,[answer_post] = @answer_post
      ,[answer_mail] = @answer_mail
 WHERE Id = @Id
 --  execute define_status_Question  @Id


if @ass_for_check = (select last_assignment_for_execution_id from Questions where Id = @Id)
BEGIN
	if @perfom_id <> (select executor_organization_id from Assignments where Id = (select last_assignment_for_execution_id from Questions where Id = @Id ))
    	begin
    		declare @output_con table (Id int);
			declare @assigment int;
			select @assigment = Id from Assignments where Id = (select last_assignment_for_execution_id from Questions where Id = @Id )

    		UPDATE  [dbo].[Assignments]
    			  set   [executor_organization_id]= @perfom_id -- новый исполнитель на кого переопределили
    				   --,[execution_date]= @execution_date  
    				   ,[edit_date]= getutcdate()
    				   ,[user_edit_id]= @user_edit_id
    				   ,LogUpdated_Query = N'cx_Appeal_Questions_Update_ROW33'
    		WHERE Id= @assigment
    	
    		update dbo.AssignmentConsiderations
    				set	
    				    [edit_date] = getutcdate()
    				   ,[user_edit_id] = @user_edit_id
    				   ,[consideration_date] = getutcdate()
    		where Id = (select current_assignment_consideration_id from Assignments where Id = (select last_assignment_for_execution_id from Questions where Id = @Id ))
    
    	
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
    			values( @assigment
    				    ,GETUTCDATE()
    				    ,1
    				    ,null
    				    ,@user_edit_id
    				    ,GETUTCDATE()
    				    ,@user_edit_id
    				    ,@perfom_id  -- новый исполнитель на кого переопределили
    				    ,GETUTCDATE()
    				    ,GETUTCDATE()
    				   )
    				    
            declare  @new_con int
    		set @new_con = (select top (1) Id from @output_con)
    		update [Assignments] set current_assignment_consideration_id = @new_con where Id = @assigment
    	end
END



/*

UPDATE [dbo].[Questions]
   SET [control_date] = @control_date
      ,[question_type_id] = @question_type_id
      ,[edit_date] = getutcdate()
      ,[user_edit_id] = @user_edit_id
      ,question_content = @question_content
      ,object_id = @object_id
      ,organization_id = @organization_id
 WHERE Id = @Id
 
--  execute define_status_Question  @Id
 
-- update [dbo].[Assignments] 
--     set [executor_organization_id] = @perfom_id
-- where [question_id] = @Id

if @perfom_id <> (select executor_organization_id from Assignments where Id = (select last_assignment_for_execution_id from Questions where Id = @Id ))
    	begin
    		declare @output_con table (Id int);
			declare @assigment int;
			select @assigment = Id from Assignments where Id = (select last_assignment_for_execution_id from Questions where Id = @Id )

    		UPDATE  [dbo].[Assignments]
    			  set   [executor_organization_id]= @perfom_id -- новый исполнитель на кого переопределили
    				   --,[execution_date]= @execution_date  
    				   ,[edit_date]= getutcdate()
    				   ,[user_edit_id]= @user_edit_id
    		WHERE Id= @assigment
    	
    		update dbo.AssignmentConsiderations
    				set	
    				    [edit_date] = getutcdate()
    				   ,[user_edit_id] = @user_edit_id
    				   ,[consideration_date] = getutcdate()
    		where Id = (select current_assignment_consideration_id from Assignments where Id = (select last_assignment_for_execution_id from Questions where Id = @Id ))
    
    	
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
    			values( @assigment
    				    ,GETUTCDATE()
    				    ,1
    				    ,null
    				    ,@user_edit_id
    				    ,GETUTCDATE()
    				    ,@user_edit_id
    				    ,@perfom_id  -- новый исполнитель на кого переопределили
    				    ,GETUTCDATE()
    				    ,GETUTCDATE()
    				   )
    				    
            declare  @new_con int
    		set @new_con = (select top (1) Id from @output_con)
    		update [Assignments] set current_assignment_consideration_id = @new_con where Id = @assigment
    	end
*/