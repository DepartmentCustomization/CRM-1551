--   DECLARE @question_id INT = 96695972;
--   DECLARE @event_id INT = 241;
--   DECLARE @user_id NVARCHAR(128) = N'016cca2b-dcd8-437e-8754-d4ff679ef6b9';

DECLARE @Archive NVARCHAR(400) = '['+(SELECT TOP 1 [IP]+'].['+[DatabaseName]+'].' FROM [dbo].[SetingConnetDatabase] WHERE Code = N'Archive');
DECLARE @isHere BIT = IIF( (SELECT COUNT(1) FROM dbo.[Questions] WHERE Id = @question_id) = 0, 0, 1);

IF (@isHere = 1) 
BEGIN
	DECLARE @isCurrent BIT = (SELECT 
									CASE	
										WHEN ISNULL(event_id,0) <> @event_id 
										THEN 0 
										ELSE 1 
										END
							 FROM [dbo].[Questions] WHERE Id = @question_id
							 ); 
	
	IF(@isCurrent = 0)
	BEGIN
	
	UPDATE
		[dbo].[Questions]
	SET
		event_id = @event_id,
		[edit_date] = GETUTCDATE(),
		[user_edit_id] = @user_id
	WHERE
		Id = @question_id
		AND [registration_date] >= (
			SELECT
				[start_date]
			FROM
				[dbo].[Events]
			WHERE
				Id = @event_id
		);
	END
	
	ELSE IF(@isCurrent = 1)
	BEGIN
	DECLARE @regNum NVARCHAR(20) = (SELECT registration_number FROM [dbo].[Questions] WHERE Id = @question_id);
	DECLARE @msg NVARCHAR(300) = N'Питання ' + @regNum + N' вже пов`язано з заходом ' + CAST(@event_id AS NVARCHAR(10));
		RAISERROR (@msg, 16, 1);
		RETURN;
	END
END
ELSE 
BEGIN
DECLARE @Query NVARCHAR(MAX) = N'
	UPDATE '+@Archive+N'[dbo].[Questions]
		SET [event_id] = @event_id,
			[edit_date] = GETUTCDATE(),
			[user_edit_id] = @user_id
		WHERE Id = @question_id; 
	
	UPDATE dbo.QuestionsFromCopeWithoutEvent_temp
		SET [event_id] = @event_id,
			[is_done] = 1,
			[done_date] = GETDATE()
		WHERE question_id = @question_id;
';
	EXEC sp_executesql @Query, N'@question_id INT, @event_id INT, @user_id NVARCHAR(128)', 
								@question_id = @question_id,
								@event_id = @event_id,
								@user_id = @user_id;
END