select b.Id, st.name+N' '+ s.name+N', '+b.name full_name
from Buildings b
left join Streets s on s.Id = b.street_id
left join StreetTypes st on st.Id = s.street_type_id
    where
    #filter_columns#
    #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only