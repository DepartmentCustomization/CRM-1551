DECLARE @info TABLE (Id INT);

INSERT INTO
	[dbo].[Consultations] (
		[registration_date],
		[phone_number],
		[appeal_id],
		[consultation_type_id],
		[object_id],
		[user_id],
		[knowledge_base_id]
	) 
OUTPUT inserted.Id INTO @Info(Id)
VALUES
	(
		getutcdate(),
		@Applicant_Phone,
		@AppealId,
		3,
		/*За Базою Знань (БЗ)*/
		@Applicant_Building,
		@CreatedUser,
		@knowledge_base_id
	);

IF(@applicant_id IS NOT NULL) 
BEGIN 
----- add Artem
UPDATE
	  [dbo].[Appeals]
SET
	applicant_id = @applicant_id
WHERE
	id = @AppealId;
END

IF(SELECT TOP 1 Id FROM @info) IS NOT NULL
BEGIN 
SELECT N'OK' AS result;
END