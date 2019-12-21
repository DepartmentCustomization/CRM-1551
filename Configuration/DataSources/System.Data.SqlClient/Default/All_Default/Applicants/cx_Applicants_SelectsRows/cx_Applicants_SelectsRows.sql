----------------> GET APPLICANT PHONES IN ROW <-----------------
IF OBJECT_ID('tempdb.dbo.#ApplicantPhones') IS NOT NULL
BEGIN
	DROP TABLE #ApplicantPhones
END

SELECT DISTINCT
	  applicant_id
	, phone_number = CAST(NULL AS VARCHAR(500))
INTO #ApplicantPhones
FROM dbo.ApplicantPhones

DECLARE
	  @applicantID INT
	, @Value CHAR(10)

DECLARE cur CURSOR LOCAL READ_ONLY FAST_FORWARD FOR
    SELECT
	      applicant_id
	     ,phone_number
    FROM dbo.ApplicantPhones

OPEN cur
FETCH NEXT FROM cur INTO
	  @applicantID
	, @Value

WHILE @@FETCH_STATUS = 0 BEGIN

    UPDATE #ApplicantPhones
    SET 
          phone_number = ISNULL(phone_number + ', ' + @Value, @Value)
    WHERE applicant_id = @applicantID

	FETCH NEXT FROM cur INTO
          @applicantID
        , @Value
END

CLOSE cur
DEALLOCATE cur
---------------------> END GETTING PHONES <---------------------

select  
[Applicants].Id, 
[Applicants].full_name, 
[Applicants].mail,
[Districts].name DistrictsName, 
 concat(StreetTypes.shortname,' ', [Streets].[name]) Street,
 concat(Buildings.number,Buildings.letter) BuildNumber,
[LiveAddress].house_block, 
[LiveAddress].entrance, 
[LiveAddress].flat,
[ApplicantTypes].name ApplicantType, 
[CategoryType].name Category, 
[ApplicantPrivilege].Name Privilege, 
[SocialStates].name [SocialStates], 
[Applicants].sex, 

 case when [Applicants].birth_date is null then convert(nvarchar(200),[Applicants].birth_year) else convert(nvarchar(200),[Applicants].birth_date) end birth_date,
 case 
  when month(convert(date, [Applicants].birth_date))<=month(getdate())
  and day(convert(date, [Applicants].birth_date))<=day(getdate())
  then DATEDIFF(yy, convert(date, [Applicants].birth_date), getdate())
  else DATEDIFF(yy, convert(date, [Applicants].birth_date), getdate())-1 end age, 
 [Applicants].comment,
 #ApplicantPhones.phone_number

  from [dbo].[Applicants]
  left join #ApplicantPhones on #ApplicantPhones.applicant_id = [Applicants].Id 
  left join [dbo].[LiveAddress] on [Applicants].Id=[LiveAddress].[applicant_id]
  left join [dbo].[Buildings] on [LiveAddress].building_id=[Buildings].Id
  left join [dbo].[Districts] on [Buildings].district_id=Districts.Id
  left join [dbo].[Streets] on [Buildings].street_id=[Streets].Id
  left join StreetTypes on StreetTypes.Id = Streets.street_type_id
  left join [dbo].[ApplicantTypes] on [Applicants].applicant_type_id=[ApplicantTypes].Id
  left join [dbo].[CategoryType] on [Applicants].category_type_id=[CategoryType].Id
  left join [dbo].[ApplicantPrivilege] on [Applicants].applicant_privilage_id=[ApplicantPrivilege].Id
  left join [dbo].[SocialStates] on [Applicants].social_state_id=[SocialStates].Id
  where 
     #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only