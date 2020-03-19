-- DECLARE @applicantId INT = 1515930;

DECLARE @numbers TABLE (pos INT, num NVARCHAR(15));

INSERT INTO
  @numbers
SELECT
  Row_Number() OVER (ORDER BY (SELECT 1)),
  phone_number
FROM
  dbo.ApplicantPhones
WHERE
  applicant_id = @applicantId ;

UPDATE
  @numbers
SET
  num = REPLACE(num, ' ', '') ;

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
  END ;

  DECLARE @phone_qty INT = (
    SELECT
      count(1)
    FROM
      @numbers
  );

DECLARE @step INT = 1;

DECLARE @full_phone2 NVARCHAR(500);

DECLARE @current_phone NVARCHAR(10);

WHILE (@step <= @phone_qty)
 BEGIN
SET
  @current_phone = (
    SELECT
      num
    FROM
      @numbers
    WHERE pos = @step 
  );

SET
  @full_phone2 = isnull(@full_phone2, '') + IIF(
    len(@full_phone2) > 1,
    N', ' + @current_phone,
    @current_phone
  );
SET
  @step += 1;
END
SELECT
  TOP 1 
  full_name AS Applicant_PIB,
  b.Id AS buildingId,
  st.shortname + ' ' + s.[name] + isnull(' ' + b.[name], '') buildingName,
  house_block AS Applicant_HouseBlock,
  entrance AS Applicant_Entrance,
  flat AS Applicant_Flat,
  ap.Id AS privilegeId,
  ap.[Name] AS privilegeName,
  ss.Id AS socialId,
  ss.[name] AS socialName,
  at.Id AS applicantTypeId,
  at.[name] AS applicantTypeName,
  a.sex AS Applicant_Sex,
  CAST(a.birth_date AS DATE) AS Applicant_BirthDate,
  a.mail AS Applicant_Email,
  a.comment AS Applicant_Comment,
  a.Id AS ApplicantId,
  IIF(
    a.birth_date IS NOT NULL,
    year(getdate()) - year(a.birth_date),
    NULL
  ) AS Applicant_Age,
  o.[short_name] AS execOrg,
  @full_phone2 AS CardPhone
FROM
  dbo.Applicants a
  LEFT JOIN dbo.LiveAddress la ON la.applicant_id = a.Id
  LEFT JOIN dbo.Buildings b ON b.Id = la.building_id
  LEFT JOIN dbo.Streets s ON s.Id = b.street_id
  LEFT JOIN dbo.StreetTypes st ON st.Id = s.street_type_id
  LEFT JOIN dbo.Districts d ON d.Id = s.district_id
  LEFT JOIN dbo.SocialStates ss ON ss.Id = a.social_state_id
  LEFT JOIN dbo.ApplicantPrivilege ap ON ap.Id = a.applicant_privilage_id
  LEFT JOIN dbo.ApplicantTypes at ON at.Id = a.applicant_type_id
  LEFT JOIN dbo.[Objects] obj ON obj.builbing_id = b.Id
  LEFT JOIN dbo.ExecutorInRoleForObject exo ON exo.[object_id] = obj.Id
  LEFT JOIN dbo.Organizations o ON o.Id = exo.executor_id
WHERE
  a.Id = @applicantId
  AND (
    o.organization_type_id IN (3, 6, 7, 11)
    OR o.organization_type_id IS NULL
  )
ORDER BY
  organization_type_id DESC ;