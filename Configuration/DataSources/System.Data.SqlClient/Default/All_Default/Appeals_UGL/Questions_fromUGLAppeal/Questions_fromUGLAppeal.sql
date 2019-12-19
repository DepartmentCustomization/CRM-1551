--declare @appealId int = 5398614;

select 
q.Id, 
q.registration_number as questionNum,
qt.[Name] as questionType,
o.[name] as execOrg,
convert(varchar, q.control_date, 120) as controlDate

from Questions q 
left join Assignments ass on ass.question_id = q.Id 
join QuestionTypes qt on q.question_type_id = qt.Id 
join Organizations o on ass.executor_organization_id = o.Id 
where ass.main_executor = 1
and q.appeal_id = @appealId
-- and #filter_columns#
-- offset @pageOffsetRows rows fetch next @pageLimitRows rows only
