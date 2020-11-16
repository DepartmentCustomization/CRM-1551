 /*
 declare @appeal_id int = 6404197;
 declare @result int = 5;
 declare @user_id nvarchar(128)=N'тестт';
 declare @grade int = 5;
 declare @question_id int = null;
 declare @grade_comment nvarchar(128)=N'тестт';
*/

DECLARE @assignments_table TABLE (Id INT);


if @question_id  is NULL
begin
  INSERT INTO
    @assignments_table (Id)
  SELECT
    [Assignments].Id
  FROM
    dbo.[Appeals] [Appeals] 
    INNER JOIN [Questions] [Questions] ON [Appeals].Id = [Questions].appeal_id
    INNER JOIN [Assignments] [Assignments] ON [Questions].Id = [Assignments].question_id
  WHERE
    [Appeals].Id = @appeal_id 
end
else 
begin
  INSERT INTO
    @assignments_table (Id)
  SELECT
    [Assignments].Id
  FROM
    dbo.[Appeals] [Appeals] 
    INNER JOIN [Questions] [Questions] ON [Appeals].Id = [Questions].appeal_id
    INNER JOIN [Assignments] [Assignments] ON [Questions].Id = [Assignments].question_id
  WHERE
    [Questions].Id = @question_id ;
end;


  -- select * from @assignments_table
  -- таблица с нужными вопросами
DECLARE @questions_table TABLE (Id INT);

if @question_id  is NULL
begin
  INSERT INTO
  @questions_table (Id)
  SELECT
    [Questions].Id
  FROM
    [Appeals]
    INNER JOIN [Questions] ON [Appeals].Id = [Questions].appeal_id
  WHERE
    [Appeals].Id = @appeal_id
end
else 
begin
  INSERT INTO
  @questions_table (Id)
  SELECT
    [Questions].Id
  FROM
    [Appeals]
    INNER JOIN [Questions] ON [Appeals].Id = [Questions].appeal_id
  WHERE
    [Questions].Id = @question_id ;
end;




  DECLARE @output TABLE ([Id] INT);

  

  IF @result IN (4, 11) 
  BEGIN
  /**/
UPDATE
  [Assignments]
SET
  [AssignmentResolutionsId] = 9,
  [AssignmentResultsId] = 4,
  [assignment_state_id] = 5,
  [state_change_date] = GETUTCDATE(),
  [close_date] = GETUTCDATE(),
  [edit_date] = GETUTCDATE(),
  [user_edit_id] = @user_id
WHERE
  question_id IN (
    SELECT
      Id
    FROM
      @questions_table
  ) ;
  --question_id=@question_id
UPDATE
  dbo.[AssignmentRevisions] 
SET
  assignment_resolution_id = 9,
  [control_result_id] = 4,
  [control_date] = GETUTCDATE(),
  [edit_date] = GETUTCDATE(),
  [user_edit_id] = @user_id,
  [grade] = @grade,
  [grade_comment] = @grade_comment,
  [control_comment] = @grade_comment
WHERE
  assignment_consideration_іd IN (
    SELECT
      [AssignmentConsiderations].Id
    FROM
      dbo.[Assignments] [Assignments] 
      INNER JOIN dbo.[AssignmentConsiderations] [AssignmentConsiderations] ON [Assignments].current_assignment_consideration_id = [AssignmentConsiderations].Id
      INNER JOIN @questions_table qt ON [Assignments].question_id = qt.Id 
      --where [Assignments].question_id=@question_id
  ) ;
INSERT INTO
  dbo.[AssignmentRevisions] (
    [assignment_consideration_іd],
    [control_type_id],
    [assignment_resolution_id],
    [control_result_id],
    [organization_id],
    [control_comment],
    [control_date],
    [user_id],
    [grade],
    [grade_comment],
    [rework_counter],
    [missed_call_counter],
    [edit_date],
    [user_edit_id]
  )
SELECT
  [AssignmentConsiderations].Id --[assignment_consideration_іd]
,
  2 --[control_type_id]
,
  9 --[assignment_resolution_id]
,
  4 --[control_result_id]
,
  NULL --[organization_id]
,
  @grade_comment --[control_comment]
,
  getutcdate() --[control_date]
,
  @user_id --[user_id]
,
  @grade --[grade] 
,
  @grade_comment --[grade_comment]
,
  NULL --[rework_counter]
,
  NULL --[missed_call_counter]
,
  getutcdate() --[edit_date]
,
  @user_id --[user_edit_id]
FROM
  dbo.[AssignmentConsiderations] [AssignmentConsiderations]
  INNER JOIN [Assignments] [Assignments] ON [AssignmentConsiderations].Id = [Assignments].current_assignment_consideration_id
  LEFT JOIN [AssignmentRevisions] [AssignmentRevisions] ON [AssignmentRevisions].assignment_consideration_іd = [AssignmentConsiderations].Id
  INNER JOIN @questions_table qt ON [Assignments].question_id = qt.Id
WHERE
  --[Assignments].question_id=@question_id 
  [AssignmentRevisions].Id IS NULL ;
END 
IF @result IN (5) -- на доопрацюванні
BEGIN
DECLARE @lastAssignmentId INT = (SELECT TOP 1 last_assignment_for_execution_id FROM  dbo.[Questions] WHERE Id IN (SELECT Id FROM @questions_table));
DECLARE @question_state INT;  
SELECT 
	@question_state = q.[question_state_id]
FROM dbo.[Questions] q 
INNER JOIN dbo.[Assignments] ass ON ass.Id = q.[last_assignment_for_execution_id]
WHERE ass.Id = @lastAssignmentId;
								
	IF (SELECT [assignment_state_id] FROM dbo.[Assignments] WHERE Id = @lastAssignmentId) = 5
	AND @question_state = 5
	BEGIN
		RAISERROR(N'Помилка! Дане звернення неможливо відправити на доопрацювання', 16, 1);
		RETURN;
	END
	 
UPDATE
  [AssignmentRevisions]
SET
  assignment_resolution_id = 8,
  [control_result_id] = 5,
  [control_date] = GETUTCDATE(),
  [rework_counter] = CASE
    WHEN [rework_counter] IS NULL THEN 1
    ELSE [rework_counter] + 1
  END,
  [edit_date] = GETUTCDATE(),
  [user_edit_id] = @user_id,
  [grade] = @grade,
  [grade_comment] = @grade_comment,
  [control_comment] = @grade_comment
WHERE
  assignment_consideration_іd = (
    SELECT
      cons.Id
    FROM
      dbo.[AssignmentConsiderations] cons
	  INNER JOIN dbo.[Assignments] ass ON ass.current_assignment_consideration_id = cons.Id
      WHERE assignment_id = @lastAssignmentId);
  
INSERT INTO
  [AssignmentConsiderations] (
    [assignment_id],
    [consideration_date],
    [assignment_result_id],
    [first_executor_organization_id],
    [user_id],
    [edit_date],
    [user_edit_id]
  ) output inserted.Id INTO @output([Id])
SELECT
  [Assignments].Id --[assignment_id] 
,
  getdate() --[consideration_date] 
,
  5 --[assignment_result_id] 
,
  [executor_organization_id] --[first_executor_organization_id] узнать
,
  @user_id --[user_id] 
,
  getutcdate() --[edit_date] 
,
  @user_id --[user_edit_id]
FROM
  dbo.[Assignments] [Assignments]
  WHERE Id = @lastAssignmentId;

UPDATE
  [Assignments]
SET
  [AssignmentResolutionsId] = 8,
  [AssignmentResultsId] = 5,
  [assignment_state_id] = (
    SELECT
      DISTINCT new_assignment_state_id
    FROM
      dbo.[TransitionAssignmentStates] 
    WHERE
      new_assignment_resolution_id = 8
      AND new_assignment_result_id = 5
  ),
  [state_change_date] = GETUTCDATE(),
  [edit_date] = GETUTCDATE(),
  [user_edit_id] = @user_id,
  [current_assignment_consideration_id] = (
    SELECT
      TOP 1 Id
    FROM
      @output
  ),
  LogUpdated_Query = N'api_AssignmentRevisions_Update_Row235'
WHERE Id = @lastAssignmentId;
END
SELECT
  N'Ok' AS [Result] ;