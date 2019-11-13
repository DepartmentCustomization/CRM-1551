select id, name
from Streets 
   WHERE district_id = @district_id
   and
    #filter_columns#
    --#sort_columns#
    order by 2
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only