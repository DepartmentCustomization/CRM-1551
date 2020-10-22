DECLARE @output TABLE (Id INT);
DECLARE @interval FLOAT(53) = 0.2;
DECLARE @valid_date_birth DATETIME;
DECLARE @birth_date2 DATETIME;

--set  @valid_date_birth = IIF( @birth_date is not null, @birth_date + @interval, null )
SET
  @birth_date2 =(
    SELECT
      CASE
        WHEN @day_month IS NOT NULL
        AND @birth_year IS NOT NULL
        AND RIGHT(@day_month, 2) * 1 <= 12
        AND LEFT(@day_month, 2) * 1 <= 31
        AND substring(@day_month, 3, 1) = N'-' THEN CONVERT(
          DATE,
          LTRIM(@birth_year) + N'-' + RIGHT(@day_month, 2) + N'-' + LEFT(@day_month, 2)
        )
        ELSE NULL
      END
  );

SET
  @valid_date_birth = IIF(
    @birth_date2 IS NOT NULL,
    @birth_date2 + @interval,
    NULL
  );

INSERT INTO
  [dbo].[Applicants] (
    [registration_date],
    [full_name],
    [applicant_type_id],
    [category_type_id],
    [social_state_id],
    [mail],
    [sex],
    [birth_date],
    [comment],
    [user_id],
    [edit_date],
    [user_edit_id],
    [applicant_privilage_id],
    [birth_year]
  ) output [inserted].[Id] INTO @output (Id)
VALUES
  (
    getutcdate(),
    @full_name,
    @applicant_type_id,
    @category_type_id,
    @social_state_id,
    @mail,
    @sex,
    @valid_date_birth,
    @comment,
    @user_id,
    getutcdate(),
    @user_id,
    @applicant_privilage_id,
    @birth_year
  );

DECLARE @applicant_id INT;

SET
  @applicant_id =(
    SELECT
      TOP 1 Id
    FROM
      @output
  );

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
    @applicant_id,
    @phone_type_id,
    REPLACE(
      REPLACE(REPLACE(@phone_number, N'(', ''), N')', N''),
      N'-',
      N''
    ),
    N'true',
    getutcdate(),
    @user_id,
    getutcdate(),
    @user_id
  );

IF @phone_type_id2 IS NOT NULL
OR @phone_number2 IS NOT NULL 
BEGIN
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
    @applicant_id,
    @phone_type_id2,
    REPLACE(
      REPLACE(REPLACE(@phone_number2, N'(', ''), N')', N''),
      N'-',
      N''
    ),
    N'false',
    getutcdate(),
    @user_id,
    getutcdate(),
    @user_id
  );

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
    @applicant_id,
    @building_id,
    @house_block,
    @entrance,
    @flat,
    N'true',
    N'true',
    getutcdate(),
    @user_id,
    getutcdate(),
    @user_id
  );

UPDATE
  [dbo].[Applicants]
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
              [dbo].[ApplicantPhones]
              LEFT JOIN [dbo].[PhoneTypes] ON [ApplicantPhones].phone_type_id = [PhoneTypes].Id
            WHERE
              [ApplicantPhones].applicant_id = [LiveAddress].applicant_id FOR XML PATH('')
          ),
          1,
          2,
          N''
        ),
        N''
      ) phone
    FROM
      [dbo].[LiveAddress] [LiveAddress]
      LEFT JOIN [dbo].[Buildings] [Buildings] ON [LiveAddress].building_id = [Buildings].Id
      LEFT JOIN [dbo].[Streets] [Streets] ON [Buildings].street_id = [Streets].Id
      LEFT JOIN [dbo].[StreetTypes] [StreetTypes] ON [Streets].street_type_id = [StreetTypes].Id
      LEFT JOIN [dbo].[Districts] [Districts] ON [Buildings].district_id = [Districts].Id
    WHERE
      applicant_id = @applicant_id
  )
WHERE
  Id = @applicant_id;

SELECT
  @applicant_id AS [Id];

RETURN;