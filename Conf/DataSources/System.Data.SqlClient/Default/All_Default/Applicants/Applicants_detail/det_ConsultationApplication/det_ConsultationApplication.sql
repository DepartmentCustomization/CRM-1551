  select [Consultations].id ConsultationsId
		 ,[Consultations].phone_number
		 ,[ConsultationTypes].name ConsultationType
		 ,[Events].Id EventId
		 ,[Events].name EventsName
		 ,[Consultations].[registration_date]
  --from [CRM_1551_Analitics].[dbo].[Applicants]
  --left join [CRM_1551_Analitics].[dbo].[Appeals] on [Applicants].Id=[Appeals].applicant_id
  --left join [CRM_1551_Analitics].[dbo].[Consultations] on [Appeals].Id=[Consultations].appeal_id

  from [dbo].[Consultations]
  left join [dbo].[Appeals] on [Appeals].id =  Consultations.appeal_id
  left join Applicants on Applicants.Id = Appeals.applicant_id
  left join [dbo].[ConsultationTypes] on [Consultations].consultation_type_id=[ConsultationTypes].Id
  left join [dbo].[Events] on [Consultations].event_id=[Events].Id


  where [Applicants].id =@ApplicantsId
  and 
    #filter_columns#
     #sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only