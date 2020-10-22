-- declare @Phone nvarchar(100) = N'(089)988-99-80'
-- declare @IsMain int = 0
-- declare @Applicant_id int = 1490249
-- declare @TypePhone int = 1

IF len(
	isnull(
		rtrim(
			REPLACE(
				REPLACE(REPLACE(@Phone, N'(', ''), N')', N''),
				N'-',
				N''
			)
		),
		N''
	)
) > 0 
BEGIN 
IF (
	SELECT
		count(1)
	FROM
		[dbo].[ApplicantPhones]
	WHERE
		applicant_id = @Applicant_id
		AND phone_number = isnull(
			rtrim(
				REPLACE(
					REPLACE(REPLACE(@Phone, N'(', ''), N')', N''),
					N'-',
					N''
				)
			),
			N''
		)
) = 0 
BEGIN 
IF @IsMain = 1 
BEGIN
UPDATE
	[dbo].[ApplicantPhones]
SET
	IsMain = 0
WHERE
	applicant_id = @Applicant_id;
	 -- select N'Update isMain' as [Result]
END
INSERT INTO
	[dbo].[ApplicantPhones] (
		[applicant_id],
		[phone_type_id],
		[phone_number],
		[IsMain],
		[CreatedAt],
		[user_id],
		[edit_date],
		[user_edit_id]
	)
VALUES
	(
		@Applicant_id,
		isnull(@TypePhone, 1),
		REPLACE(
			REPLACE(REPLACE(@Phone, N'(', ''), N')', N''),
			N'-',
			N''
		),
		@IsMain,
		getutcdate(),
		@user_id,
		getutcdate(),
		@user_id
	);
SELECT
	'OK' AS [Result];
END
ELSE 
BEGIN
SELECT
	'ERROR' AS [Result];
END
END
ELSE 
BEGIN
SELECT
	'ERROR' AS [Result];
END