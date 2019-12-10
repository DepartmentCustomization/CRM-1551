-- declare @OrganisationId int = 6;

Select 
qt.Id,
qt.[name] questionType 

from Organizations o 
join ExecutorInRoleForObject exo on o.Id = exo.executor_id
join RulesForExecutorRole r on r.executor_role_id = exo.executor_role_id
join QuestionTypes qt on qt.rule_id = r.rule_id

where o.Id = @OrganisationId
and #filter_columns#
    #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only