--declare @applicant_phone nvarchar(max);
--set @applicant_phone = '0574837214, 0674217534, 0951072788, 0970261779'

declare @numbers table (num nvarchar(15));
insert into @numbers
select value from string_split(@applicant_phone, ',');
update @numbers set num = replace(num,' ', '')

select distinct 
applicant.Id as applicantId,
applicant.full_name,
concat(street_type.shortname, N' ', street.name, N' ', 
building.number,isnull(building.letter, null)) as applicant_address,
social.[name] as social_state,
privilege.[Name] as privilege,
phone_number
from ApplicantPhones phone
join Applicants applicant on applicant.Id = phone.applicant_id
left join LiveAddress live on live.applicant_id = applicant.Id
left join Buildings building on building.Id = live.building_id
left join Streets street on street.Id = building.street_id
left join StreetTypes street_type on street_type.Id = street.street_type_id
left join SocialStates social on social.Id = applicant.social_state_id
left join ApplicantPrivilege privilege on privilege.Id = applicant.applicant_privilage_id

where 
phone_number 
in (select num from @numbers)  