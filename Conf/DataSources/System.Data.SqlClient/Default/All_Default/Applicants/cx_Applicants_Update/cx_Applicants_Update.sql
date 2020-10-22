DECLARE @building_id2 INT;
DECLARE @interval FLOAT(25) = 0.2;
DECLARE @valid_date_birth DATETIME;
DECLARE @birth_date2 DATETIME;

IF EXISTS (
  SELECT
    *
  FROM
    dbo.LiveAddress
  WHERE
    applicant_id = @applicant_id
) 
BEGIN
UPDATE
  [dbo].[LiveAddress]
SET
  [building_id] = @building_id,
  [house_block] = @house_block,
  [entrance] = @entrance,
  [flat] = @flat,
  [edit_date] = GETUTCDATE(),
  [user_edit_id] = @user_id
WHERE
  [applicant_id] = @applicant_id;

END
ELSE 
BEGIN
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
    @building_id2,
    @house_block,
    @entrance,
    @flat,
    N'true',
    N'true',
    GETUTCDATE(),
    @user_id,
    GETUTCDATE(),
    @user_id
  );

END
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

IF @building_id IN (N'', N' ', N'  ') 
BEGIN
SET
  @building_id2 = NULL;

END;

ELSE 
BEGIN
SET
  @building_id2 = @building_id;

END
UPDATE
  dbo.LiveAddress
SET
  building_id = @building_id,
  entrance = @entrance,
  flat = @flat,
  edit_date = GETUTCDATE(),
  user_edit_id = @user_id
WHERE
  applicant_id = @applicant_id
  AND main = 1;

UPDATE
  [dbo].[Applicants]
SET
  [full_name] = @full_name,
  [applicant_type_id] = @applicant_type_id,
  [category_type_id] = @category_type_id,
  [social_state_id] = @social_state_id,
  [mail] = @mail,
  [sex] = @sex,
  [birth_date] = @valid_date_birth,
  [comment] = @comment,
  [edit_date] = getdate(),
  [user_edit_id] = @user_id,
  [applicant_privilage_id] = @applicant_privilage_id,
  [birth_year] = @birth_year,
  ApplicantAdress = (
    SELECT
      DISTINCT isnull(d.name + N' р-н., ', N'') + isnull(st.shortname + N' ', N'') + isnull(s.name + N' ', N'') + isnull(b.name + N', ', N'') + isnull(
        N'п. ' + ltrim(la.[entrance]) + N', ',
        N''
      ) + isnull(N'кв. ' + ltrim(la.flat) + N', ', N'') + N'телефони: ' + isnull(
        stuff(
          (
            SELECT
              N', ' + lower(SUBSTRING([PhoneTypes].name, 1, 3)) + N'.: ' + [ApplicantPhones].phone_number
            FROM
              [dbo].[ApplicantPhones]
              LEFT JOIN [dbo].[PhoneTypes] ON [ApplicantPhones].phone_type_id = [PhoneTypes].Id
            WHERE
              [ApplicantPhones].applicant_id = la.applicant_id FOR XML PATH('')
          ),
          1,
          2,
          N''
        ),
        N''
      ) phone
    FROM
      [dbo].[LiveAddress] la
      LEFT JOIN [dbo].[Buildings] b ON la.building_id = b.Id
      LEFT JOIN [dbo].[Streets] s ON b.street_id = s.Id
      LEFT JOIN [dbo].[StreetTypes] st ON s.street_type_id = st.Id
      LEFT JOIN [dbo].[Districts] d ON b.district_id = d.Id
    WHERE
      applicant_id = @applicant_id
  )
WHERE
  id = @applicant_id;