select top 1 Applicants.Id
	,Applicants.mail as answer_mail
	,ap.phone_number  as answer_phone
	,concat(sty.shortname, ' ', st.name, ' буд. ' + b.number , ' кв. ' + la.flat) as answer_post
	from Applicants 
	left join ApplicantPhones as ap on ap.applicant_id = Applicants.Id
	left join LiveAddress as la on la.applicant_id =  Applicants.Id
	left join Buildings as b on b.Id = la.building_id
	left join Streets as st on st.Id = b.street_id
	left join StreetTypes as sty on sty.Id = st.street_type_id
where Applicants.id = @id_con
	and ap.IsMain = 1
	and la.main = 1
	and la.active = 1