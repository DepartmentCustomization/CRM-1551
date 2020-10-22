select [Id], [name]
from [dbo].[ControlTypes]
where 
  #filter_columns#
  --#sort_columns#
  order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only