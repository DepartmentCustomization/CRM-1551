declare @output table ([Id] int, [Id_c] int);
declare @ass_id int;
declare @con_id int;

INSERT INTO [dbo].[Assignments]
           ([question_id]
           ,[assignment_type_id]
           ,[registration_date]
        --   ,[transfer_date]
           ,[assignment_state_id]
           ,[state_change_date]
           ,[close_date]
           ,[organization_id]
           ,[executor_organization_id]
           ,[main_executor]
        --   ,[executor_person_id]
           ,[execution_date]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id]
           ,AssignmentResultsId
           ,AssignmentResolutionsId
           ,LogUpdated_Query)

	output inserted.Id into @output([Id])
     VALUES
           (@question_id 
           ,@ass_type_id 
           ,getutcdate() 
        --   ,@transfer_date 
           ,@ass_state_id 
           ,getutcdate()
           ,@close_date 
           ,@organization_id 
           ,@performer_id 
           ,@main_executor
        --   ,@executor_person_id 
           ,@execution_date 
           ,@user_id 
           ,getutcdate()  
           ,@user_edit_id
           ,@result_id
           ,@resolution_id
           ,N'cx_App_Que_Assignments_Insert_ROW44')

	set @ass_id = (select top 1 [Id] from @output);

insert into dbo.AssignmentConsiderations
	(		[assignment_id]
           ,[consideration_date]
           ,[assignment_result_id]
           ,[assignment_resolution_id]
           ,[short_answer]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id]
           ,turn_organization_id
		   ,[create_date]
		   ,[transfer_date]
		)
    output inserted.Id into @output([Id_c])
     VALUES
           (@ass_id
           ,getutcdate()
           ,@result_id
           ,@resolution_id
           ,@short_answer
           ,@user_id
           ,getutcdate()
           ,@user_edit_id
           ,@turn_organization_id
           ,getutcdate()
           ,getutcdate())
           
           
set @con_id = (select top 1 [Id_c] from @output);
update Assignments 
set [current_assignment_consideration_id] = @con_id
,[edit_date]=getutcdate()
where Id = @ass_id
           
select  @ass_id as Id
return;
           
