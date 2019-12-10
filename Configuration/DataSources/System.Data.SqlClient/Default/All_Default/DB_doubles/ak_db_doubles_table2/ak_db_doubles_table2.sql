--declare @phone_number nvarchar(50)=(select [PhoneNumber] from [ApplicantDublicate] where id=@Id)

  select distinct [Applicants].Id, replace([ApplicantPhones].[phone_number], N'+38', N'') [Phone_number], [Applicants].full_name Full_name, isnull(StreetTypes.shortname+N' ', N'')+isnull(Streets.name+N'. ', N'')+isnull(Buildings.name, N'') Address,
  case
  when [Applicants].birth_date is null and [Applicants].birth_year is null then null
  when [Applicants].birth_date is null and [Applicants].birth_year is not null then YEAR(getdate())-[Applicants].birth_year+1
  when month([Applicants].birth_date)*100+day([Applicants].birth_date)<month(getdate())*100+day(getdate()) then YEAR(getdate())-[Applicants].birth_year+1
  when month([Applicants].birth_date)*100+day([Applicants].birth_date)>=month(getdate())*100+day(getdate()) then YEAR(getdate())-[Applicants].birth_year
  end Years, 
  [SocialStates].name SocialState, [ApplicantPrivilege].Name Privilege
  from [ApplicantPhones]
  inner join [ApplicantDublicate] on replace([ApplicantPhones].[phone_number], N'+38', N'')=[ApplicantDublicate].PhoneNumber
  inner join [Applicants] on [ApplicantPhones].applicant_id=[Applicants].Id
  left join [LiveAddress] on [Applicants].Id=[LiveAddress].applicant_id
  left join [Buildings] on [LiveAddress].[building_id]=[Buildings].id
  left join [Streets] on [Buildings].street_id=[Streets].Id
  left join [StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  left join [SocialStates] on [Applicants].social_state_id=[SocialStates].Id
  left join [ApplicantPrivilege] on [Applicants].[applicant_privilage_id]=[ApplicantPrivilege].Id
  where [ApplicantDublicate].Id=@Id