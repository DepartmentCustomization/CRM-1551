--declare @Id int=1;

select a.Id, a.Id Appeal_Id, a.registration_date, a.phone_number, a.applicant_needs,
  a.applicant_name, a.applicant_address, 
  a.marital_status_id, m.name marital_status_name,
  a.sex sex_id, case when a.sex=1 then N'Жінка' when a.sex=2 then N'Чоловік' end sex_name, a.age,
  a.education_id, e.name education_name,
  a.applicant_privilage_id, p.name applicant_privilage_name,
  a.guidance_kind_id, g.name guidance_kind_name,
  a.offender_name, a.service_content, a.comment
  from [Appeals] a
  left join [Educations] e on a.education_id=e.Id
  left join [ApplicantPrivilages] p on a.applicant_privilage_id=p.Id
  left join [GuidanceKinds] g on a.guidance_kind_id=g.Id
  left join [MaritalStatuses] m on a.marital_status_id=m.Id
  where a.Id=@Appeals_Id