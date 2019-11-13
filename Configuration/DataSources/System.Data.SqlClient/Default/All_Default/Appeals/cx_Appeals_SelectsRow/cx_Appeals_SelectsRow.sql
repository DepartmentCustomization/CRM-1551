	SELECT
	   [Appeals].[Id]
      ,[Applicants].Id as applicant_id
	  ,[Applicants].[full_name]
      ,[Appeals].[registration_date]
      ,[Appeals].[registration_number]
      ,ReceiptSources.Name as receipt_source_name
		,ReceiptSources.Id as receipt_source_id
      ,[Appeals].[phone_number]
      ,[Appeals].[mail]
      ,[Appeals].[enter_number]
      ,[Appeals].[submission_date]
      ,[Appeals].[receipt_date]
      ,[Appeals].[start_date]
      ,[Appeals].[end_date]
      ,[Appeals].[article]
      ,[Appeals].[sender_name]
      ,[Appeals].[sender_post_adrress]
      ,[Appeals].[city_receipt]
      ,Workers.name as [user_id]
      ,[Appeals].[edit_date]
      ,w.name as [user_edit_id]
      ,IIF(Streets.name is null, null, concat(Districts.name, ' р-н., ', StreetTypes.shortname,' ', Streets.name, ' ', Buildings.number, Buildings.letter, ', ',
		IIF(LiveAddress.[entrance] is null, null, concat('п. ',LiveAddress.[entrance],',' )), ' ',
			IIF(LiveAddress.flat is null, null, concat('кв. ',LiveAddress.flat) )
		)) as adress
      ,ApplicantPhones.phone_number as app_phone
	  ,REVERSE(STUFF(REVERSE(
  case
  when [ApplicantPrivilege].Name is not null then N'пільги- '+[ApplicantPrivilege].Name+N', ' else N''
  end+
  case 
  when [SocialStates].Name is not null then N'соц. стан- '+[SocialStates].Name+N', ' else N''
  end+
  case 
  when [CategoryType].Name is not null then N'категорія- '+[CategoryType].Name+N', ' else N''
  end+
  case 
  when [Applicants].sex=2 then N'стать- чоловіча, ' when [Applicants].sex=1 then N'стать- жіноча, ' else N''
  end+
  case
  when [Applicants].[birth_date] is not null then N'дата народження- '+ convert(nvarchar(200), [Applicants].[birth_date])+N', ' else N''
  end+

  --case
  --when [Applicants].age is not null then N'вік- '+ convert(nvarchar(5),[Applicants].[age])+N', ' else N''
  --end

  case
  when [birth_date] is null and [birth_year] is null then N''
  when [birth_date] is not null
  then 
	case when month([birth_date])>month(getdate()) or (month([birth_date])=month(getdate()) and day([birth_date])>=day(getdate()))
	then N'вік- '+ltrim(year(GETDATE())-YEAR([birth_date])-1)+N', ' else N'вік- '+ltrim(year(GETDATE())-YEAR([birth_date]))+N', ' end

  else N'вік- '+ltrim(year(GETDATE())-[birth_year])+N', '
  end


  ),1,2,'')) q
  FROM [dbo].[Appeals]
	left join ReceiptSources on ReceiptSources.Id = Appeals.receipt_source_id
	left join Applicants on Applicants.Id = Appeals.applicant_id
	left join LiveAddress on LiveAddress.applicant_id = Applicants.Id and LiveAddress.main = 1
	left join Buildings on Buildings.Id = LiveAddress.building_id
	left join Districts on Districts.Id = Buildings.district_id
	left join Streets on Streets.Id = Buildings.street_id
	left join StreetTypes on StreetTypes.Id = Streets.street_type_id
	left join ApplicantPhones on ApplicantPhones.applicant_id = Applicants.Id
	left join Workers on Workers.worker_user_id = Appeals.user_id
	left join Workers  w on w.worker_user_id = Appeals.user_edit_id
	left join [CRM_1551_Analitics].[dbo].[ApplicantPrivilege] on [Applicants].applicant_privilage_id=[ApplicantPrivilege].Id
	left join [CRM_1551_Analitics].[dbo].[SocialStates] on [Applicants].social_state_id=[SocialStates].Id
    left join [CRM_1551_Analitics].[dbo].[CategoryType] on [Applicants].category_type_id=[CategoryType].Id
WHERE [Appeals].[Id] = @Id