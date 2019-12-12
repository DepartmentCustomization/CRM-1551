--declare @phone_number nvarchar(10)=N'1234';

  select a.Id, a.phone_number, a.applicant_name, g.name guidance_kind_name,
  a.offender_name
  from [Appeals] a
  left join [GuidanceKinds] g on a.guidance_kind_id=g.Id
  where phone_number=@phone_number
  and 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only