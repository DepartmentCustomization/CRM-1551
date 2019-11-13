IF not exists (select * from Assignments where [executor_organization_id] = @organization_id and [question_id] = @question_id and state_change_date <> 5)
BEGIN

	declare @output table ([Id] int);
	declare @output_c table ([Id_c] int);
	declare @ass_id int;
	declare @con_id int;
	declare @parent_org_id int
	declare @parent_org_id2 int 
	declare @head_name nvarchar(50)
	declare @pro_work int
	declare @count int = 0

				-- вычесляем відповідальний - батьківська організація виконавця
					select @parent_org_id2 = parent_organization_id  from Organizations where Id = @organization_id; 
					select @head_name = head_name, @parent_org_id = Id  from Organizations where Id = @parent_org_id2 
					--select @head_name, @parent_org_id


					while(@head_name is null or @head_name = '') 
					begin
						set @count = @count + 1
						select    @parent_org_id= Id
								, @parent_org_id2 = parent_organization_id
								, @head_name = head_name  
							from Organizations where Id = @parent_org_id2

						if @count >10 
						begin
							if @pro_work = 1 
								begin
									set @parent_org_id = @organization_id
								end
							else
								begin
									set @parent_org_id = 1762
								end 
							break
						end
					end

			--select @head_name, @parent_org_id


	INSERT INTO [dbo].[Assignments]
			   ([question_id]
			   ,[assignment_type_id]
			   ,[registration_date]
			   ,[assignment_state_id]
			   ,[state_change_date]
			   ,[organization_id]
			   ,[executor_organization_id]
			   ,[main_executor]
			   ,[execution_date]
			   ,[user_id]
			   ,[edit_date]
			   ,[user_edit_id]
			   ,AssignmentResultsId
			   ,AssignmentResolutionsId
			   ,LogUpdated_Query)

		output inserted.Id into @output([Id])
		  VALUES(
				   @question_id
				  , 1
				  ,GETUTCDATE()
				  ,1
				  ,GETUTCDATE()
				  ,@parent_org_id
				  ,@organization_id
				  ,0
				  ,(select control_date from Questions where Id= @question_id)
				  ,@user_edit_id
				  ,GETUTCDATE()
				  ,@user_edit_id
				  ,1
				  ,null
				  ,N'cx_InsetManyNewAssigments_ROW78'
				)

	set @ass_id = (select top 1 [Id] from @output);

		insert into dbo.AssignmentConsiderations
			(		[assignment_id]
				   ,[consideration_date]
				   ,[assignment_result_id]
				   ,[assignment_resolution_id]
				   ,[user_id]
				   ,[edit_date]
				   ,[user_edit_id]
				   ,[create_date]
				   ,[transfer_date]
				   ,first_executor_organization_id
				)
		output inserted.Id into @output_c([Id_c])
			 VALUES
				   (@ass_id
				   ,getutcdate()
				   ,1
				   ,null
				   ,@user_edit_id
				   ,getutcdate()
				   ,@user_edit_id
				   ,getutcdate()
				   ,getutcdate()
				   ,@organization_id)
           
           
	set @con_id = (select top 1 [Id_c] from @output_c);
	update Assignments set [current_assignment_consideration_id] = @con_id 
	,edit_date = GETUTCDATE()
				,user_edit_id = @user_edit_id
	where Id = @ass_id
END     
