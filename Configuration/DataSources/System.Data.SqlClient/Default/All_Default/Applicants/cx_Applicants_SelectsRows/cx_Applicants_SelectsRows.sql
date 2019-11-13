
select [Applicants].Id, 
[Applicants].full_name, 
ApplicantPhonesMain.phone_number, 
ApplicantPhonesMain.PhoneType PhoneType, 
ApplicantPhonesNotMain.phone_number phone_number2, 
ApplicantPhonesNotMain.PhoneType PhoneType2, 
[Applicants].mail,
[Districts].name DistrictsName, 
--concat(StreetTypes.shortname,' '+ [Streets].[name], ', буд. '+ ltrim(Buildings.number), '' + Buildings.letter) as BuildNumber,
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
 [ApplicantPhonesMain].phone_number_norm,
 [ApplicantPhonesNotMain].phone_number_norm phone_number_norm2

  from [dbo].[Applicants]
  left join 
  (select [ApplicantPhones].[Id]
      ,N'('+left([phone_number],3)+N')'+substring([phone_number],4,3)+N'-'+substring([phone_number],7,2)+N'-'+substring([phone_number],9,2) [phone_number]
	  ,[ApplicantPhones].[applicant_id]
	  ,[PhoneTypes].name PhoneType
	  ,[phone_number] [phone_number_norm]
from [CRM_1551_Analitics].[dbo].[ApplicantPhones]
left join [CRM_1551_Analitics].[dbo].[PhoneTypes] on [ApplicantPhones].phone_type_id=[PhoneTypes].Id
where [ApplicantPhones].[IsMain]=N'true') ApplicantPhonesMain on [Applicants].Id=[ApplicantPhonesMain].applicant_id
  
  left join 

  (select [ApplicantPhones].[Id]
      ,N'('+left([phone_number],3)+N')'+substring([phone_number],4,3)+N'-'+substring([phone_number],7,2)+N'-'+substring([phone_number],9,2) [phone_number]
	  ,[ApplicantPhones].[applicant_id]
	  ,[PhoneTypes].name PhoneType
	  ,[phone_number] [phone_number_norm]
from [CRM_1551_Analitics].[dbo].[ApplicantPhones]
left join [CRM_1551_Analitics].[dbo].[PhoneTypes] on [ApplicantPhones].phone_type_id=[PhoneTypes].Id
where [ApplicantPhones].Id in (select max(Id) max_id
  from [CRM_1551_Analitics].[dbo].[ApplicantPhones]
  where IsMain=N'false'
  group by [applicant_id])) ApplicantPhonesNotMain on [Applicants].Id=[ApplicantPhonesNotMain].applicant_id

  --left join [dbo].[PhoneTypes] on [ApplicantPhones].phone_type_id=[PhoneTypes].Id
  left join [dbo].[LiveAddress] on [Applicants].Id=[LiveAddress].[applicant_id]
  left join [dbo].[Buildings] on [LiveAddress].building_id=[Buildings].Id
  left join [dbo].[Districts] on [Buildings].district_id=Districts.Id
  left join [dbo].[Streets] on [Buildings].street_id=[Streets].Id
  left join StreetTypes on StreetTypes.Id = Streets.street_type_id
  left join [dbo].[ApplicantTypes] on [Applicants].applicant_type_id=[ApplicantTypes].Id
  left join [dbo].[CategoryType] on [Applicants].category_type_id=[CategoryType].Id
  left join [dbo].[ApplicantPrivilege] on [Applicants].applicant_privilage_id=[ApplicantPrivilege].Id
  left join [dbo].[SocialStates] on [Applicants].social_state_id=[SocialStates].Id

 
  where #filter_columns#
--   order by [Applicants].[registration_date]
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only