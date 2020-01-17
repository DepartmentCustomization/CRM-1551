
--declare @applicant_id int =1490259;

select [Applicants].Id
, [Applicants].full_name
, ApplicantPhonesMain.phone_number
, ApplicantPhonesMain.PhoneType
, ApplicantPhonesMain.phone_type_id

, ApplicantPhonesNotMain.phone_number phone_number2
, ApplicantPhonesNotMain.PhoneType PhoneType2
, ApplicantPhonesNotMain.phone_type_id phone_type_id2

, [Applicants].mail
, [Districts].name DistrictsName
    , [Districts].Id district_id
-- , [Streets].name StrictName
,concat(StreetTypes.shortname,' ', [Streets].[name]) as StrictName
,[Streets].Id StrictId
, 

case when [Buildings].street_id is not null then N'вул. '+[Streets].name else N'' end+
  case when [Buildings].name is not null then N', буд. '+[Buildings].name else N'' end 

 as building_name
, Buildings.Id  as building_id  





   -- , case when StreetTypes.shortname is not null then StreetTypes.shortname+N' ' else N'' end+ 
	  --case when Streets.name is not null then Streets.name+N' ' else N'' end+ 
	  --case when Buildings.number is not null then ltrim(Buildings.number)+N' ' else N'' end+
	  --case when Buildings.letter is not null then Buildings.letter else N'' end as building_name

, [LiveAddress].house_block
, [LiveAddress].entrance
, [LiveAddress].flat
, [ApplicantTypes].name ApplicantType
    , [ApplicantTypes].Id applicant_type_id
, [CategoryType].name Category
    , [CategoryType].Id category_type_id
, [ApplicantPrivilege].Name Privilege
    , [ApplicantPrivilege].Id applicant_privilage_id
, [SocialStates].name [SocialStates]
    , [SocialStates].Id social_state_id
, [Applicants].sex
, [Applicants].birth_date,
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
 else null end day_month
, [Applicants].comment
, [ApplicantPhonesMain].phone_number_norm
  from [dbo].[Applicants]

  left join 
  (select [ApplicantPhones].[Id], [phone_number] [phone_number_norm]
      ,N'('+left([phone_number],3)+N')'+substring([phone_number],4,3)+N'-'+substring([phone_number],7,2)+N'-'+substring([phone_number],9,2) [phone_number]
	  ,[ApplicantPhones].[applicant_id]
	  ,[PhoneTypes].name [PhoneType]
	  ,[PhoneTypes].Id phone_type_id
from [CRM_1551_Analitics].[dbo].[ApplicantPhones]
left join [CRM_1551_Analitics].[dbo].[PhoneTypes] on [ApplicantPhones].phone_type_id=[PhoneTypes].Id
where [ApplicantPhones].[IsMain]=N'true') ApplicantPhonesMain on [Applicants].Id=ApplicantPhonesMain.applicant_id

left join 
  (select [ApplicantPhones].[Id]
      ,N'('+left([phone_number],3)+N')'+substring([phone_number],4,3)+N'-'+substring([phone_number],7,2)+N'-'+substring([phone_number],9,2) [phone_number]
	  ,[ApplicantPhones].[applicant_id]
	  ,[PhoneTypes].name [PhoneType]
	  ,[PhoneTypes].Id phone_type_id
from [CRM_1551_Analitics].[dbo].[ApplicantPhones]
left join [CRM_1551_Analitics].[dbo].[PhoneTypes] on [ApplicantPhones].phone_type_id=[PhoneTypes].Id
where [ApplicantPhones].Id in (select max(Id) max_id
  from [CRM_1551_Analitics].[dbo].[ApplicantPhones]
  where IsMain=N'false'
  group by [applicant_id])) ApplicantPhonesNotMain on [Applicants].Id=ApplicantPhonesNotMain.applicant_id

  --left join [dbo].[ApplicantPhones] on [Applicants].Id=[ApplicantPhones].applicant_id
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
 
  where [dbo].[Applicants].Id=@applicant_id


