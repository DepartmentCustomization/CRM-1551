DECLARE @info TABLE (Id INT);

INSERT INTO
	[dbo].[Consultations] (
		[registration_date],
		[phone_number],
		[appeal_id],
		[consultation_type_id],
		[object_id],
		[user_id],
		[application_town_id]
	)
OUTPUT inserted.Id INTO @info(Id)
VALUES
	(
		getutcdate(),
		@Applicant_Phone,
		@AppealId,
		2,
		/*За GORODOK*/
		@Applicant_Building,
		@CreatedUser,
		@GorodokClaim_RowId
	) ; 

IF(SELECT TOP 1 Id FROM @info) IS NOT NULL
BEGIN
	SELECT N'OK' AS result;
END 