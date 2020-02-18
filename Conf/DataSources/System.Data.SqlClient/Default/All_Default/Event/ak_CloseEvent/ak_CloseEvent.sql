

IF (SELECT
			active
		FROM [dbo].[Events]
		WHERE id = @Id)
	= 'false'
BEGIN
	RETURN;
END
ELSE
BEGIN
	DECLARE @table_id TABLE (
		id INT IDENTITY (1, 1)
	   ,question_id INT
	   ,assignment_id INT
	   ,consideration_id INT
	)

	INSERT INTO @table_id (question_id, assignment_id, consideration_id)
		/*SELECT
			q.id
		   ,Assignments.id
		   ,Assignments.current_assignment_consideration_id
		FROM [dbo].[Events] AS e
		LEFT JOIN [dbo].EventQuestionsTypes AS eqt
			ON eqt.event_id = e.id
		LEFT JOIN [dbo].[EventObjects] AS eo
			ON eo.event_id = e.id
		LEFT JOIN [dbo].Questions AS q
			ON q.question_type_id = eqt.question_type_id
				AND q.[object_id] = eo.[object_id]
		JOIN (SELECT
				*
			FROM [dbo].Appeals
			WHERE Appeals.receipt_source_id IN (1, 8)) AS ap
			ON ap.id = q.appeal_id
		LEFT JOIN [dbo].Assignments
			ON Assignments.id = q.last_assignment_for_execution_id
		LEFT JOIN [dbo].Organizations
			ON Organizations.id = Assignments.executor_organization_id
		WHERE e.id = @Id
		AND q.registration_date >= e.registration_date
		AND eqt.[is_hard_connection] = 1
		AND Assignments.main_executor = 1
		--AND Assignments.assignment_state_id <> 5;
		AND NOT (Assignments.assignment_state_id = 5 AND Assignments.AssignmentResultsId=3 AND Assignments.AssignmentResolutionsId=3);
		*/
		SELECT q.Id, a.Id, a.current_assignment_consideration_id
		FROM [dbo].[Events] e
		INNER JOIN [dbo].Questions q ON e.Id=q.event_id
		INNER JOIN [dbo].Assignments a ON a.question_id=q.Id
		WHERE e.Id = @Id
		AND NOT (a.assignment_state_id=5 AND a.AssignmentResultsId IN (3,4) AND a.AssignmentResolutionsId IN (3,9));

	UPDATE [dbo].[Events]
	SET [real_end_date] = @real_end_date
	   ,[active] = N'false'
	   ,[user_id] = @user_id
	   ,[executor_comment] = @coment_executor
	WHERE id = @Id;

	UPDATE [dbo].Assignments
	SET assignment_state_id = 3 --OnCheck
	   ,user_edit_id = @user_id
	   ,[LogUpdated_Query] = N'ak_CloseEvent_ROW39'
	   ,edit_date = GETUTCDATE()
	   ,state_change_date = GETUTCDATE()
	   ,AssignmentResultsId = 4 -- Done
	   ,AssignmentResolutionsId = 4
	WHERE id IN (SELECT
			assignment_id
		FROM @table_id);


	UPDATE [dbo].AssignmentConsiderations
	SET user_edit_id = @user_id
	   ,edit_date = GETUTCDATE()
	   ,assignment_result_id = 4 -- Done
	   ,assignment_resolution_id = 4
	   ,short_answer = @coment_executor
	   ,consideration_date = GETUTCDATE()
	WHERE id IN (SELECT
			consideration_id
		FROM @table_id);

	DECLARE @temp_id INT;
	DECLARE @cons_id INT;

	DECLARE cursor_in_up_Revision CURSOR FOR SELECT
		id
	   ,consideration_id
	FROM @table_id
	OPEN cursor_in_up_Revision
	FETCH NEXT FROM cursor_in_up_Revision INTO @temp_id, @cons_id
	WHILE @@fetch_status = 0
	BEGIN
	IF EXISTS (SELECT
				1
			FROM [dbo].AssignmentRevisions ar
			WHERE ar.assignment_consideration_іd = @cons_id)
	BEGIN
		UPDATE [dbo].AssignmentRevisions
		SET control_type_id = 2
		   ,assignment_resolution_id = 4
		   ,control_result_id = NULL
		   ,control_date = NULL
		   ,user_edit_id = @user_id
		   ,edit_date = GETUTCDATE()
		WHERE assignment_consideration_іd = @cons_id;
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].AssignmentRevisions ([assignment_consideration_іd]
		, [control_type_id]
		, [assignment_resolution_id]
		, [control_result_id]
		, [user_id]
		, [edit_date]
		, [user_edit_id])
			VALUES (@cons_id, 2, 4, NULL, @user_id, GETUTCDATE(), @user_id);
	END
	FETCH NEXT FROM cursor_in_up_Revision INTO @temp_id, @cons_id
	END
	CLOSE cursor_in_up_Revision
	DEALLOCATE cursor_in_up_Revision

END
