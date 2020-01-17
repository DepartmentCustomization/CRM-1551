-- declare @building_id int = 7702;

select top 1
d.Id,
d.[name],
o.[short_name] as execOrg

from Streets s 
join Buildings b on b.street_id = s.Id 
join Districts d on d.Id = s.district_id
left join [Objects] obj on obj.builbing_id = b.Id 
left join ExecutorInRoleForObject exo on exo.[object_id] = obj.Id 
left join Organizations o on o.Id = exo.executor_id
where b.Id = @building_id
and o.organization_type_id in (3,6,7,11)
order by organization_type_id desc