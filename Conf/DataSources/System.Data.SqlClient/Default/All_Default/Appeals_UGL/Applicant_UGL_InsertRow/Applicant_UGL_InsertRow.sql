/*
DECLARE @Applicant_Id INT = null ;
DECLARE @Applicant_PIB NVARCHAR(100) = 'ШВЕЦЬ МАКСИМ ОЛЕКСАНДРОВИЧ';
DECLARE @Applicant_Privilege INT = null;
DECLARE @Applicant_SocialStates INT = 2;
DECLARE @Applicant_CategoryType INT = null;
DECLARE @Applicant_Type INT = null;
DECLARE @Applicant_Sex INT = 2;
DECLARE @Application_BirthDate INT = null;
DECLARE @Applicant_Age INT = null;
DECLARE @Applicant_Comment INT = null;
DECLARE @Applicant_Building INT = 6108;
DECLARE @Applicant_HouseBlock INT = null;
DECLARE @Applicant_Entrance INT = null;
DECLARE @Applicant_Flat INT = 144;
DECLARE @AppealId INT = 5399962;
DECLARE @Applicant_Phone NVARCHAR(200) = '0634385429, 0965262445, 0445137276';
DECLARE @Applicant_Email INT = null;
DECLARE @Applicant_TypePhone INT = 1;
DECLARE @CreatedUser NVARCHAR(128) = (SELECT TOP 1 UserId FROM CRM_1551_System.dbo.[User]);
*/

DECLARE @output TABLE (Id INT);

DECLARE @app_id INT=0;

DECLARE @interval NUMERIC(8,2) = 0.2;

DECLARE @numbers TABLE (pos INT, num NVARCHAR(15));

DECLARE @valid_date_birth DATETIME = IIF(
        @Application_BirthDate IS NOT NULL,
        @Application_BirthDate + @interval,
        NULL
    );

INSERT INTO
    @numbers
SELECT
Row_Number() OVER (ORDER BY (SELECT 1)),
    value
FROM
    string_split(@Applicant_Phone, ',');

UPDATE
    @numbers
SET
    num = REPLACE(num, ' ', '');
UPDATE
    @numbers
SET
    num = CASE
        WHEN len(num) > 10 THEN CASE
            WHEN (LEFT(num, 2) = '38') THEN RIGHT(num, len(num) -2)
            WHEN (LEFT(num, 1) = '3')
            AND (LEFT(num, 2) <> '38') THEN RIGHT(num, len(num) -1)
            WHEN (LEFT(num, 1) = '8') THEN RIGHT(num, len(num) -1)
        END
        WHEN len(num) < 10
        AND (LEFT(num, 1) != '0') THEN N'0' + num
        ELSE num
    END; 

IF len(isnull(rtrim(@Applicant_Id), N'')) > 0 
    BEGIN
UPDATE
    [dbo].[Applicants]
SET
    [full_name] = @Applicant_PIB,
    [applicant_privilage_id] = @Applicant_Privilege,
    [social_state_id] = @Applicant_SocialStates,
    [category_type_id] = @Applicant_CategoryType,
    [sex] = @Applicant_Sex,
    [birth_date] = @valid_date_birth,
    [birth_year] = YEAR(@Application_BirthDate) -- DATEDIFF(YEAR,@Application_BirthDate, getdate()) /*@Applicant_Age*/
,
    [comment] = @Applicant_Comment,
    [mail] = @Applicant_Email,
    [applicant_type_id] = @Applicant_Type,
    [user_id] = @CreatedUser,
    [edit_date] = getutcdate(),
    [user_edit_id] = @CreatedUser
WHERE
    Id = @Applicant_Id;
DELETE FROM
    [dbo].[LiveAddress]
WHERE
    applicant_id = @Applicant_Id;
INSERT INTO
    [dbo].[LiveAddress] (
        [applicant_id],
        [building_id],
        [house_block],
        [entrance],
        [flat],
        [main],
        [active],
		[create_date],
		[user_id],
		[edit_date],
		[user_edit_id]
    )
VALUES
    (
        @Applicant_Id,
        @Applicant_Building,
        @Applicant_HouseBlock,
        @Applicant_Entrance,
        @Applicant_Flat,
        1,
        1,
		GETUTCDATE(),
		@CreatedUser,
		GETUTCDATE(),
		@CreatedUser
    );
UPDATE
    [dbo].[Appeals]
SET
    [applicant_id] = @Applicant_Id,
    [user_edit_id] = @CreatedUser,
    [edit_date]=GETDATE()
WHERE
    [Id] = @AppealId;
   
SELECT
    @Applicant_Id AS ApplicantId;
END
ELSE BEGIN
INSERT INTO
    [dbo].[Applicants] (
        [category_type_id],
        [full_name],
        [registration_date],
        [social_state_id],
        [sex],
        [birth_date],
        [birth_year],
        [comment],
        [user_id],
        [edit_date],
        [user_edit_id],
        [applicant_privilage_id],
        [mail],
        [applicant_type_id]
    ) output [inserted].[Id] INTO @output (Id)
VALUES
    (
        @Applicant_CategoryType,
        @Applicant_PIB,
        getutcdate(),
        @Applicant_SocialStates,
        @Applicant_Sex,
        @valid_date_birth,
        YEAR(@Application_BirthDate),
      --  @Applicant_Age, -- DATEDIFF(YEAR,@Application_BirthDate, getdate()) @Applicant_Age*/
        @Applicant_Comment,
        @CreatedUser,
        getutcdate(),
        @CreatedUser,
        @Applicant_Privilege,
        @Applicant_Email,
        @Applicant_Type
    );
SET @app_id = (
        SELECT
            TOP 1 Id
        FROM
            @output
    ); 
    --------------- INSERT APPLICANT PHONES ------------------- КУУУКУ
    DECLARE @step TINYINT = 1;
    DECLARE @phone_qty TINYINT = (
    SELECT COUNT(1)
    FROM @numbers); 

    WHILE (@step <= @phone_qty) 
    BEGIN
    INSERT INTO
    [dbo].[ApplicantPhones] (
        [applicant_id],
        [phone_type_id],
        [IsMain],
        [CreatedAt],
        [phone_number],
		[user_id],
		[edit_date],
		[user_edit_id]
    )
VALUES(
    @app_id,
    ISNULL(@Applicant_TypePhone, 1),
    IIF(@step = 0, 1, 0),
    GETUTCDATE(),
   (SELECT num
    FROM @numbers 
    WHERE pos = @step ),
	@CreatedUser,
	GETUTCDATE(),
	@CreatedUser
);
SET @step += 1;
END 

INSERT INTO
    [dbo].[LiveAddress] (
        [applicant_id],
        [building_id],
        [house_block],
        [entrance],
        [flat],
        [main],
        [active],
		[create_date],
		[user_id],
		[edit_date],
		[user_edit_id]
    )
VALUES
    (
        @app_id,
        @Applicant_Building,
        @Applicant_HouseBlock,
        @Applicant_Entrance,
        @Applicant_Flat,
        1,
        1,
		GETUTCDATE(),
		@CreatedUser,
		GETUTCDATE(),
		@CreatedUser
    );
UPDATE
    [dbo].[Appeals]
SET
    [applicant_id] = @app_id,
    [edit_date] = getutcdate()
WHERE
    [Id] = @AppealId;
SELECT 
    @app_id AS ApplicantId;
END 
UPDATE
      [dbo].[Applicants]
SET
    [ApplicantAdress] =(
        SELECT
            TOP 1 isnull([Districts].name + N' р-н., ', N'') + isnull([StreetTypes].shortname + N' ', N'') + isnull([Streets].name + N' ', N'') + isnull([Buildings].name + N', ', N'') + isnull(
                N'п. ' + ltrim([LiveAddress].[entrance]) + N', ',
                N''
            ) + isnull(N'кв. ' + ltrim([LiveAddress].flat) + N', ', N'') + N'телефони: ' + isnull(
                stuff(
                    (
                        SELECT
                            N', ' + lower(SUBSTRING([PhoneTypes].name, 1, 3)) + N'.: ' + [ApplicantPhones].phone_number
                        FROM
                              [dbo].[ApplicantPhones]
                            LEFT JOIN   [dbo].[PhoneTypes] ON [ApplicantPhones].phone_type_id = [PhoneTypes].Id
                        WHERE
                            [ApplicantPhones].applicant_id = [LiveAddress].applicant_id FOR XML Path('')
                    ),
                    1,
                    2,
                    N''
                ),
                N''
            ) phone
        FROM 
          [dbo].[LiveAddress] LiveAddress
            LEFT JOIN   [dbo].[Buildings] Buildings
                ON [LiveAddress].building_id = [Buildings].Id
            LEFT JOIN   [dbo].[Streets] Streets
                ON [Buildings].street_id = [Streets].Id
            LEFT JOIN   [dbo].[StreetTypes] StreetTypes
                ON [Streets].street_type_id = [StreetTypes].Id
            LEFT JOIN   [dbo].[Districts] Districts
            ON [Buildings].district_id = [Districts].Id
        WHERE
            applicant_id = @app_id
    )
WHERE
    Id = @app_id; 