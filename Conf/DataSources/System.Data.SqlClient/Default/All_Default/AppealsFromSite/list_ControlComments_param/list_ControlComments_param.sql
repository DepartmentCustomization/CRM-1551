select --Id, 
[name]
  from [dbo].[ControlComments]
  where 
  --[control_type_id]=4 and 
  Id=@Id
--   and 
--   #filter_columns#
--   --#sort_columns#
--   order by name
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only