

if( select active from [Events] where Id = @Id) = 'false'
begin
	return
end
else
begin  
	DECLARE @table_id TABLE (id INT IDENTITY(1,1),	question_id INT,assignment_id INT,	consideration_id INT)

	INSERT INTO @table_id( question_id, assignment_id, consideration_id)
	SELECT
		q.Id
		, Assignments.Id
		, Assignments.current_assignment_consideration_id
	FROM [Events] AS e
		LEFT JOIN EventQuestionsTypes AS eqt ON eqt.event_id = e.Id
		LEFT JOIN [EventObjects] AS eo ON eo.event_id = e.Id
		LEFT JOIN Questions AS q ON q.question_type_id = eqt.question_type_id AND q.[object_id] = eo.[object_id]
		JOIN (select * from  Appeals where Appeals.receipt_source_id IN(1,8)) as ap on ap.Id = q.appeal_id
		LEFT JOIN Assignments ON Assignments.Id = q.last_assignment_for_execution_id
		LEFT JOIN Organizations ON Organizations.Id = Assignments.executor_organization_id
	WHERE e.Id = @Id
		AND q.registration_date >= e.registration_date
		AND eqt.[is_hard_connection] = 1
		AND Assignments.main_executor = 1
		AND Assignments.assignment_state_id <> 5

	UPDATE [dbo].[Events]
		SET   
			[real_end_date]= @real_end_date
			,[active]= N'false'
			,[user_id]= @user_id
			,[executor_comment]=@coment_executor
			WHERE Id = @Id

	UPDATE Assignments 
		SET assignment_state_id = 3 --OnCheck
			,user_edit_id = @user_id
			,[LogUpdated_Query] = N'ak_CloseEvent_ROW39'
			,edit_date = GETUTCDATE()
			,state_change_date = GETUTCDATE()
			,AssignmentResultsId = 4 -- Done
			,AssignmentResolutionsId = 4	 
		WHERE Id IN (SELECT assignment_id FROM @table_id)


	UPDATE AssignmentConsiderations
		SET user_edit_id = @user_id
			,edit_date = GETUTCDATE()
			,assignment_result_id = 4 -- Done
			,assignment_resolution_id = 4
			,short_answer =  @coment_executor
			,consideration_date = getutcdate()
		WHERE Id IN (SELECT consideration_id FROM @table_id)

	DECLARE @temp_id INT
	DECLARE @cons_id INT

	DECLARE cursor_in_up_Revision CURSOR 
	FOR
		SELECT Id, consideration_id	FROM @table_id
	OPEN cursor_in_up_Revision
	FETCH next FROM cursor_in_up_Revision  INTO @temp_id,  @cons_id
	WHILE @@fetch_status = 0
		BEGIN
			IF EXISTS (SELECT 1	FROM AssignmentRevisions ar	WHERE ar.assignment_consideration_іd = @cons_id )
			BEGIN
				UPDATE AssignmentRevisions
						SET control_type_id = 2
						,assignment_resolution_id = 4
						,control_result_id = NULL
						,control_date = NULL
						,user_edit_id = @user_id
						,edit_date = GETUTCDATE()
				WHERE assignment_consideration_іd = @cons_id
			END 
			ELSE
			BEGIN
				INSERT INTO AssignmentRevisions
				([assignment_consideration_іd]
				,[control_type_id]
				,[assignment_resolution_id]
				,[control_result_id]
				,[user_id]
				,[edit_date]
				,[user_edit_id])
				VALUES
				(@cons_id
						, 2
						, 4
						, NULL
						, @user_id
						, GETUTCDATE()
						, @user_id )
			END
		FETCH next FROM cursor_in_up_Revision  INTO @temp_id, @cons_id
	END
	CLOSE cursor_in_up_Revision
	DEALLOCATE cursor_in_up_Revision
	
end
