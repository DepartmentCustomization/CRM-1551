-- declare @Phone nvarchar(100) = N'(089)988-99-80'
-- declare @IsMain int = 0
-- declare @Applicant_id int = 1490249
-- declare @IdPhone int = 123
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
IF @IsMain = 1 
BEGIN
UPDATE
	[dbo].[ApplicantPhones]
SET
	IsMain = 0
WHERE
	applicant_id = @Applicant_id;
SELECT
	N'Update isMain' AS [Result];
END
UPDATE
	[dbo].[ApplicantPhones]
SET
	IsMain = @IsMain,
	phone_number = isnull(
		rtrim(
			REPLACE(
				REPLACE(REPLACE(@Phone, N'(', ''), N')', N''),
				N'-',
				N''
			)
		),
		N''
	),
	phone_type_id = @TypePhone,
	edit_date = GETUTCDATE(),
	user_edit_id = @user_id
WHERE
	Id = @IdPhone;
SELECT
	N'OK' AS [Result];
END
ELSE 
BEGIN
SELECT
	'ERROR' AS [Result];
END