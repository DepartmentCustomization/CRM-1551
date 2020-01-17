select 
o.name oName, 
case when o.is_active = 1 then 'Активний' else 'Не активний' end activity,
case when o.is_urbio_new = 1 then 'Так' else 'Ні' end isUrbio,
o.Id as oId
from Streets s 
join Buildings b on s.Id = b.street_id
join [Objects] o on b.Id = o.builbing_id
join [ObjectTypes] ot on o.object_type_id = ot.Id
where s.Id = @Id and o.object_type_id <> 1
and
#filter_columns#
order by 1
offset @pageOffsetRows rows fetch next @pageLimitRows rows only