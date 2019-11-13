

declare @output table ([Id] int);
declare @output_con table (Id int);
declare @new_con int;
declare @ass_id int;
declare @ass_cons_id int
declare @parent_id int = ( select organization_id from Assignments where Id = @Id )
set @ass_cons_id = (select id from AssignmentConsiderations where Id = @current_consid)
declare @result_of_checking int
declare @is_main_exec bit

exec [dbo].pr_check_right_choice_result_resolution @Id, @result_id, @resolution_id, @ass_state_id, @result_of_checking OUTPUT
if @result_of_checking = 0
	begin
		RAISERROR ('Стан доручення залишився попереднім, оновіть сторінку, та спробуйте ще раз', 16, 1);
        return;
	end

IF (select assignment_state_id from Assignments where Id = @Id) = (SELECT [Id] FROM [dbo].[AssignmentStates] where code = 'Closed')
BEGIN 
	return;
END
ELSE
BEGIN
    -- проверка если открыто более одного окна с дорученням
	IF (select edit_date from Assignments where Id = @Id ) <> @date_in_form
    BEGIN
     RAISERROR ('З моменту відкриття картки дані вже було змінено. Оновіть сторінку, щоб побачити зміни.', -- Message text.
               16, -- Severity.
               1 -- State.
               );
        return;
    END
	ELSE
	BEGIN
    --если результат, резолюция не изменились и...
	IF @result_id = (select AssignmentResultsId from Assignments where id = @Id) 
	    and (@resolution_id = (select AssignmentResolutionsId from Assignments where id = @Id) or @resolution_id is null ) 
	    -- and @performer_id = @parent_id
		begin
			-- если виконавець не изменился но апдейтим только коментарий исполнителя + сис.поля
			if @performer_id = ( select executor_organization_id from Assignments where Id = @Id ) --@parent_id
			 begin
    			 update AssignmentConsiderations 
    				set short_answer =  @short_answer
    				,[edit_date] = getutcdate()
    				,[user_edit_id] = @user_edit_id
    				where Id = @current_consid
    			 return
			 end;
			 else
			 -- если виконавець изменился то логика как при "Перерозподіл на підрядну організацію (если поменялся исполнитель)"
			 begin
				UPDATE  [dbo].[Assignments]
    			  set  [assignment_state_id]= @ass_state_id 
    				   ,[executor_organization_id]= @performer_id -- новый исполнитель на кого переопределили
    				   ,[execution_date]= @execution_date  
    				   ,[edit_date]= getutcdate()
    				   ,[user_edit_id]= @user_edit_id
					   ,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row51'
    		WHERE Id= @Id
    	
    		update dbo.AssignmentConsiderations
    				set	
    				    [short_answer] = @short_answer
    				   ,[edit_date] = getutcdate()
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
    				   ,[short_answer]
    			)
    			output inserted.Id into @output_con([Id])
    			values( @Id
    				    ,GETUTCDATE()
    				    ,@result_id
    				    ,@resolution_id
    				    ,@user_edit_id
    				    ,GETUTCDATE()
    				    ,@user_edit_id
    				    ,@performer_id  -- новый исполнитель на кого переопределили
    				    ,GETUTCDATE()
    				    ,GETUTCDATE()
    				    ,@short_answer
    				   )
    
    		    set @new_con = (select top (1) Id from @output_con)
    		    update [Assignments] set 
					current_assignment_consideration_id = @new_con,
					edit_date = GETUTCDATE(),
					user_edit_id = @user_edit_id
					,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row95'
				where Id = @Id
    		    return
			 end;
		 end
	else
	BEGIN -- (F11)

	-- 	Перерозподіл на підрядну організацію (если поменялся исполнитель)
	if @result_id = 1 and @resolution_id is null
	begin
	    --AL. если предыдущий результат - "Не в компетенции" тo
	    if (select AssignmentResultsId from Assignments where Id = @Id) = 3
	    begin 
		    set @performer_id = @transfer_to_organization_id
	    end
	
	    
    	if @performer_id <> (select organization_id from Assignments where Id = @Id)
    	begin
    		
    		UPDATE  [dbo].[Assignments]
    			  set  [assignment_state_id]= @ass_state_id 
    				   ,[executor_organization_id]= @performer_id -- новый исполнитель на кого переопределили
    				   ,[execution_date]= @execution_date  
    				   ,[edit_date]= getutcdate()
    				   ,[user_edit_id]= @user_edit_id
					   ,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row115'
    				   ,[AssignmentResultsId] = @result_id
    				   , AssignmentResolutionsId= @resolution_id
    		WHERE Id= @Id
    	
    		update dbo.AssignmentConsiderations
    				set	
    				    [short_answer] = @short_answer
    				   ,[edit_date] = getutcdate()
    				   ,[user_edit_id] = @user_edit_id
    				   ,[consideration_date] = getutcdate()
    		where Id = @current_consid -- assignment_id = @Id
    
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
    				   , [short_answer]
    			)
    			output inserted.Id into @output_con([Id])
    			values( @Id
    				    ,GETUTCDATE()
    				    ,1
    				    ,null
    				    ,@user_edit_id
    				    ,GETUTCDATE()
    				    ,@user_edit_id
    				    ,@performer_id  -- новый исполнитель на кого переопределили
    				    ,GETUTCDATE()
    				    ,GETUTCDATE()
    				    ,@short_answer
    				   )
    
    		set @new_con = (select top (1) Id from @output_con)
    		update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id
    	end
    -- 	execute define_status_Question @question_id
    -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
		return;
	end


    -- 9 Прийнято в роботу	AcceptedInWork 
	if @result_id = 9 and @resolution_id is null
	begin
	-- Прийняття доручення в роботу  (2 В роботі InWork)
	   -- if @ass_state_id = 2  
	    	update AssignmentConsiderations 
	    	set 
	    	    transfer_date = GETUTCDATE() 
			   ,[edit_date] = getutcdate()
			   ,[user_edit_id] = @user_edit_id
			   ,[assignment_result_id] = @result_id
			   ,[assignment_resolution_id] = @resolution_id
			   ,[short_answer] = @short_answer
	    	where  Id = @current_consid
	    	
	    	update [Assignments] 
			set  AssignmentResultsId = @result_id
				,AssignmentResolutionsId = @resolution_id
			   ,[edit_date] = getutcdate()
			   ,[user_edit_id] = @user_edit_id
			   ,[assignment_state_id]= @ass_state_id 
			   ,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row186'
			where Id = @Id
-- 			execute define_status_Question @question_id
    -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
		return;
    end


	-- 3 Не в компетенції	NotInTheCompetence 
	-- 14 Повернуто в батьківську організацію	returnedToParentOrganization
	if @result_id = 3 and @resolution_id = 14
	begin
	   -- Якщо можливий виконавець знаходиться Не в організаційній структурі батьківської організації, 
	   -- то доручення формується з станом - На перевірці, результатом - Не в компетенції. резолюція - Повернуто в 1551. (CRM1551-221)
	   -- процедура проверяет pr_check_relatives - если возможный исполнитель является дочерней орг.родителя то возвращает "1"
	   -- принимает парам.1- родитель, парам.2 - возможный исполнитель, парам.3 - возвращаемый параметр проверки 
		declare @check bit
		exec pr_check_relatives @parent_id, @transfer_to_organization_id, @check output
		if @check = 1
		begin
			update dbo.AssignmentConsiderations
				set	
					consideration_date = GETUTCDATE()
				   ,short_answer = @short_answer
				   ,transfer_to_organization_id = @transfer_to_organization_id
				   ,[edit_date] = getutcdate()
				   ,[user_edit_id] = @user_edit_id
				   ,[assignment_result_id] = @result_id
				   ,[assignment_resolution_id] = @resolution_id
			where Id = @current_consid
		
			update [Assignments] 
				set  AssignmentResultsId = @result_id
					,AssignmentResolutionsId = @resolution_id
					,assignment_state_id = @ass_state_id -- 04_04
				   ,[edit_date] = getutcdate()
				   ,[user_edit_id] = @user_edit_id
				   ,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row223'
				where Id = @Id

		
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
						   ,turn_organization_id
						   ,transfer_to_organization_id
						   ,short_answer
					)
					output inserted.Id into @output_con([Id])
					values( @Id
							,GETUTCDATE()
							,@result_id
							,@resolution_id
							,@user_edit_id
							,GETUTCDATE()
							,@user_edit_id
							,( select organization_id from Assignments where Id = @Id )
							,GETUTCDATE()
							,GETUTCDATE()
							,( select organization_id from Assignments where Id = @Id )
							,@transfer_to_organization_id
							,@short_answer
						   )

				set @new_con = (select top (1) Id from @output_con)
				update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id
				-- execute define_status_Question @question_id
				-- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
		   end

		  else
		   
		   begin
			set @result_id = 3 -- Не в компетенції
			set @resolution_id = 1  -- Повернуто в 1551
			set @ass_state_id = 3 -- На перевірці

			update AssignmentConsiderations
				set	 
					 consideration_date = GETUTCDATE()
					,short_answer = @short_answer
					,transfer_to_organization_id = @transfer_to_organization_id
					,[assignment_result_id] = @result_id
					,[assignment_resolution_id] = @resolution_id
					,turn_organization_id = 1762
					where Id = @current_consid 

			update [Assignments] 
				set  AssignmentResultsId = @result_id
					,AssignmentResolutionsId = @resolution_id
					,[assignment_state_id]= @ass_state_id 
					,[edit_date]= getutcdate()
					,[user_edit_id]= @user_edit_id
					,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row288'
				where Id = @Id

				INSERT INTO [dbo].[AssignmentRevisions]
						   ([assignment_consideration_іd]
						   ,[control_type_id]
						   ,[assignment_resolution_id]
						   ,[control_comment]
						--    ,[control_date]
						   ,[user_id]
						   ,[rework_counter]
						   ,[edit_date]
						   ,[user_edit_id])
					 VALUES
						   (@current_consid --@ass_cons_id
						   ,1  -- @control_type_id = Контроль, Продзвон, Контроль заявником
						   ,@resolution_id -- @assignment_resolution_id
						   ,@control_comment
						--    ,getutcdate() 
						   ,@user_edit_id --@user_id
						  -- ,@rework_counter_count
						   ,@rework_counter
						   ,getutcdate() --@edit_date
						   ,@user_edit_id
						   )
			   end
    -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
		return;
	end


	-- 3 Не в компетенції	NotInTheCompetence  
	-- 1 Повернуто в 1551	returnedIn1551
	if @result_id = 3 and @resolution_id = 1 
	begin
		update AssignmentConsiderations
			set	 
				 consideration_date = GETUTCDATE()
			    ,short_answer = @short_answer
			    ,transfer_to_organization_id = @transfer_to_organization_id
			    ,[assignment_result_id] = @result_id
				,[assignment_resolution_id] = @resolution_id
				,turn_organization_id = 1762
				where Id = @current_consid 

		update [Assignments] 
			set  AssignmentResultsId = @result_id
				,AssignmentResolutionsId = @resolution_id
				,[assignment_state_id]= @ass_state_id 
				,[edit_date]= getutcdate()
				,[user_edit_id]= @user_edit_id
				,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row339'
			where Id = @Id

			INSERT INTO [dbo].[AssignmentRevisions]
					   ([assignment_consideration_іd]
					   ,[control_type_id]
					   ,[assignment_resolution_id]
					   ,[control_comment]
					--    ,[control_date]
					   ,[user_id]
					   ,[rework_counter]
					   ,[edit_date]
					   ,[user_edit_id])
				 VALUES
					   (@current_consid --@ass_cons_id
					   ,1 -- @control_type_id = Контроль, Продзвон, Контроль заявником
					   ,@resolution_id -- @assignment_resolution_id
					   ,@control_comment
					--    ,getutcdate() 
					   ,@user_edit_id --@user_id
					  -- ,@rework_counter_count
					   ,@rework_counter
					   ,getutcdate() --@edit_date
					   ,@user_edit_id
					   )
-- 			execute define_status_Question @question_id
    -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
			return;
	end


	 -- Если перенаправлено за належністю из 1551
	if (select AssignmentResolutionsId from Assignments where Id = @Id) = 1 -- Повернуто в 1551	returnedIn1551
	BEGIN -- tt
		--   возвращается тому-же виконавцю, тоесть не в комтепенции Не подтверждено
		-- 6 Повернуто виконавцю	returnedToTheArtist
		-- 3 Перенаправлено за належністю	RedirectedByAffiliation
		if @result_id = 6 and @resolution_id = 3
			begin
				 
				 --if @transfer_to_organization_id = (select first_executor_organization_id from AssignmentConsiderations where Id = @current_consid) 
				  --or @transfer_to_organization_id is null
					--begin
						set @transfer_to_organization_id = (select first_executor_organization_id from AssignmentConsiderations where Id = @current_consid)
	
						-- закрываем Ревижн, + новый AssignmentConsiderations на того же самого исполнителя.
						update AssignmentRevisions 
								set [assignment_resolution_id] = @resolution_id
									,organization_id = @transfer_to_organization_id
									,[control_comment] = @control_comment
									,[rework_counter] = @rework_counter
									,[edit_date] = getutcdate()
									,[user_edit_id] = @user_edit_id
									,control_result_id = @resolution_id
									,control_date = getutcdate()
								where assignment_consideration_іd = @current_consid

						update Assignments 
								set
								 AssignmentResultsId = @result_id -- Какие результат и резолучия должны быть????
								,AssignmentResolutionsId = @resolution_id
								,assignment_state_id = @ass_state_id -- 04_04
								,edit_date = GETUTCDATE()
								,user_edit_id = @user_edit_id
								,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row404'
								 where id = @Id
		
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
								   ,[short_answer]
							)
							output inserted.Id into @output_con([Id])
							values( @Id
									,GETUTCDATE()
									,@result_id
									,@resolution_id
									,@user_edit_id
									,GETUTCDATE()
									,@user_edit_id
									,@transfer_to_organization_id
									,GETUTCDATE()
									,GETUTCDATE()
									,@short_answer
								   )

						set @new_con = (select top (1) Id from @output_con)
						update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id

					--end
				-- execute define_status_Question @question_id
    -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
				return;
			end
				
		-- 3 Не в компетенції	NotInTheCompetence
		-- 3 Перенаправлено за належністю	RedirectedByAffiliation
		IF @result_id = 3 and @resolution_id = 3
			BEGIN -- 3\3
						--закрываем старое  Assignments и AssignmentConsiderations и AssignmentRevisions
	 					update Assignments 
								set 
								 --main_executor = 0
								 close_date = getutcdate()
								,AssignmentResultsId = @result_id
								,AssignmentResolutionsId = @resolution_id
								,assignment_state_id = @ass_state_id -- 04_04
								,edit_date = GETUTCDATE()
								,user_edit_id = @user_edit_id
								,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row458'
								 where id = @Id

						update dbo.AssignmentConsiderations 
							set	consideration_date = GETUTCDATE()
								,assignment_result_id = @result_id
								,assignment_resolution_id = @resolution_id
								,transfer_to_organization_id = @transfer_to_organization_id
								,edit_date = GETUTCDATE()
								,user_edit_id = @user_edit_id
								,[short_answer] = @short_answer
							 where Id=@current_consid -- assignment_id = @Id

						update AssignmentRevisions 
								set [assignment_resolution_id] = @resolution_id
									,organization_id = @transfer_to_organization_id
									,[control_comment] = @control_comment
									,[rework_counter] = @rework_counter
									,[edit_date] = getutcdate()
									,[user_edit_id] = @user_edit_id
									,control_result_id = @resolution_id
									,control_date = getutcdate()
								where assignment_consideration_іd = @current_consid

						delete from @output;
						delete from @output_con;

							-- если на Можливого виконавеця нет доруч. в этом вопросе то создаем новый  Assignments и AssignmentConsiderations...
							if not exists (select 1 from Assignments where question_id = (select question_id from Assignments where Id = @Id)
								 and executor_organization_id = @transfer_to_organization_id)
							BEGIN

								declare @tested_transfer int
								declare @ass_id_for_main int
								exec [dbo].Check_transfer_organizations @Id, @transfer_to_organization_id, @tested_transfer output, @ass_id_for_main output

								if @tested_transfer = 0
									begin
											-- создаем новое Assignments и AssignmentConsiderations
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
												select ass.question_id
												  ,ass.assignment_type_id
												  ,GETUTCDATE()
												  ,1	--Зареєстровано
												  ,GETUTCDATE()
												  --,(select first_executor_organization_id from AssignmentConsiderations where Id=@current_consid)
												  ,@transfer_to_organization_id
												  ,@transfer_to_organization_id
												--   ,1 --main
												  ,main_executor
												  ,ass.execution_date
												  ,@user_edit_id
												  ,GETUTCDATE()
												  ,@user_edit_id
												  ,1	--Очікує прийому в роботу
												  ,null
												  ,N'cx_App_Que_Assignments_Update_Row522'
												from Assignments as ass where ass.id = @Id

											set @ass_id = (select top 1 [Id] from @output);

											insert into dbo.AssignmentConsiderations
											(		[assignment_id]
												   ,[consideration_date]
												   ,[assignment_result_id]
												   ,[assignment_resolution_id]
												   ,[user_id]
												   ,[edit_date]
												   ,[user_edit_id]
												   ,turn_organization_id
												   ,[first_executor_organization_id]
												   ,[short_answer]
												   ,create_date)
											output inserted.Id into @output_con([Id])
											 select @ass_id
												   ,getutcdate()
												   ,1	--Очікує прийому в роботу
												   ,null
												   ,@user_edit_id
												   ,getutcdate()
												   ,@user_edit_id
												   ,null
												--   ,first_executor_organization_id
												   ,@transfer_to_organization_id
												   ,@short_answer
												   ,getutcdate()
												from AssignmentConsiderations where Id = @current_consid
		
											--  проверка если это главное доручення то меняем в Вопросе last_assignment_for_execution_id
											if (select main_executor from Assignments where Id = @Id) = 1
											begin
												update Questions set 
													last_assignment_for_execution_id = @ass_id,
													edit_date = GETUTCDATE(),
													user_edit_id = @user_edit_id
											where last_assignment_for_execution_id = @Id
											end

											set @new_con = ( select top(1) Id from @output_con)
											update [Assignments] set main_executor = 0,
																	[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row563' 
											where Id = @Id
											update [Assignments] set current_assignment_consideration_id = @new_con,
																	[LogUpdated_Query]= N'cx_App_Que_Assignments_Update_Row590' 
											where Id = @ass_id
										end
										else -- if @tested_transfer = 1
										begin
											UPDATE [Assignments] SET 
												main_executor = 1,
												[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row600',
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id 
											WHERE Id = @ass_id_for_main

											UPDATE Questions 
												set last_assignment_for_execution_id = @ass_id_for_main,
													edit_date = GETUTCDATE(),
													user_edit_id = @user_edit_id
												where Id = @question_id

											UPDATE Assignments 	SET 
													 main_executor = 0
													,edit_date = GETUTCDATE()
													,user_edit_id = @user_edit_id
													,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row616'
													WHERE id = @Id

										end
										-- update [Assignments] set main_executor = 0,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row596' where Id = @Id
									--select  @ass_id as Id
							end
							else
							begin
								-- update [Assignments] set main_executor = 0,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row572' where Id = @Id
								select @is_main_exec  = main_executor from Assignments where Id = @Id
						    
								-- Id-ка доручення в этом вопросе где есть можливий
								declare @New_Ass int = (select top 1 Id from Assignments where question_id = (select question_id from Assignments where Id = @Id) 
																						and executor_organization_id = @transfer_to_organization_id)
								
								-- Есть доручення на можливого, закрытое с резултатом Не в компетенции
								if exists (select 1 from Assignments where question_id = (select question_id from Assignments where Id = @Id)
									and executor_organization_id = @transfer_to_organization_id and AssignmentResultsId = 3 and AssignmentResolutionsId = 3)
								begin
										update	[Assignments] set 
												 main_executor = @is_main_exec,
												[AssignmentResultsId] = 1,
												[assignment_state_id] = 1,
												[AssignmentResolutionsId] = null,
												[LogUpdated_Query] = N'cx_App_Que_Assignments_Update__Row581',
												close_date = null,
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id
											where Id = @New_Ass

								insert into dbo.AssignmentConsiderations
										(		[assignment_id]
											   ,[consideration_date]
											   ,[assignment_result_id]
											   ,[assignment_resolution_id]
											   ,[user_id]
											   ,[edit_date]
											   ,[user_edit_id]
											   ,turn_organization_id
											   ,[first_executor_organization_id]
											   ,[short_answer]
											   ,create_date)
										output inserted.Id into @output_con([Id])
										 select @New_Ass
											   ,getutcdate()
											   ,1	--Очікує прийому в роботу
											   ,null
											   ,@user_edit_id
											   ,getutcdate()
											   ,@user_edit_id
											   ,null
											--   ,first_executor_organization_id
											   ,@transfer_to_organization_id
											   ,[short_answer]
											   ,GETUTCDATE()
											from AssignmentConsiderations where Id = @current_consid
											
											update [Assignments] set main_executor = 0,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row639' where Id = @Id

											set @new_con = ( select top(1) Id from @output_con)
											update [Assignments] set current_assignment_consideration_id = @new_con where Id = @New_Ass
                                
								end
								else
								begin
										update [Assignments] set 
												main_executor = 1,
												[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row613',
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id 
											where Id = @New_Ass
										update [Assignments] set 
												main_executor = 0, 
												[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row646',
												edit_date = getutcdate(),
												user_edit_id = @user_edit_id 
											where question_id = @question_id and Id <> @New_Ass
								end
							end
						return;
			END -- 3\3
	END -- tt

	-- 6 Повернуто виконавцю	returnedToTheArtist
    -- 3 Перенаправлено за належністю	RedirectedByAffiliation
	if @result_id = 6 and @resolution_id = 3
	begin
			--set @transfer_to_organization_id = (select first_executor_organization_id from AssignmentConsiderations where Id = @current_consid)
			
			set @transfer_to_organization_id = (select executor_organization_id from Assignments where Id = @Id)

			update Assignments 
					set 
					 AssignmentResultsId = @result_id
					,AssignmentResolutionsId = @resolution_id
					,assignment_state_id = @ass_state_id -- 04_04
					,edit_date = GETUTCDATE()
					,user_edit_id = @user_edit_id
					,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row632'
					 where id = @Id

			update dbo.AssignmentConsiderations 
					set	 
					consideration_date = GETUTCDATE()
					,assignment_result_id = @result_id
					,assignment_resolution_id = @resolution_id
					,transfer_to_organization_id = @transfer_to_organization_id
					,edit_date = GETUTCDATE()
					,user_edit_id = @user_edit_id
					,[short_answer] = @short_answer
					 where Id = @current_consid 
			
			delete from @output_con
			insert into dbo.AssignmentConsiderations
				(	 [assignment_id]
					,[consideration_date]
					,[assignment_result_id]
					,[assignment_resolution_id]
					,[user_id]
					,[edit_date]
					,[user_edit_id]
					,[first_executor_organization_id]
					,create_date
					,transfer_date
					,[short_answer]
				)
				output inserted.Id into @output_con([Id])
				values
				(	@Id
					,GETUTCDATE()
					,@result_id
					,@resolution_id
					,@user_edit_id
					,GETUTCDATE()
					,@user_edit_id
					,@transfer_to_organization_id
					,GETUTCDATE()
					,GETUTCDATE()
					,@short_answer
				)

			set @new_con = (select top (1) Id from @output_con)
			update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id
-- 			execute define_status_Question @question_id
        -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
		return;
	end

	-- 1 Очікує прийому в роботу	WaitingForWork
    -- 3 Перенаправлено за належністю	RedirectedByAffiliation
	if @result_id = 1 and @resolution_id = 3
	begin

			update Assignments 
					set 
					 AssignmentResultsId = @result_id
					,AssignmentResolutionsId = @resolution_id
					,assignment_state_id = @ass_state_id -- 04_04
					,edit_date = GETUTCDATE()
					,user_edit_id = @user_edit_id
					,executor_organization_id = @transfer_to_organization_id
					,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row695'
					 where id = @Id

			update dbo.AssignmentConsiderations 
				set	
					 consideration_date = GETUTCDATE()
					,assignment_result_id = @result_id
					,assignment_resolution_id = @resolution_id
					,transfer_to_organization_id = @transfer_to_organization_id
					,edit_date = GETUTCDATE()
					,user_edit_id = @user_edit_id
					,[short_answer] = @short_answer
				 where Id = @current_consid 

			delete from @output_con;

			insert into dbo.AssignmentConsiderations
				(		[assignment_id]
					   ,[consideration_date]
					   ,[assignment_result_id]
					   ,[assignment_resolution_id]
					   ,[user_id]
					   ,[edit_date]
					   ,[user_edit_id]
					   ,turn_organization_id
					   ,[first_executor_organization_id]
					   ,[short_answer]
					   ,create_date)
				output inserted.Id into @output_con([Id])
				 select @id
					   ,getutcdate()
					   ,@result_id
					   ,@resolution_id
					   ,@user_edit_id
					   ,getutcdate()
					   ,@user_edit_id
					   ,null
					   ,@transfer_to_organization_id
					   ,@short_answer
					   ,GETUTCDATE()
					from AssignmentConsiderations where Id = @current_consid
			
			set @new_con = ( select top(1) Id from @output_con)
			update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id -- @ass_id
-- 			execute define_status_Question @question_id
        -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
		return;
	end

	-- 04_04_2019
	--Результат: 4 Виконано, резолюція – 4 Очікує підтвердження заявником
	--Результат: 7 Роз’яснено, резолюція – 5 Потребує перевірки куратором
	--Результат: 8 Не можливо виконати в даний період, резолюція – 12 Потребує фінансування/Включено в план-програму
	if (@result_id = 4 and @resolution_id = 4) or (@result_id = 7 and @resolution_id = 5) or (@result_id = 8 and @resolution_id = 12)
	begin
		update Assignments 
					set 
					 AssignmentResultsId = @result_id
					,AssignmentResolutionsId = @resolution_id
					,edit_date = GETUTCDATE()
					,user_edit_id = @user_edit_id
					--,executor_organization_id = @transfer_to_organization_id
					,assignment_state_id = @ass_state_id 
					,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row756'
					 where id = @Id

		update dbo.AssignmentConsiderations 
				set	
					 consideration_date = GETUTCDATE()
					,assignment_result_id = @result_id
					,assignment_resolution_id = @resolution_id
					--,transfer_to_organization_id = @transfer_to_organization_id
					,edit_date = GETUTCDATE()
					,user_edit_id = @user_edit_id
					,[short_answer] = @short_answer
				 where Id = @current_consid

				 
			INSERT INTO [dbo].[AssignmentRevisions]
						   ([assignment_consideration_іd]
						   ,[control_type_id]
						   ,[assignment_resolution_id]
						   ,[control_comment]
						--    ,[control_date]
						   ,[user_id]
						   ,[rework_counter]
						   ,[edit_date]
						   ,[user_edit_id]
						   
						   --,create_date
						   )
					 VALUES
						   (
						   @current_consid --@ass_cons_id
						   ,2  -- @control_type_id = Контроль, Продзвон, Контроль заявником
						   ,@resolution_id -- @assignment_resolution_id
						   ,@control_comment
						--    ,getutcdate() 
						   ,@user_edit_id --@user_id
						  -- ,@rework_counter_count
						   ,@rework_counter
						   ,getutcdate() --@edit_date
						   ,@user_edit_id
						   --,@create_date
						   ) 
-- 		execute define_status_Question @question_id
        -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
		return;
	end

	--Результат: 5 На доопрацювання,   резолюція – 8 Виконання не підтверджено завником
												-- 7 Спростовано куратором
	if @result_id = 5 and (@resolution_id = 8 or @resolution_id = 7)
	begin
					declare @rework_counter_count int
					
					if @rework_counter is not null or @rework_counter <> 0
					--if @result_id = 5
					begin
						set @rework_counter_count = @rework_counter + 1
					end
					else
					begin
						set @rework_counter_count = @rework_counter
					end

		UPDATE [dbo].[AssignmentRevisions]
			   SET [assignment_resolution_id] = @resolution_id
				  ,[control_comment] = @control_comment
				  ,[rework_counter] = @rework_counter_count
				  ,[edit_date] = getutcdate()
				  ,[user_edit_id] = @user_edit_id
				  ,control_date = getutcdate()
				  ,control_result_id = @result_id
			 WHERE [assignment_consideration_іd] = @ass_cons_id

		update Assignments 
					set 
					 AssignmentResultsId = @result_id
					,AssignmentResolutionsId = @resolution_id
					,edit_date = GETUTCDATE()
					,user_edit_id = @user_edit_id
					--,executor_organization_id = @transfer_to_organization_id
					,assignment_state_id = @ass_state_id 
					,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row837'
					 where id = @Id

		--update dbo.AssignmentConsiderations 
		--		set	
		--			 consideration_date = GETUTCDATE()
		--			,assignment_result_id = @result_id
		--			,assignment_resolution_id = @resolution_id
		--			,transfer_to_organization_id = @transfer_to_organization_id
		--			,edit_date = GETUTCDATE()
		--			,user_edit_id = @user_edit_id
		--			,[short_answer] = @short_answer
		--		 where Id = @current_consid

		    delete from @output_con;

			insert into dbo.AssignmentConsiderations
				(		[assignment_id]
					   ,[consideration_date]
					   ,[assignment_result_id]
					   ,[assignment_resolution_id]
					   ,[user_id]
					   ,[edit_date]
					   ,[user_edit_id]
					   ,turn_organization_id
					   ,[first_executor_organization_id]
					   ,[short_answer]
					   ,create_date)
				output inserted.Id into @output_con([Id])
				 select @Id
					   ,getutcdate()
					   ,@result_id
					   ,@resolution_id
					   ,@user_edit_id
					   ,getutcdate()
					   ,@user_edit_id
					   ,null
					   --,@transfer_to_organization_id
					   ,first_executor_organization_id
					   ,@short_answer
					   ,GETUTCDATE()
					from AssignmentConsiderations where Id = @current_consid
			
			set @new_con = ( select top(1) Id from @output_con)
			update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id
					
        -- execute define_status_Question @question_id
            -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
			return;
		end
		
		
	--Результат: 12 Фактично,   резолюція - 7 Спростовано куратором 8-Виконання не підтверджено завником
	if @result_id = 12 and (@resolution_id = 7 or @resolution_id = 8)
	begin
		UPDATE [dbo].[AssignmentRevisions]
			   SET [assignment_resolution_id] = @resolution_id
				  ,[control_comment] = @control_comment
				  ,[edit_date] = getutcdate()
				  ,[user_edit_id] = @user_edit_id
				  ,control_date = getutcdate()
				  ,control_result_id = @result_id
				  --,rework_counter = @rework_counter + 1
			 WHERE [assignment_consideration_іd] = @ass_cons_id

		update Assignments 
					set 
					 AssignmentResultsId = @result_id
					,AssignmentResolutionsId = @resolution_id
					,edit_date = GETUTCDATE()
					,user_edit_id = @user_edit_id
					--,executor_organization_id = @transfer_to_organization_id
					,assignment_state_id = @ass_state_id
					,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row907' 
					 where id = @Id

		    delete from @output_con;

			insert into dbo.AssignmentConsiderations
				(		[assignment_id]
					   ,[consideration_date]
					   ,[assignment_result_id]
					   ,[assignment_resolution_id]
					   ,[user_id]
					   ,[edit_date]
					   ,[user_edit_id]
					   ,turn_organization_id
					   ,[first_executor_organization_id]
					   ,[short_answer]
					   ,create_date)
				output inserted.Id into @output_con([Id])
				 select @Id
					   ,getutcdate()
					   ,@result_id
					   ,@resolution_id
					   ,@user_edit_id
					   ,getutcdate()
					   ,@user_edit_id
					   ,null
					   --,@transfer_to_organization_id
					   ,first_executor_organization_id
					   ,@short_answer
					   ,GETUTCDATE()
					from AssignmentConsiderations where Id = @current_consid
			
			set @new_con = ( select top(1) Id from @output_con)
			update [Assignments] set current_assignment_consideration_id = @new_con where Id = @Id
					
        -- execute define_status_Question @question_id
            -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
			return;
		end


	if  @ass_state_id = 5
		begin
		
				update AssignmentConsiderations 
	    		set 
	    			[edit_date] = getutcdate()
				   ,[user_edit_id] = @user_edit_id
				   ,[assignment_result_id] = @result_id
				   ,[assignment_resolution_id] = @resolution_id
				   ,short_answer = @short_answer
	    		where  Id = @current_consid
	    	
	    		update [Assignments] 
				set  AssignmentResultsId = @result_id
					,AssignmentResolutionsId = @resolution_id
				   ,[edit_date] = getutcdate()
				   ,[user_edit_id] = @user_edit_id
					,close_date = GETUTCDATE()
					,current_assignment_consideration_id = @current_consid
					,assignment_state_id = @ass_state_id
					,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row965'
				where Id = @Id
				
				if  exists (select 1 from AssignmentRevisions where assignment_consideration_іd = @current_consid)
				begin
					update AssignmentRevisions 
					set [assignment_resolution_id] = @resolution_id
						,organization_id = @transfer_to_organization_id
						,[control_comment] = @control_comment
						,[rework_counter] = @rework_counter_count
						,[edit_date] = getutcdate()
						,[user_edit_id] = @user_edit_id
						,control_result_id = @resolution_id
						,control_date = getutcdate()
					where assignment_consideration_іd = @current_consid
				end
				-- execute define_status_Question @question_id
             -- exec pr_chech_in_status_assignment @Id, @result_id, @resolution_id
		
		end

		update AssignmentConsiderations 
	    	set 
	    	    [edit_date] = getutcdate()
			   ,[user_edit_id] = @user_edit_id
			   ,[assignment_result_id] = @result_id
			   ,[assignment_resolution_id] = @resolution_id
			   ,short_answer = @short_answer
	    	where  Id = @current_consid
	    	
	    	update [Assignments] 
			set  AssignmentResultsId = @result_id
				,AssignmentResolutionsId = @resolution_id
			   ,[edit_date] = getutcdate()
			   ,[user_edit_id] = @user_edit_id
			   ,[LogUpdated_Query] = N'cx_App_Que_Assignments_Update_Row1000'
			  --  ,close_date = GETUTCDATE()
			where Id = @Id
			
			
    END --(F11)
	END
END