select o.Id, d.name district_name, o.name [object_name]
  from [Objects] o 
  left join [Districts] d on o.district_id=d.Id
  where 
   #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
