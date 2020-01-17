select Id, name
from (
select Id, name
  from [QuestionTypes]) w
   where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
