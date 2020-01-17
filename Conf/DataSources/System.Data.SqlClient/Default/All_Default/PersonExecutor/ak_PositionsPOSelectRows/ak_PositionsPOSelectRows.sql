--declare @organization_id int=28;

  select Id, position+N' ('+isnull(name,0)+N')' Name
  from [Positions]
  where organizations_id=@organization_id
  and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
