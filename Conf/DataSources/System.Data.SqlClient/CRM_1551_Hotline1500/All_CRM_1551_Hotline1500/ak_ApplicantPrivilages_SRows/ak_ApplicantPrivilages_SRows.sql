 select Id, name
 from [ApplicantPrivilages]
 where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only