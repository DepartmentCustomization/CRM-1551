select a.Id, a.registration_date, a.phone_number, 
  a.applicant_name, a.applicant_address, a.marital_status_id, a.sex, a.age,
  a.education_id, a.applicant_privilage_id, a.guidance_kind_id,
  a.offender_name, a.service_content, a.comment
  from [Appeals] a
  where a.Id=@Id