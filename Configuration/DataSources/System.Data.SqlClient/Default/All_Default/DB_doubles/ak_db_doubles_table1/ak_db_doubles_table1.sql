

--обновляется [ApplicantDublicate] на true, если один заявитель

update [ApplicantDublicate]
  set [ApplicantDublicate].IsDone='true'
  from [ApplicantDublicate] inner join
  (
  select replace([phone_number], N'+38', N'') [Phone_number], 
  count(distinct applicant_id) Count_applicants
  from [ApplicantPhones]
  group by replace([phone_number], N'+38', N'')
  having count(distinct applicant_id)<=1) p on [ApplicantDublicate].PhoneNumber=p.Phone_number
  where [ApplicantDublicate].IsDone='false'


/*в одного applicant_id несколько одинаковых номеров*/

select ad.Id, t.Phone_number, t.Count_applicants
  from [ApplicantDublicate] ad inner join 
  (
  select replace([phone_number], N'+38', N'') [Phone_number], 
  count(distinct applicant_id) Count_applicants
  from [ApplicantPhones]
  group by replace([phone_number], N'+38', N'')
  having count(distinct applicant_id)>1) t on ad.PhoneNumber=t.phone_number
  where ad.IsDone='false'