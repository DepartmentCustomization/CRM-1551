-- declare @applicantId int = 1515873;

declare @numbers table (num nvarchar(15));
insert into @numbers
select phone_number from ApplicantPhones where applicant_id = @applicantId

update @numbers set num = replace(num,' ', '')

update @numbers
set num = 
case 
  when len(num) > 10 then 
case 
when (LEFT(num, 2) = '38') then RIGHT(num, len(num)-2)
when (LEFT(num, 1) = '3') and (LEFT(num, 2) <> '38') then RIGHT(num, len(num)-1)
when (LEFT(num, 1) = '8') then RIGHT(num, len(num)-1)
 end 
  when len(num) < 10 AND (LEFT(num, 1) != '0') then N'0' + num 
  else num
end


declare @phone_qty int = (select count(1) from @numbers);
declare @step int = 0;
declare @full_phone2 nvarchar(500);
declare @current_phone nvarchar(10);

while (@step < @phone_qty)
begin
set @current_phone = (select num from @numbers ORDER BY num OFFSET @step ROWS FETCH NEXT @step+1 ROWS ONLY);
set @full_phone2 = isnull(@full_phone2,'') + IIF(len(@full_phone2)>1,N', ' + @current_phone, @current_phone)
set @step += 1;
end


select top 1
full_name as Applicant_PIB,
b.Id as buildingId,
st.shortname + ' ' + s.[name] +  isnull(' ' + b.[name],'') buildingName,
house_block as Applicant_HouseBlock,
entrance as Applicant_Entrance,
flat as Applicant_Flat,
d.[name] as Applicant_District,
ap.Id as privilegeId,
ap.[Name] as privilegeName,
ss.Id as socialId,
ss.[name] as socialName,
at.Id as applicantTypeId,
at.[name] as applicantTypeName,
a.sex as Applicant_Sex,
cast(a.birth_date as date) as Applicant_BirthDate,
a.mail as Applicant_Email,
a.comment as Applicant_Comment,
a.Id as ApplicantId,
IIF(
a.birth_date is not null,
year(getdate()) - year(a.birth_date),
null
) as Applicant_Age,
o.[short_name] as execOrg,
@full_phone2 as CardPhone

from Applicants a
left join LiveAddress la on la.applicant_id = a.Id 
left join Buildings b on b.Id = la.building_id
left join Streets s on s.Id = b.street_id
left join StreetTypes st on st.Id = s.street_type_id
left join Districts d on d.Id = s.district_id
left join SocialStates ss on ss.Id = a.social_state_id
left join ApplicantPrivilege ap on ap.Id = a.applicant_privilage_id
left join ApplicantTypes at on at.Id = a.applicant_type_id
left join [Objects] obj on obj.builbing_id = b.Id 
left join ExecutorInRoleForObject exo on exo.[object_id] = obj.Id 
left join Organizations o on o.Id = exo.executor_id

where a.Id = @applicantId 
and ( o.organization_type_id in (3,6,7,11)
or o.organization_type_id is null )
order by organization_type_id desc