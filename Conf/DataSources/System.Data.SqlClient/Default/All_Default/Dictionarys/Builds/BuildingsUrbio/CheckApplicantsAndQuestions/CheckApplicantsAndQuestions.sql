declare @question_and_applicant_on_building table (is_have int);
-- Проверю наличие Questions и Applicants по данному Building 
-- Если есть в результат запишу 1, иначе 0
begin 
insert into @question_and_applicant_on_building
select 
case when sub.question + applicant = 0 then 0 else 1 end
from (
select count(q.Id) as question, count(z.applicant) applicant
from Questions q
join Assignments ass on ass.question_id = q.Id
join [Objects] obj on obj.Id = q.[object_id]
join Buildings b on b.Id = obj.builbing_id
join Organizations o on ass.executor_organization_id = o.Id
left join (
select a.Id as applicant
from Applicants a
join LiveAddress la on la.applicant_id = a.Id 
and la.building_id = @Id ) z on 1=1
where b.Id = @Id) sub
end
    select is_have from @question_and_applicant_on_building