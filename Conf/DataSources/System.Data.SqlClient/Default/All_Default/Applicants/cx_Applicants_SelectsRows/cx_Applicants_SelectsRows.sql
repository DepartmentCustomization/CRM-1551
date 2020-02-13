SELECT
  [Applicants].Id,
  [Applicants].full_name,
  sub_phones.phone_number,
  [Applicants].mail,
  [Districts].name DistrictsName,
  CONCAT(StreetTypes.shortname, ' ', [Streets].[name]) Street,
  CONCAT(Buildings.number, Buildings.letter) BuildNumber,
  [LiveAddress].house_block,
  [LiveAddress].entrance,
  [LiveAddress].flat,
  [ApplicantTypes].name ApplicantType,
  [CategoryType].name Category,
  [ApplicantPrivilege].Name Privilege,
  [SocialStates].name [SocialStates],
  [Applicants].sex,
  CASE
    WHEN [Applicants].birth_date IS NULL THEN CONVERT(NVARCHAR(200), [Applicants].birth_year)
    ELSE CONVERT(NVARCHAR(200), [Applicants].birth_date)
  END birth_date,
  CASE
    WHEN MONTH(CONVERT(DATE, [Applicants].birth_date)) <= MONTH(getdate())
    AND DAY(CONVERT(DATE, [Applicants].birth_date)) <= DAY(getdate()) THEN DATEDIFF(
      yy,
      CONVERT(DATE, [Applicants].birth_date),
      getdate()
    )
    ELSE DATEDIFF(
      yy,
      CONVERT(DATE, [Applicants].birth_date),
      getdate()
    ) -1
  END age,
  [Applicants].comment
FROM
  [dbo].[Applicants]
  LEFT JOIN [dbo].[LiveAddress] ON [Applicants].Id = [LiveAddress].[applicant_id]
  LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id = [Buildings].Id
  LEFT JOIN [dbo].[Districts] ON [Buildings].district_id = Districts.Id
  LEFT JOIN [dbo].[Streets] ON [Buildings].street_id = [Streets].Id
  LEFT JOIN StreetTypes ON StreetTypes.Id = Streets.street_type_id
  LEFT JOIN [dbo].[ApplicantTypes] ON [Applicants].applicant_type_id = [ApplicantTypes].Id
  LEFT JOIN [dbo].[CategoryType] ON [Applicants].category_type_id = [CategoryType].Id
  LEFT JOIN [dbo].[ApplicantPrivilege] ON [Applicants].applicant_privilage_id = [ApplicantPrivilege].Id
  LEFT JOIN [dbo].[SocialStates] ON [Applicants].social_state_id = [SocialStates].Id
  LEFT JOIN (SELECT 
     b.Id AS applicant_id,
     phone_number  = STUFF(
       (SELECT ', ' + p.phone_number
        FROM dbo.Applicants b1
		INNER JOIN dbo.ApplicantPhones p ON p.applicant_id = b1.Id 
		WHERE p.applicant_id = b.Id 
        FOR XML PATH('')), 1, 1, '')
     FROM
     dbo.Applicants b) sub_phones ON sub_phones.applicant_id = [Applicants].Id 
WHERE
 #filter_columns#
 #sort_columns#
 OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY