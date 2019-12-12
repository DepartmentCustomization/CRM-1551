select a.Id, a.applicant_name, a.phone_number, g.name GuidanceKinds_name, a.offender_name, a.service_content
  from [Appeals] a
  left join [GuidanceKinds] g on a.guidance_kind_id=g.Id
  where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only