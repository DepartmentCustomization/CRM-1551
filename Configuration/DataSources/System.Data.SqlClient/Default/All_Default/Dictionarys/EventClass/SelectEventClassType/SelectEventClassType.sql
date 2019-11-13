select Id, name as eventClassType
from EventTypes
where #filter_columns#
 order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only