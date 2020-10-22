select Id, [name], [template_name]
  from [dbo].[ControlComments]
  where 
   [control_type_id]=4
   and 
  #filter_columns#
  --#sort_columns#
  order by name
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only