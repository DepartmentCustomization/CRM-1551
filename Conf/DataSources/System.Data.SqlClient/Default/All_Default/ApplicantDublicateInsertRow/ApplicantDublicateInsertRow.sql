/*
DECLARE @ApplicantId INT = 1494298,
		@PhoneNumber NVARCHAR(25) = N'0631135520, 0632701143',
 		@CreatedById NVARCHAR(128) = N'Admin' ;
*/
DECLARE @IsMoreThanOne BIT = (SELECT IIF(CHARINDEX(',', @PhoneNumber) > 0,1,0 ) );

IF(@IsMoreThanOne = 1)
BEGIN
SET @PhoneNumber = (SELECT 
						phone_number 
					FROM dbo.ApplicantPhones 
					WHERE applicant_id = @ApplicantId 
					AND IsMain = 1);
END

IF (
	SELECT
		count(1)
	FROM
		[dbo].[ApplicantDublicate]
	WHERE
		PhoneNumber = @PhoneNumber
		AND IsDone = 0
) > 0 
BEGIN
SELECT
	N'Поточний номер уже додано до списку для обробки' AS [Id] ;
END
ELSE 
BEGIN
INSERT INTO
	[dbo].[ApplicantDublicate] (PhoneNumber, CreatedById) 
	output [inserted].[Id]
VALUES
	(@PhoneNumber, @CreatedById) ;
END