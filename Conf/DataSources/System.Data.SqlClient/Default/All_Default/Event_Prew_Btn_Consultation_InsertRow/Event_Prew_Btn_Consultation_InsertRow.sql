DECLARE @info TABLE (Id INT);
DECLARE @EventAvailable BIT = IIF((SELECT COUNT(1) FROM dbo.[Events] WHERE Id = @Event_Prew_Id) > 0,
								  1,
								  0);

IF(@EventAvailable = 1)
BEGIN
INSERT INTO
	[dbo].[Consultations] (
		[registration_date],
		[phone_number],
		[appeal_id],
		[consultation_type_id],
		[object_id],
		[user_id],
		[event_id]
	)
OUTPUT inserted.Id INTO @info(Id)
VALUES
	(
		getutcdate(),
		@Applicant_Phone,
		@AppealId,
		4,
		/*Щодо заходу*/
		@Applicant_Building,
		@CreatedUser,
		@Event_Prew_Id
	);
END
ELSE IF (@EventAvailable = 0)
BEGIN
INSERT INTO
	[dbo].[Consultations] (
		[registration_date],
		[phone_number],
		[appeal_id],
		[consultation_type_id],
		[object_id],
		[user_id],
		/*Для заходу з городка id пишем сюда*/
		[application_town_id]
	)
OUTPUT inserted.Id INTO @info(Id)
VALUES
	(
		getutcdate(),
		@Applicant_Phone,
		@AppealId,
		4,
		/*Щодо заходу*/
		@Applicant_Building,
		@CreatedUser,
		@Event_Prew_Id
	);
END


IF(SELECT TOP 1 Id FROM @info) IS NOT NULL
BEGIN
	SELECT 'OK' AS result;
END