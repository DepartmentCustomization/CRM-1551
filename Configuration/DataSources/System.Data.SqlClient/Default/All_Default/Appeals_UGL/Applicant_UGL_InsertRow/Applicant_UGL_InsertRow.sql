DECLARE @output TABLE (Id int);

DECLARE @app_id int;

DECLARE @interval float = 0.2;

DECLARE @valid_date_birth datetime;

DECLARE @numbers TABLE (num nvarchar(15));

SET
    @valid_date_birth = IIF(
        @Application_BirthDate IS NOT NULL,
        @Application_BirthDate + @interval,
        NULL
    )

INSERT INTO
    @numbers
SELECT
    value
FROM
    string_split(@Applicant_Phone, ',');

UPDATE
    @numbers
SET
    num = REPLACE(num, ' ', '')
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
    END IF len(isnull(rtrim(@Applicant_Id), N'')) > 0 BEGIN
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
    Id = @Applicant_Id
DELETE FROM
    [dbo].[LiveAddress]
WHERE
    applicant_id = @Applicant_Id
INSERT INTO
    [dbo].[LiveAddress] (
        applicant_id,
        building_id,
        house_block,
        entrance,
        flat,
        main,
        active
    )
VALUES
    (
        @Applicant_Id,
        @Applicant_Building,
        @Applicant_HouseBlock,
        @Applicant_Entrance,
        @Applicant_Flat,
        1,
        1
    )
UPDATE
    [dbo].[Appeals]
SET
    [applicant_id] = @Applicant_Id
WHERE
    [Id] = @AppealId
    /*
     if (select count(1) from [dbo].[ApplicantPhones] where applicant_id = @Applicant_Id and phone_number = @Applicant_Phone and IsMain = 1) = 0
     begin
     insert into [dbo].[ApplicantPhones]  (applicant_id, phone_type_id, phone_number, IsMain, CreatedAt)
     values (@Applicant_Id, isnull(@Applicant_TypePhone,1), replace(replace(REPLACE(@Applicant_Phone, N'(', ''), N')', N''), N'-', N''), 1, getutcdate())
     end
     else
     begin
     update [dbo].[ApplicantPhones] set CreatedAt = getutcdate(), 
     phone_number = replace(replace(REPLACE(@Applicant_Phone, N'(', ''), N')', N''), N'-', N''), 
     phone_type_id = isnull(@Applicant_TypePhone,1)
     where applicant_id = @Applicant_Id and IsMain = 1
     end
     */
SELECT
    @Applicant_Id AS ApplicantId
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
    )
SET
    @app_id = (
        SELECT
            top 1 Id
        FROM
            @output
    ) --------------- INSERT APPLICANT PHONES -------------------
    DECLARE @step tinyint = 0;
    DECLARE @phone_qty tinyint = (
    SELECT COUNT(1)
    FROM @numbers) 

    WHILE (@step < @phone_qty) 
    BEGIN
    INSERT INTO
    [dbo].[ApplicantPhones] (
        applicant_id,
        phone_type_id,
        IsMain,
        CreatedAt,
        phone_number
    )
VALUES(
    @app_id,
    ISNULL(@Applicant_TypePhone, 1),
    IIF(@step = 0, 1, 0),
    GETUTCDATE(),
   (SELECT num
    FROM @numbers 
    ORDER BY num OFFSET @step ROWS FETCH NEXT @step+1 ROWS ONLY)
)
SET @step += 1;
END 
-----------------------------------------------------------

INSERT INTO
    [dbo].[LiveAddress] (
        applicant_id,
        building_id,
        house_block,
        entrance,
        flat,
        main,
        active
    )
VALUES
    (
        @app_id,
        @Applicant_Building,
        @Applicant_HouseBlock,
        @Applicant_Entrance,
        @Applicant_Flat,
        1,
        1
    )
UPDATE
    [dbo].[Appeals]
SET
    [applicant_id] = @app_id,
    [edit_date] = getutcdate()
WHERE
    [Id] = @AppealId
SELECT
    @app_id AS ApplicantId
END 
UPDATE
    [CRM_1551_Analitics].[dbo].[Applicants]
SET
    [ApplicantAdress] =(
        SELECT
            DISTINCT isnull([Districts].name + N' р-н., ', N'') + isnull([StreetTypes].shortname + N' ', N'') + isnull([Streets].name + N' ', N'') + isnull([Buildings].name + N', ', N'') + isnull(
                N'п. ' + ltrim([LiveAddress].[entrance]) + N', ',
                N''
            ) + isnull(N'кв. ' + ltrim([LiveAddress].flat) + N', ', N'') + N'телефони: ' + isnull(
                stuff(
                    (
                        SELECT
                            N', ' + lower(SUBSTRING([PhoneTypes].name, 1, 3)) + N'.: ' + [ApplicantPhones].phone_number
                        FROM
                            [CRM_1551_Analitics].[dbo].[ApplicantPhones]
                            LEFT JOIN [CRM_1551_Analitics].[dbo].[PhoneTypes] ON [ApplicantPhones].phone_type_id = [PhoneTypes].Id
                        WHERE
                            [ApplicantPhones].applicant_id = [LiveAddress].applicant_id FOR xml path('')
                    ),
                    1,
                    2,
                    N''
                ),
                N''
            ) phone
        FROM
            [CRM_1551_Analitics].[dbo].[LiveAddress]
            LEFT JOIN [CRM_1551_Analitics].[dbo].[Buildings] ON [LiveAddress].building_id = [Buildings].Id
            LEFT JOIN [CRM_1551_Analitics].[dbo].[Streets] ON [Buildings].street_id = [Streets].Id
            LEFT JOIN [CRM_1551_Analitics].[dbo].[StreetTypes] ON [Streets].street_type_id = [StreetTypes].Id
            LEFT JOIN [CRM_1551_Analitics].[dbo].[Districts] ON [Buildings].district_id = [Districts].Id
        WHERE
            applicant_id = @app_id
    )
WHERE
    Id = @app_id 