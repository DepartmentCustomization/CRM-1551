select Id, name
from
(select 1 id, N'помічник' name
  union all
  select 2 id, N'допомагає' name) a
   where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only