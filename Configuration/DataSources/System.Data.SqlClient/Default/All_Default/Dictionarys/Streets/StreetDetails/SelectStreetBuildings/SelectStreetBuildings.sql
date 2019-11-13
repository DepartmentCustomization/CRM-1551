select st.name + ' ' + s.name + ', ' + b.name bName,
case when b.is_active = 1 then 'Активний' else 'Не активний' end activity,
case when b.is_urbio_new = 1 then 'Так' else 'Ні' end urbio_new, b.Id as bId
from Streets s 
join StreetTypes st on st.Id = s.street_type_id
join Buildings b on s.Id = b.street_id
join [Objects] o on b.Id = o.builbing_id

where s.Id = @Id and o.object_type_id = 1
and
#filter_columns#
order by 1
offset @pageOffsetRows rows fetch next @pageLimitRows rows only