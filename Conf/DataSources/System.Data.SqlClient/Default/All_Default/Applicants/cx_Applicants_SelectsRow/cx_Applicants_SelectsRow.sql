 --DECLARE @applicant_id INT = 1515914; ee
----------------> GET APPLICANT PHONES IN ROW <-----------------
IF OBJECT_ID('tempdb.dbo.#ApplicantPhones') IS NOT NULL 
BEGIN 
    DROP TABLE #ApplicantPhones;
END
SELECT DISTINCT 
    applicant_id,
    phone_number = CAST(NULL AS VARCHAR(500)) INTO #ApplicantPhones
FROM dbo.ApplicantPhones
WHERE
    applicant_id = @applicant_id;
DECLARE @applicantID INT,
        @Value CHAR(10);

DECLARE cur CURSOR LOCAL READ_ONLY FAST_FORWARD FOR
SELECT
    applicant_id,
    phone_number
FROM dbo.ApplicantPhones
WHERE applicant_id = @applicant_id; 
OPEN cur FETCH NEXT
FROM
    cur INTO @applicantID,
    @Value;
WHILE @@FETCH_STATUS = 0
BEGIN
UPDATE #ApplicantPhones
SET
    phone_number = ISNULL(phone_number + ', ' + @Value, @Value)
WHERE applicant_id = @applicantID;
FETCH NEXT
FROM cur 
INTO @applicantID,
    @Value;
END
CLOSE cur;
DEALLOCATE cur;
---------------------> END GETTING PHONES <---------------------
DECLARE @birthYear INT = (SELECT LEFT(birth_date, 4) FROM dbo.[Applicants] WHERE Id = @applicant_id);
SELECT TOP 1
    [Applicants].Id,
    [Applicants].full_name,
    [Applicants].mail,
    [Districts].Id district_id,
    [Districts].name DistrictsName,
    [Streets].Id StrictId,
    concat(StreetTypes.shortname, ' ', [Streets].[name]) StrictName,
    Buildings.Id building_id,
    CASE
        WHEN [Buildings].street_id IS NOT NULL THEN N'вул. ' + [Streets].name
        ELSE N''
    END + CASE
        WHEN [Buildings].name IS NOT NULL THEN N', буд. ' + [Buildings].name
        ELSE N''
    END AS building_name,
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
        WHEN [Applicants].birth_date IS NULL THEN CONVERT(NVARCHAR(200), [Applicants].birth_year)
        ELSE CONVERT(NVARCHAR(200), [Applicants].birth_date)
    END birth_date,
    CASE
        WHEN [birth_date] IS NULL THEN year(getdate()) - birth_year
        WHEN MONTH([birth_date]) <= MONTH(getdate())
        AND DAY([birth_date]) <= DAY(getdate()) THEN DATEDIFF(yy, [birth_date], getdate())
        ELSE DATEDIFF(yy, [birth_date], getdate()) -1
    END age,
    @birthYear AS [birth_year],
    CASE
        WHEN birth_date IS NOT NULL THEN CASE
            WHEN DAY(birth_date) < 10 THEN N'0' + ltrim(DAY(birth_date)) + N'-'
            ELSE ltrim(DAY(birth_date)) + N'-'
        END + +CASE
            WHEN MONTH(birth_date) < 10 THEN N'0' + ltrim(MONTH(birth_date))
            ELSE ltrim(MONTH(birth_date))
        END
        ELSE NULL
    END day_month,
    [Applicants].comment,
    [ApplicantPhones].phone_number

	--,[LiveAddress].[main]
	--,[LiveAddress].[active]
FROM
    [dbo].[Applicants] [Applicants] 
    LEFT JOIN #ApplicantPhones [ApplicantPhones] ON [ApplicantPhones].applicant_id = [Applicants].Id 
    LEFT JOIN [dbo].[LiveAddress] [LiveAddress] ON [Applicants].Id = [LiveAddress].[applicant_id]
    LEFT JOIN [dbo].[Buildings] [Buildings] ON [LiveAddress].building_id = [Buildings].Id
    LEFT JOIN [dbo].[Districts] [Districts] ON [Buildings].district_id = Districts.Id
    LEFT JOIN [dbo].[Streets] [Streets] ON [Buildings].street_id = [Streets].Id
    LEFT JOIN [dbo].[StreetTypes] [StreetTypes] ON StreetTypes.Id = Streets.street_type_id
    LEFT JOIN [dbo].[ApplicantTypes] [ApplicantTypes] ON [Applicants].applicant_type_id = [ApplicantTypes].Id
    LEFT JOIN [dbo].[CategoryType] [CategoryType] ON [Applicants].category_type_id = [CategoryType].Id
    LEFT JOIN [dbo].[ApplicantPrivilege] [ApplicantPrivilege] ON [Applicants].applicant_privilage_id = [ApplicantPrivilege].Id
    LEFT JOIN [dbo].[SocialStates] [SocialStates] ON [Applicants].social_state_id = [SocialStates].Id
WHERE
    [Applicants].Id = @applicant_id
order by [LiveAddress].[main] desc