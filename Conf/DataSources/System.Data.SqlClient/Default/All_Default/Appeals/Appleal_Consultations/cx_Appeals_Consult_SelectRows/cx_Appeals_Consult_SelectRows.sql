SELECT 
	   [Consultations].[Id]
      ,ct.name as consult_type_name
      ,[Consultations].[event_id]
      ,[Consultations].[application_town_id]
      ,[Consultations].[knowledge_base_id]
      ,[Consultations].[registration_date]
  FROM [dbo].[Consultations]
    left join Appeals on Appeals.Id = Consultations.appeal_id
	left join ConsultationTypes ct on ct.Id = Consultations.consultation_type_id
  where Consultations.appeal_id = @id
  and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only