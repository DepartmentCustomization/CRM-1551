delete from ExecutorInRoleForObject
where object_id = @Id;

delete from LiveAddress
where building_id = @Id;

delete from [Objects] 
where builbing_id = @Id;

delete from [Buildings]
output deleted.name as delName
where Id = @Id;