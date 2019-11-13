
-- DECLARE @Id INT = 5663611

DECLARE @table_id TABLE (id INT IDENTITY(1,1),
	question_id INT,
	assignment_id INT,
	consideration_id INT)

INSERT INTO @table_id
	( question_id, assignment_id, consideration_id)
SELECT
	q.Id
		, Assignments.Id
		, Assignments.current_assignment_consideration_id
FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] AS gl
	JOIN dbo.Event_Class AS es ON es.name = gl.claims_type
	JOIN dbo.EventClass_QuestionType AS eq ON eq.event_class_id = es.id
	JOIN dbo.QuestionTypes qt ON qt.Id = eq.question_type_id

	JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] AS oc ON oc.claims_number_id = gl.claim_number
	JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] gh ON gh.gorodok_houses_id = oc.object_id
	JOIN [CRM_1551_Analitics].[dbo].[Objects] AS o ON o.Id = gh.[1551_houses_id]

	LEFT JOIN Questions AS q ON q.question_type_id = qt.Id AND q.[object_id] = o.id
	LEFT JOIN Assignments ON Assignments.Id = q.last_assignment_for_execution_id
	LEFT JOIN Organizations ON Organizations.Id = Assignments.executor_organization_id
WHERE gl.claim_number = @Id
	AND CONVERT(DATETIME, CONVERT(DATETIMEOFFSET(4),q.registration_date) AT TIME ZONE 'FLE Standard Time') >= gl.registration_date
	AND eq.[is_hard_connection] = 1
	AND Assignments.main_executor = 1
	AND Assignments.assignment_state_id <> 5


UPDATE Assignments 
		SET assignment_state_id = 3 --OnCheck
			,user_edit_id = @user_id
			,[LogUpdated_Query] = N'CloseQuestion_GlobGor_ROW37'
			,edit_date = GETUTCDATE()
			,state_change_date = GETUTCDATE()
			,AssignmentResultsId = 4 -- Done
			,AssignmentResolutionsId = 4	 
		WHERE Id IN (SELECT assignment_id
FROM @table_id)


UPDATE AssignmentConsiderations
		SET user_edit_id = @user_id
			,edit_date = GETUTCDATE()
			,assignment_result_id = 4 -- Done
			,assignment_resolution_id = 4
			,short_answer =  @coment_executor
			,consideration_date = getutcdate()
		WHERE Id IN (SELECT consideration_id
FROM @table_id)

DECLARE @temp_id INT
DECLARE @cons_id INT

DECLARE cursor_in_up_Revision CURSOR 
	FOR
		SELECT Id, consideration_id
FROM @table_id
OPEN cursor_in_up_Revision
FETCH next FROM cursor_in_up_Revision  INTO @temp_id,  @cons_id
WHILE @@fetch_status = 0
		BEGIN
	IF EXISTS (SELECT 1
	FROM AssignmentRevisions ar
	WHERE ar.assignment_consideration_іd = @cons_id )
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

