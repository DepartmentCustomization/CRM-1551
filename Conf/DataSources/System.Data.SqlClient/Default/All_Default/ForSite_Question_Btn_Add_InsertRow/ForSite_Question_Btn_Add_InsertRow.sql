/*
 declare @CreatedByUserId nvarchar(128)
 declare @Applicant_Id int
 declare @1551_ApplicantFromSite_PIB nvarchar(128)
 declare @ApplicantFromSite_Birthdate date
 declare @ApplicantFromSite_SocialState int
 declare @Applicant_Privilege int
 declare @ApplicantFromSite_Sex nvarchar(128)
 declare @ApplicantFromSite_Age int
 declare @AppealsFromSite_Id int
 declare @Question_ControlDate date
 declare @Question_Building int
 declare @Question_Organization int
 declare @Question_TypeId int
 declare @Question_Content nvarchar(128)
 declare @entrance nvarchar(128)
 declare @flat nvarchar(128)
 */
IF(SELECT
    Appeal_Id
  FROM
    CRM_1551_Site_Integration.dbo.AppealsFromSite
  WHERE
    Id = @AppealsFromSite_Id
) IS NOT NULL 
BEGIN 
  RAISERROR(
  N'У зверненні відбулися зміни, необхідно перезавантажити сторінку',
  16,
  1);
  RETURN; 
END 

DECLARE @output_Appeal TABLE (Id INT);

INSERT INTO
  [dbo].[Appeals] (
    [registration_date],
    [receipt_source_id],
    [phone_number],
    [receipt_date],
    [start_date],
    [user_id],
    [edit_date],
    [user_edit_id]
  ) output [inserted].[Id] INTO @output_Appeal (Id)
VALUES
  (
    getutcdate(),
    2,
    NULL,
    getutcdate(),
    -- @receipt_date
    getutcdate(),
    -- @start_date
    @CreatedByUserId,
    getutcdate(),
    -- @edit_date
    @CreatedByUserId
  );

DECLARE @AppealId INT;

SET
  @AppealId = (
    SELECT
      TOP 1 Id
    FROM
      @output_Appeal
  );

UPDATE
  [dbo].[Appeals]
SET
  registration_number = concat(
    SUBSTRING (rtrim(YEAR(getdate())), 4, 1),
    '-',
    (
      SELECT
        count(Id)
      FROM
        dbo.Appeals
      WHERE
        year(Appeals.registration_date) = year(getutcdate())
    )
  )
WHERE
  Id = @AppealId;

UPDATE
  [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
SET
  Appeal_Id = @AppealId,
  AppealFromSiteResultId = 3
  /*Зареєстровано*/
WHERE
  Id = @AppealsFromSite_Id;

DECLARE @output_Applicant_Id TABLE (Id INT);

IF (@Applicant_Id IS NULL) BEGIN
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
    [birth_year],
    [ApplicantAdress],
    [ApplicantFromSiteId]
  ) output [inserted].[Id] INTO @output_Applicant_Id (Id)
SELECT
  getutcdate() AS [registration_date],
  @1551_ApplicantFromSite_PIB AS [full_name],
  1 AS [applicant_type_id],
  NULL AS [category_type_id],
  @ApplicantFromSite_SocialState AS [social_state_id],
  (
    SELECT
      TOP 1 Mail
    FROM
      [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts]
    WHERE
      ApplicantFromSiteId = (
        SELECT
          TOP 1 ApplicantFromSiteId
        FROM
          [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
        WHERE
          Id = @AppealsFromSite_Id
      )
      AND Mail IS NOT NULL
  ) AS [mail],
  CASE
    WHEN @ApplicantFromSite_Sex = N'ж' THEN 1
    WHEN @ApplicantFromSite_Sex = N'ч' THEN 2
    ELSE NULL
  END AS [sex],
  @ApplicantFromSite_Birthdate AS [birth_date],
  NULL AS [comment],
  @CreatedByUserId AS [user_id],
  getutcdate() AS [edit_date],
  @CreatedByUserId AS [user_edit_id],
  @Applicant_Privilege AS [applicant_privilage_id],
  @ApplicantFromSite_Age AS [birth_year],
  NULL AS [ApplicantAdress],
  NULL AS [ApplicantFromSiteId];

SET
  @Applicant_Id = (
    SELECT
      TOP 1 Id
    FROM
      @output_Applicant_Id
  );

IF (
  @1551_ApplicantFromSite_Address_Building IS NOT NULL
) 
BEGIN
INSERT INTO
  [dbo].[LiveAddress] (
    [applicant_id],
    [building_id],
    [house_block],
    [entrance],
    [flat],
    [main],
    [active]
  )
VALUES
  (
    @Applicant_Id,
    @1551_ApplicantFromSite_Address_Building,
    NULL,
    @1551_ApplicantFromSite_Address_Entrance,
    @1551_ApplicantFromSite_Address_Flat,
    1,
    1
  );

END 
IF object_id('tempdb..#temp_OUT') IS NOT NULL BEGIN DROP TABLE #temp_OUT ;
END 
CREATE TABLE #temp_OUT(
[ApplicantFromSiteId] INT,
[MoreContactTypeId] INT,
[PhoneNumber] NVARCHAR(10)
) WITH (DATA_COMPRESSION = PAGE);

INSERT INTO
  #temp_OUT ([ApplicantFromSiteId], [MoreContactTypeId], [PhoneNumber])
SELECT
  DISTINCT ApplicantFromSiteId,
  MoreContactTypeId,
  RIGHT(PhoneNumber, 10)
FROM
  [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts]
WHERE
  ApplicantFromSiteId = (
    SELECT
      TOP 1 ApplicantFromSiteId
    FROM
      [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
    WHERE
      Id = @AppealsFromSite_Id
  )
  AND PhoneNumber IS NOT NULL;

IF (
  SELECT
    count(1)
  FROM
    #temp_OUT) > 0
    BEGIN IF (
      SELECT
        count(1)
      FROM
        #temp_OUT WHERE MoreContactTypeId = 1) > 0
        BEGIN
      INSERT INTO
        [dbo].[ApplicantPhones] (
          [applicant_id],
          [phone_type_id],
          [phone_number],
          [IsMain],
          [CreatedAt]
        )
      SELECT
        @Applicant_Id AS [applicant_id],
        1 AS [phone_type_id],
        PhoneNumber AS [phone_number],
        1 AS [IsMain],
        getutcdate() AS [CreatedAt]
      FROM
        #temp_OUT 
      WHERE
        MoreContactTypeId = 1;

END
ELSE BEGIN
INSERT INTO
  [dbo].[ApplicantPhones] (
    [applicant_id],
    [phone_type_id],
    [phone_number],
    [IsMain],
    [CreatedAt]
  )
SELECT
  @Applicant_Id AS [applicant_id],
  1 AS [phone_type_id],
  PhoneNumber AS [phone_number],
  1 AS [IsMain],
  getutcdate() AS [CreatedAt]
FROM
  #temp_OUT 
WHERE
  MoreContactTypeId != 1;

END
INSERT INTO
  [dbo].[ApplicantPhones] (
    [applicant_id],
    [phone_type_id],
    [phone_number],
    [IsMain],
    [CreatedAt]
  )
SELECT
  @Applicant_Id AS [applicant_id],
  1 AS [phone_type_id],
  PhoneNumber COLLATE Ukrainian_CI_AS AS [phone_number],
  0 AS [IsMain],
  getutcdate() AS [CreatedAt]
FROM
  #temp_OUT WHERE PhoneNumber COLLATE Ukrainian_CI_AS NOT IN (SELECT [phone_number] FROM [dbo].[ApplicantPhones] WHERE [applicant_id] = @Applicant_Id);
END
END
UPDATE
  [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite]
SET
  ApplicantId = @Applicant_Id
WHERE
  Id = (
    SELECT
      TOP 1 ApplicantFromSiteId
    FROM
      [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
    WHERE
      Id = @AppealsFromSite_Id
  );

DECLARE @output TABLE (Id INT);

DECLARE @output2 TABLE (Id INT);

DECLARE @app_id INT;

DECLARE @assign INT;

DECLARE @getdate DATETIME = getutcdate();

INSERT INTO
  [dbo].[Questions] (
    [appeal_id],
    [registration_number],
    [registration_date],
    [receipt_date],
    [question_state_id],
    [control_date],
    [object_id],
    [object_comment],
    [organization_id],
    [application_town_id],
    [event_id],
    [question_type_id],
    [question_content],
    [answer_form_id],
    [answer_phone],
    [answer_post],
    [answer_mail],
    [user_id],
    [edit_date],
    [user_edit_id],
    [last_assignment_for_execution_id],
    [entrance] -- art
,
    [flat],
    [geolocation_lat],
    [geolocation_lon]
  ) -- art
  output [inserted].[Id] INTO @output (Id)
SELECT
  @AppealId,
  (
    SELECT
      registration_number
    FROM
      dbo.Appeals
    WHERE
      Id = @AppealId
  ) + N'/' + rtrim(
    (
      SELECT
        count(1)
      FROM
        [dbo].[Questions]
      WHERE
        appeal_id = @AppealId
    ) + 1
  )
  /*[registration_number]*/
,
  getutcdate()
  /*[registration_date]*/
,
  getutcdate()
  /*[receipt_date]*/
,
  1
  /*[question_state_id]*/
,
  @Question_ControlDate,
  @Question_Building
  /*[object_id]*/
,
  NULL
  /*[object_comment]*/
,
  @Question_Organization
  /*[organization_id]*/
,
  NULL
  /*[application_town_id]*/
,
  NULL
  /*[event_id]*/
,
  @Question_TypeId
  /*[question_type_id]*/
,
  @Question_Content
  /*[question_content]*/
,
  1
  /*[answer_form_id]*/
,
  NULL
  /*[answer_phone]*/
,
  NULL
  /*[answer_post]*/
,
  NULL
  /*[answer_mail]*/
,
  @CreatedByUserId
  /*[user_id]*/
,
  getutcdate()
  /*edit_date*/
,
  @CreatedByUserId
  /*[user_edit_id]*/
,
  NULL
  /*last_assignment_for_execution_id*/
,
  @entrance -- art
,
  @flat -- art
,
  @AppealFromSite_geolocation_lat,
  @AppealFromSite_geolocation_lon;

SET
  @app_id = (
    SELECT
      TOP 1 Id
    FROM
      @output
  );

INSERT INTO
  [dbo].[QuestionDocFiles] (
    --[link]
    [create_date],
    [user_id],
    [edit_date],
    [edit_user_id],
    [name],
    [File],
    [question_id] --,[GUID]
  )
SELECT
  --N'test' [link]
  GETUTCDATE() [create_date],
  @CreatedByUserId [user_id],
  GETUTCDATE() [edit_date],
  @CreatedByUserId [edit_user_id],
  [AppealFromSiteFiles].[Name],
  [AppealFromSiteFiles].[File],
  @app_id [question_id] --,[GUID]
FROM
  [CRM_1551_Site_Integration].[dbo].[AppealFromSiteFiles]
WHERE
  [AppealFromSiteId] = @AppealsFromSite_Id;

UPDATE
  [dbo].[Appeals]
SET
  [applicant_id] = @applicant_id
WHERE
  [Id] = @AppealId;

EXEC [dbo].[sp_CreateAssignment] @app_id,
@Question_TypeId,
@Question_Building,
@Question_Organization,
@CreatedByUserId,
@Question_ControlDate;

SELECT
  3 AS AppealFromSiteResultId,
  N'Зареєстровано' AS AppealFromSiteResultName,
  @Applicant_Id AS Applicant_Id,
  @AppealId AS AppealId;
