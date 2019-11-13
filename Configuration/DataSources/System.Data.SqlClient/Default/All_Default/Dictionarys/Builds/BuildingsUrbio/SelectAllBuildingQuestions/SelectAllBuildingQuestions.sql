select q.Id as question, qs.[name] as [state],
qt.[name] as [type], o.short_name as orgExecutor
from Questions q
join Assignments ass on ass.question_id = q.Id
join QuestionStates qs on q.question_state_id = qs.Id 
join QuestionTypes qt on qt.Id = q.question_type_id
join [Objects] obj on obj.Id = q.[object_id]
join Buildings b on b.Id = obj.builbing_id
join Organizations o on ass.executor_organization_id = o.Id
where b.Id = @Id and main_executor = 1
and #filter_columns#
    #sort_columns#
--offset @pageOffsetRows rows fetch next @pageLimitRows rows only