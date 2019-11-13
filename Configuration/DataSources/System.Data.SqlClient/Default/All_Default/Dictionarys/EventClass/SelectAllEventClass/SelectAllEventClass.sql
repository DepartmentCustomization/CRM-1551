select id, name, global_id, event_type_id as eventClassType
from Event_Class
where #filter_columns#
 order by 1
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only