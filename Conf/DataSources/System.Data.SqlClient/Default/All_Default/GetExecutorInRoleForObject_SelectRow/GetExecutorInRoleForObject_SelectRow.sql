--declare @building_id int = 3677


select top 1 o.short_name
from ExecutorInRoleForObject as eo
left join Organizations as o on o.Id = eo.executor_id
where [executor_role_id] = 1
and eo.object_id = @building_id