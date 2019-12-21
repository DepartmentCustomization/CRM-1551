-- DECLARE @applicant_id INT = 4;
----------------> GET APPLICANT PHONES IN ROW <-----------------
IF OBJECT_ID('tempdb.dbo.#ApplicantPhones') IS NOT NULL BEGIN DROP TABLE #ApplicantPhones
END
SELECT
    DISTINCT applicant_id,
    phone_number = CAST(NULL AS VARCHAR(500)) INTO #ApplicantPhones
FROM
    dbo.ApplicantPhones 
	WHERE applicant_id = @applicant_id
	DECLARE @applicantID INT,
    @Value CHAR(10) 
	DECLARE cur 
	CURSOR LOCAL READ_ONLY FAST_FORWARD FOR
SELECT
    applicant_id,
    phone_number
FROM
    dbo.ApplicantPhones
	where applicant_id = @applicant_id
	OPEN cur FETCH NEXT
FROM
    cur INTO @applicantID,
    @Value WHILE @@FETCH_STATUS = 0 BEGIN
UPDATE
    #ApplicantPhones
SET
    phone_number = ISNULL(phone_number + ', ' + @Value, @Value)
WHERE
    applicant_id = @applicantID FETCH NEXT
FROM
    cur INTO @applicantID,
    @Value
END 
CLOSE cur 
DEALLOCATE cur 
---------------------> END GETTING PHONES <---------------------
SELECT
    [Applicants].Id,
    [Applicants].full_name,
    [Applicants].mail,
	[Districts].Id district_id,
    [Districts].name DistrictsName,
	[Streets].Id StrictId,
    concat(StreetTypes.shortname, ' ', [Streets].[name]) StrictName,
	Buildings.Id building_id,
    case when [Buildings].street_id is not null then N'вул. '+[Streets].name else N'' end+
    case when [Buildings].name is not null then N', буд. '+[Buildings].name else N'' end 
    as building_name,
    [LiveAddress].house_block,
    [LiveAddress].entrance,
    [LiveAddress].flat,
	[ApplicantTypes].Id applicant_type_id,
    [ApplicantTypes].name ApplicantType,
	[CategoryType].Id category_type_id,
    [CategoryType].name Category,
	[ApplicantPrivilege].Id applicant_privilage_id,
    [ApplicantPrivilege].Name Privilege,
	[SocialStates].Id social_state_id,
    [SocialStates].name [SocialStates],
    [Applicants].sex,
    CASE
        WHEN [Applicants].birth_date IS NULL THEN CONVERT(nvarchar(200), [Applicants].birth_year)
        ELSE CONVERT(nvarchar(200), [Applicants].birth_date)
    END birth_date,
    case 
when [birth_date] is null then year(getdate())-birth_year
  when month([birth_date])<=month(getdate())
  and day([birth_date])<=day(getdate())
  then DATEDIFF(yy, [birth_date], getdate())
  else DATEDIFF(yy, [birth_date], getdate())-1 end age,
  [birth_year],
 case 
 when birth_date is not null
 then
  case when day(birth_date)<10 then N'0'+ltrim(day(birth_date))+N'-' else ltrim(day(birth_date))+N'-' end+
 +case when month(birth_date)<10 then N'0'+ltrim(month(birth_date)) else ltrim(month(birth_date)) end
 else null end day_month,

    [Applicants].comment,
    #ApplicantPhones.phone_number
FROM
    [dbo].[Applicants]
    LEFT JOIN #ApplicantPhones on #ApplicantPhones.applicant_id = [Applicants].Id 
    LEFT JOIN [dbo].[LiveAddress] ON [Applicants].Id = [LiveAddress].[applicant_id]
    LEFT JOIN [dbo].[Buildings] ON [LiveAddress].building_id = [Buildings].Id
    LEFT JOIN [dbo].[Districts] ON [Buildings].district_id = Districts.Id
    LEFT JOIN [dbo].[Streets] ON [Buildings].street_id = [Streets].Id
    LEFT JOIN StreetTypes ON StreetTypes.Id = Streets.street_type_id
    LEFT JOIN [dbo].[ApplicantTypes] ON [Applicants].applicant_type_id = [ApplicantTypes].Id
    LEFT JOIN [dbo].[CategoryType] ON [Applicants].category_type_id = [CategoryType].Id
    LEFT JOIN [dbo].[ApplicantPrivilege] ON [Applicants].applicant_privilage_id = [ApplicantPrivilege].Id
    LEFT JOIN [dbo].[SocialStates] ON [Applicants].social_state_id = [SocialStates].Id
WHERE
    [dbo].[Applicants].Id = @applicant_id