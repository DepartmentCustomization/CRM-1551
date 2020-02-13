
/*CRM1551-606  - Картка оператора, логіка при висталенні результату доручення*/
-- declare @AssignmentResultsId int = 4, @question_id int = 6695652, @UserId nvarchar(128) = N'Admin', @Question_Prew_Rating int = 1
-- ,@Question_Prew_Comment nvarchar(100) = N'Test'


-----------------------------


DECLARE @NEW_AssignmentStateId INT,
		@NEW_AssignmentResultsId INT,
		@NEW_AssignmentResolutionId INT;

/*1. При виставленні результату 4 (Виконано) потрібно*/
IF @AssignmentResultsId = 4	/*Виконано*/
BEGIN
	/*1.1 Закривати всі доручення питання, крім доручень, що вже знаходяться в стані Закрито (зараз закривається тільки головне).*/
	SET @NEW_AssignmentStateId = 5;
	SET @NEW_AssignmentResultsId = 4;
	SET	@NEW_AssignmentResolutionId = 9;

	/*1.3 Якщо в якомусь доручення немає AssignmentRevisions, то створити його та проапдейтити згідно даних вище (ревізіон перевіряється через curent_AssignmentConsiderations в асигменті)*/
	INSERT INTO [dbo].[AssignmentRevisions] 
	    			([assignment_consideration_іd]
	    			,[control_type_id]
	    			,[assignment_resolution_id]
	    			,[control_result_id]
					,[control_comment]
					,[control_date]
					,[grade]
	    			,[grade_comment]
					,[edit_date]
					,[user_id]
	    			,[user_edit_id])
	 SELECT ac.Id [assignment_consideration_іd],
	    			   2 [control_type_id],
	    			   @NEW_AssignmentResolutionId [assignment_resolution_id],
	    			   @NEW_AssignmentResultsId [control_result_id],
					   @Question_Prew_Comment [control_comment],
					   getutcdate() [control_date],
					   @Question_Prew_Rating [grade],
	    			   @Question_Prew_Comment [grade_comment],
					   getutcdate() [edit_date],
					   @UserId [user_id],
					   @UserId [user_edit_id]	   
	FROM [dbo].[AssignmentConsiderations] ac
	WHERE ac.Id NOT IN (
						SELECT assignment_consideration_іd 
						FROM [dbo].[AssignmentRevisions]
						WHERE assignment_consideration_іd IN (
							SELECT current_assignment_consideration_id 
							FROM [dbo].[Assignments] 
							WHERE question_id = @question_id 
							AND assignment_state_id != 5
							AND current_assignment_consideration_id IS NOT NULL
						)
	) AND ac.Id IN (
							SELECT current_assignment_consideration_id 
							FROM [dbo].[Assignments] 
							WHERE question_id = @question_id 
							AND assignment_state_id != 5
							AND current_assignment_consideration_id IS NOT NULL
						);

   /*1.2 Вносяться зміни в записи таблиць Assignment та AssignmentRevisions:*/
   /*1.2.2 Таблиця AssignmentRevisions всіх curent_[AssignmentConsiderations] всіх доручень даного питання*/
    UPDATE dbo.AssignmentRevisions SET
					 [control_type_id] = 2
	    			,[assignment_resolution_id] = @NEW_AssignmentResolutionId
	    			,[control_result_id] = @NEW_AssignmentResultsId
					,[control_comment] = CASE WHEN LEN(ISNULL(@Question_Prew_Comment,N'')) > 0 THEN  @Question_Prew_Comment  ELSE [control_comment] END
					,[control_date] = getutcdate()
					,[grade] = @Question_Prew_Rating
	    			,[grade_comment] = CASE WHEN LEN(ISNULL(@Question_Prew_Comment,N'')) > 0 THEN  @Question_Prew_Comment  ELSE [control_comment] END
					,[edit_date] = getutcdate()
	    			,[user_edit_id] = @UserId
	WHERE Id IN (
					SELECT Id 
					FROM [dbo].[AssignmentRevisions]
					WHERE assignment_consideration_іd IN (
						SELECT current_assignment_consideration_id 
						FROM [dbo].[Assignments] 
						WHERE question_id = @question_id 
						AND assignment_state_id != 5
						AND current_assignment_consideration_id IS NOT NULL
					)
				);

	
	/*1.2.1 Таблиця Assignment:*/
	UPDATE [dbo].[Assignments] SET 
	    		 [AssignmentResultsId] = @NEW_AssignmentResultsId
	    		,[AssignmentResolutionsId] = @NEW_AssignmentResolutionId
	    		,[assignment_state_id] = @NEW_AssignmentStateId
	    		,[state_change_date] = GETUTCDATE()
				,[close_date] = GETUTCDATE()
	    		,[edit_date] = GETUTCDATE()
	    		,[user_edit_id] = @UserId
				,LogUpdated_Query = N'CloseAssignments_UpdateRow108'
	WHERE Id IN (
							SELECT Id 
							FROM [dbo].[Assignments] 
							WHERE question_id = @question_id 
							AND assignment_state_id != 5
							AND current_assignment_consideration_id IS NOT NULL
						);
END



/*2. При виставленні результату 11 (Самостійно) потрібно: */
IF @AssignmentResultsId = 11 /*Самостійно*/
BEGIN
	/*2.1 Закривати всі доручення питання, крім доручень, що вже знаїходяться в стані Закрито (зараз закривається тільки головне).*/
	SET @NEW_AssignmentStateId = 5;
	SET @NEW_AssignmentResultsId = 11;
	SET	@NEW_AssignmentResolutionId = 10;

	/*2.3 Якщо в якомусь дорученні немає AssignmentRevisions, то створити його та проапдейтити згідно даних вище (ревізіон перевіряється через curent_AssignmentConsiderations в асигменті)*/
	INSERT INTO [dbo].[AssignmentRevisions] 
	    			([assignment_consideration_іd]
	    			,[control_type_id]
	    			,[assignment_resolution_id]
	    			,[control_result_id]
					,[control_comment]
					,[control_date]
					,[grade]
	    			,[grade_comment]
					,[edit_date]
					,[user_id]
	    			,[user_edit_id])
	 SELECT ac.Id [assignment_consideration_іd],
	    			   2 [control_type_id],
	    			   @NEW_AssignmentResolutionId [assignment_resolution_id],
	    			   @NEW_AssignmentResultsId [control_result_id],
					   @Question_Prew_Comment [control_comment],
					   getutcdate() [control_date],
					   NULL [grade],
	    			   @Question_Prew_Comment [grade_comment],
					   getutcdate() [edit_date],
					   @UserId [user_id],
					   @UserId [user_edit_id]	   
	FROM [dbo].[AssignmentConsiderations] ac
	WHERE ac.Id NOT IN (
						SELECT assignment_consideration_іd 
						FROM [dbo].[AssignmentRevisions]
						WHERE assignment_consideration_іd IN (
							SELECT current_assignment_consideration_id 
							FROM [dbo].[Assignments] 
							WHERE question_id = @question_id 
							AND assignment_state_id != 5
							AND current_assignment_consideration_id IS NOT NULL
						)
	) AND ac.Id IN (
							SELECT current_assignment_consideration_id 
							FROM [dbo].[Assignments] 
							WHERE question_id = @question_id 
							AND assignment_state_id != 5
							AND current_assignment_consideration_id IS NOT NULL
						);

   /*2.2 Вносяться зміни в записи таблиць Assignment та AssignmentRevisions:*/
   /*2.2.2 Таблиця AssignmentRevisions всіх curent_[AssignmentConsiderations] всіх доручень даного питання*/
    UPDATE dbo.AssignmentRevisions SET
					 [control_type_id] = 2
	    			,[assignment_resolution_id] = @NEW_AssignmentResolutionId
	    			,[control_result_id] = @NEW_AssignmentResultsId
					,[control_comment] = CASE WHEN LEN(ISNULL(@Question_Prew_Comment,N'')) > 0 THEN  @Question_Prew_Comment  ELSE [control_comment] END
					,[control_date] = getutcdate()
					,[grade] = NULL
	    			,[grade_comment] = CASE WHEN LEN(ISNULL(@Question_Prew_Comment,N'')) > 0 THEN  @Question_Prew_Comment  ELSE [control_comment] END
					,[edit_date] = getutcdate()
	    			,[user_edit_id] = @UserId
	WHERE Id IN (
					SELECT Id 
					FROM [dbo].[AssignmentRevisions]
					WHERE assignment_consideration_іd IN (
						SELECT current_assignment_consideration_id 
						FROM [dbo].[Assignments] 
						WHERE question_id = @question_id 
						AND assignment_state_id != 5
						AND current_assignment_consideration_id IS NOT NULL
					)
				);

	
	/*2.2.1 Таблиця Assignment:*/
	UPDATE [dbo].[Assignments] SET 
	    		 [AssignmentResultsId] = @NEW_AssignmentResultsId
	    		,[AssignmentResolutionsId] = @NEW_AssignmentResolutionId
	    		,[assignment_state_id] = @NEW_AssignmentStateId
	    		,[state_change_date] = GETUTCDATE()
				,[close_date] = GETUTCDATE()
	    		,[edit_date] = GETUTCDATE()
	    		,[user_edit_id] = @UserId
				,LogUpdated_Query = N'CloseAssignments_UpdateRow201'
	WHERE Id IN (
							SELECT Id 
							FROM [dbo].[Assignments] 
							WHERE question_id = @question_id 
							AND assignment_state_id != 5
							AND current_assignment_consideration_id IS NOT NULL
						);
END



/*3. При виставленні результату 14 (Відмінено)*/
IF @AssignmentResultsId = 14 /*Відмінено*/
BEGIN
	/*3.1 Закривати всі доручення питання, крім доручень, що вже знаїходяться в стані Закрито (зараз закривається тільки головне).*/
	SET @NEW_AssignmentStateId = 5;
	SET @NEW_AssignmentResultsId = 14;
	SET	@NEW_AssignmentResolutionId = 15;

	/*3.3 Якщо в якомусь доручення немає AssignmentRevisions, то створити його та проапдейтити згідно даних вище (ревізіон перевіряється через curent_AssignmentConsiderations в асигменті)*/
	INSERT INTO [dbo].[AssignmentRevisions] 
	    			([assignment_consideration_іd]
	    			,[control_type_id]
	    			,[assignment_resolution_id]
	    			,[control_result_id]
					,[control_comment]
					,[control_date]
					,[grade]
	    			,[grade_comment]
					,[edit_date]
					,[user_id]
	    			,[user_edit_id])
	 SELECT ac.Id [assignment_consideration_іd],
	    			   2 [control_type_id],
	    			   @NEW_AssignmentResolutionId [assignment_resolution_id],
	    			   @NEW_AssignmentResultsId [control_result_id],
					   @Question_Prew_Comment [control_comment],
					   getutcdate() [control_date],
					   NULL [grade],
	    			   @Question_Prew_Comment [grade_comment],
					   getutcdate() [edit_date],
					   @UserId [user_id],
					   @UserId [user_edit_id]	   
	FROM [dbo].[AssignmentConsiderations] ac
	WHERE ac.Id NOT IN (
						SELECT assignment_consideration_іd 
						FROM [dbo].[AssignmentRevisions]
						WHERE assignment_consideration_іd IN (
							SELECT current_assignment_consideration_id 
							FROM [dbo].[Assignments] 
							WHERE question_id = @question_id 
							AND assignment_state_id != 5
							AND current_assignment_consideration_id IS NOT NULL
						)
	) AND ac.Id IN (
							SELECT current_assignment_consideration_id 
							FROM [dbo].[Assignments] 
							WHERE question_id = @question_id 
							AND assignment_state_id != 5
							AND current_assignment_consideration_id IS NOT NULL
						);

   /*3.2 Вносяться зміни в записи таблиць Assignment та AssignmentRevisions:*/
   /*3.2.2 Таблиця AssignmentRevisions всіх curent_[AssignmentConsiderations] всіх доручень даного питання*/
    UPDATE dbo.AssignmentRevisions SET
					 [control_type_id] = 2
	    			,[assignment_resolution_id] = @NEW_AssignmentResolutionId
	    			,[control_result_id] = @NEW_AssignmentResultsId
					,[control_comment] = CASE WHEN LEN(ISNULL(@Question_Prew_Comment,N'')) > 0 THEN  @Question_Prew_Comment  ELSE [control_comment] END
					,[control_date] = getutcdate()
					,[grade] = NULL
	    			,[grade_comment] = CASE WHEN LEN(ISNULL(@Question_Prew_Comment,N'')) > 0 THEN  @Question_Prew_Comment  ELSE [control_comment] END
					,[edit_date] = getutcdate()
	    			,[user_edit_id] = @UserId
	WHERE Id IN (
					SELECT Id 
					FROM [dbo].[AssignmentRevisions]
					WHERE assignment_consideration_іd IN (
						SELECT current_assignment_consideration_id 
						FROM [dbo].[Assignments] 
						WHERE question_id = @question_id 
						AND assignment_state_id != 5
						AND current_assignment_consideration_id IS NOT NULL
					)
				);

	
	/*3.2.1 Таблиця Assignment:*/
	UPDATE [dbo].[Assignments] SET 
	    		 [AssignmentResultsId] = @NEW_AssignmentResultsId
	    		,[AssignmentResolutionsId] = @NEW_AssignmentResolutionId
	    		,[assignment_state_id] = @NEW_AssignmentStateId
	    		,[state_change_date] = GETUTCDATE()
				,[close_date] = GETUTCDATE()
	    		,[edit_date] = GETUTCDATE()
	    		,[user_edit_id] = @UserId
				,LogUpdated_Query = N'CloseAssignments_UpdateRow294'
	WHERE Id IN (
							SELECT Id 
							FROM [dbo].[Assignments] 
							WHERE question_id = @question_id 
							AND assignment_state_id != 5
							AND current_assignment_consideration_id IS NOT NULL
						);
END


/*4. При виставленні результату 5 (На доопрацювання)*/
IF @AssignmentResultsId = 5 /*На доопрацювання*/
BEGIN
	/*4.1 Працюємо тільки з тим дорученням питання, що знаходиться на перевірці, інші доручення питання не чіпаються.
	  4.2. Зараз питання та доручення переходить в стан 5 (це не правильно) стан має бути 4, результат 5, резолюція - 8 (дивимося по таблиці TransitionAssignmentStates) . 
	  Шукаємо new_ass_results = 5 дивимося для яких попередніх станів асигмента він підходить, але обновляємо стан доручення на 4, результат 5, резолюція  - 8. 
	  Тут працюємо тільки з ласт_асигмент.*/

	SET @NEW_AssignmentStateId = 4;
	SET @NEW_AssignmentResultsId = 5;
	SET	@NEW_AssignmentResolutionId = 8;

	DECLARE @assignment_id INT = (SELECT TOP 1  [last_assignment_for_execution_id] FROM [dbo].[Questions] WHERE Id = @question_id);
	DECLARE @assignmentConsideration_id INT = (SELECT TOP 1 current_assignment_consideration_id FROM dbo.Assignments WHERE Id = @assignment_id);
	DECLARE @assignmentRevision_id INT = (SELECT TOP 1  Id FROM dbo.AssignmentRevisions WHERE assignment_consideration_іd = @assignmentConsideration_id);
	DECLARE @first_executor_organization_id NVARCHAR(100) = (SELECT TOP 1  executor_organization_id FROM dbo.Assignments WHERE Id = @assignment_id);

	IF (SELECT COUNT(1) FROM [dbo].[Assignments] WHERE Id = @assignment_id AND assignment_state_id = 3) > 0
		AND (SELECT COUNT(1)
			 FROM [dbo].[Assignments] a
			 INNER JOIN [dbo].[TransitionAssignmentStates] tas ON tas.old_assignment_result_id = a.AssignmentResultsId
			 													AND tas.old_assignment_resolution_id = a.AssignmentResolutionsId
			 													AND tas.new_assignment_result_id = 5
			 WHERE a.Id = @assignment_id) > 0
	BEGIN
		/*4. 3. 1 Апдейтимо AssignmentRevisions */
		UPDATE dbo.AssignmentRevisions SET
		    			 [assignment_resolution_id] = @NEW_AssignmentResolutionId
		    			,[control_result_id] = @NEW_AssignmentResultsId
						,[control_comment] = CASE WHEN LEN(ISNULL(@Question_Prew_Comment,N'')) > 0 THEN  @Question_Prew_Comment  ELSE [control_comment] END
						,[control_date] = getutcdate()
						,[rework_counter] = isnull([rework_counter],0)+1
						,[edit_date] = getutcdate()
		    			,[user_edit_id] = @UserId
		WHERE Id IN (
						SELECT Id 
						FROM [dbo].[AssignmentRevisions]
						WHERE assignment_consideration_іd IN (
							SELECT current_assignment_consideration_id 
							FROM [dbo].[Assignments] 
							WHERE Id = @assignment_id
							AND assignment_state_id = 3
						)
				);

	
		/*4.3.2 Формується новий запис в таблицю AssignmentConsideretion - зараз працює ок.*/
		DECLARE @output_con TABLE (Id INT);
		INSERT INTO [dbo].[AssignmentConsiderations] ([assignment_id]
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
		OUTPUT inserted.Id INTO @output_con([Id])
		SELECT @assignment_id [assignment_id],
			   GETUTCDATE() [consideration_date],
			   @NEW_AssignmentResultsId [assignment_result_id],
			   @NEW_AssignmentResolutionId [assignment_resolution_id],
			   @first_executor_organization_id [first_executor_organization_id],
			   NULL [transfer_to_organization_id],
			   NULL [turn_organization_id],
			   NULL [short_answer],
			   @UserId [user_id],
			   GETUTCDATE() [edit_date],
			   @UserId [user_edit_id],
			   NULL [counter],
			   GETUTCDATE() [create_date],
			   NULL [transfer_date];
			
		DECLARE @new_con INT = (SELECT TOP (1) Id FROM @output_con);


		/*4.3.3 Зміни в Таблицю Assignment*/
		/*4.3.4  записуємо в Таблицю Assignment нове значення current_assignment_consideretion_id.*/
		UPDATE [dbo].[Assignments] SET 
		    		 [AssignmentResultsId] = @NEW_AssignmentResultsId
		    		,[AssignmentResolutionsId] = @NEW_AssignmentResolutionId
		    		,[assignment_state_id] = @NEW_AssignmentStateId
					,[current_assignment_consideration_id] = @new_con
		    		,[state_change_date] = GETUTCDATE()
					,[close_date] = GETUTCDATE()
		    		,[edit_date] = GETUTCDATE()
		    		,[user_edit_id] = @UserId
					,LogUpdated_Query = N'CloseAssignments_UpdateRow395'
		WHERE Id = @assignment_id;
	END
END



SELECT 'OK' [TextRes];
