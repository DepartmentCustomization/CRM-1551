declare @updated table (prevId int);

update Questions 
set [object_id] = (select Id from [Objects] where builbing_id = @building),
[CodeOperation] = N'ChangeFromFormBuilding'
,[edit_date]=GETUTCDATE()
OUTPUT deleted.Id
into @updated
where Id in (
select distinct q.Id as question
from Questions q
join Assignments ass on ass.question_id = q.Id
join [Objects] obj on obj.Id = q.[object_id]
join Buildings b on b.Id = obj.builbing_id
join Organizations o on ass.executor_organization_id = o.Id
where b.Id = @Id
);

update EventObjects 
set object_id = (select Id from [Objects] where builbing_id = @building)
where object_id = (select Id from [Objects] where builbing_id = @Id);

update LiveAddress
set building_id = @building
OUTPUT deleted.Id
into @updated
where applicant_id in 
(
select a.Id as applicant
from Applicants a
join LiveAddress la on la.applicant_id = a.Id 
where la.building_id = @Id
);

update ExecutorInRoleForObject
set object_id = (select Id from [Objects] where builbing_id = @building)
-- building_id = @building 
where Id in (select Id from ExecutorInRoleForObject ex where object_id = @Id
);

update ValuesParamsObjects
set object_id = (select Id from [Objects] where builbing_id = @building)
where object_id = (select Id from [Objects] where builbing_id = @Id);

    select * from @updated