 select Id, Name
 from [Educations]
 where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 --cvncx