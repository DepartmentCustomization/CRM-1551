-- declare @Question_ControlDate datetime = @control_date
DECLARE @ass_for_check INT = (
	SELECT
		last_assignment_for_execution_id
	FROM
		dbo.Questions
	WHERE
		Id = @Id
) ;
UPDATE
	[dbo].[Questions]
SET
	[control_date] = @control_date,
	[question_type_id] = @question_type_id,
	[edit_date] = getutcdate(),
	[user_edit_id] = @user_edit_id,
	question_content = @question_content,
	object_id = @object_id,
	organization_id = @organization_id,
	[answer_form_id] = @answer_type_id,
	[answer_phone] = @answer_phone,
	[answer_post] = @answer_post,
	[answer_mail] = @answer_mail
WHERE
	Id = @Id ;
	--  execute define_status_Question  @Id
	IF @ass_for_check = (
		SELECT
			last_assignment_for_execution_id
		FROM
			dbo.Questions
		WHERE
			Id = @Id
	) 
	BEGIN 
	IF @perfom_id <> (
		SELECT
			executor_organization_id
		FROM
			dbo.Assignments
		WHERE
			Id = (
				SELECT
					last_assignment_for_execution_id
				FROM
					dbo.Questions
				WHERE
					Id = @Id
			)
	) 
BEGIN 
 DECLARE @output_con TABLE (Id INT);

DECLARE @assigment INT;

SELECT
	@assigment = Id
FROM
	dbo.Assignments
WHERE
	Id = (
		SELECT
			last_assignment_for_execution_id
		FROM
			dbo.Questions
		WHERE
			Id = @Id
	) ;
UPDATE
	[dbo].[Assignments]
SET
	[executor_organization_id] = @perfom_id, -- новый исполнитель на кого переопределили
	--,[execution_date]= @execution_date  
	executor_person_id = NULL,
	organization_id = @perfom_id,
	[edit_date] = getutcdate(),
	[user_edit_id] = @user_edit_id,
	LogUpdated_Query = N'cx_Appeal_Questions_Update_ROW33'
WHERE
	Id = @assigment ;

UPDATE
	dbo.AssignmentConsiderations
SET
	[edit_date] = getutcdate(),
	[user_edit_id] = @user_edit_id,
	[consideration_date] = getutcdate()
WHERE
	Id = (
		SELECT
			current_assignment_consideration_id
		FROM
			dbo.Assignments
		WHERE
			Id = (
				SELECT
					last_assignment_for_execution_id
				FROM
					dbo.Questions
				WHERE
					Id = @Id
			)
	) ;
INSERT INTO
	dbo.AssignmentConsiderations (
		[assignment_id],
		[consideration_date],
		[assignment_result_id],
		[assignment_resolution_id],
		[user_id],
		[edit_date],
		[user_edit_id],
		[first_executor_organization_id],
		create_date,
		transfer_date
	) output inserted.Id INTO @output_con([Id])
VALUES
(
		@assigment,
		GETUTCDATE(),
		1,
		NULL,
		@user_edit_id,
		GETUTCDATE(),
		@user_edit_id,
		@perfom_id -- новый исполнитель на кого переопределили
,
		GETUTCDATE(),
		GETUTCDATE()
	) ;
DECLARE @new_con INT ;

SET
	@new_con = (
		SELECT
			TOP (1) Id
		FROM
			@output_con
	) ;

UPDATE
	dbo.[Assignments]
SET
	current_assignment_consideration_id = @new_con,
	[edit_date] = getutcdate()
WHERE
	Id = @assigment ;
END
END