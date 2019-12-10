-- declare @rules_id int = 8;

Select 
Id,
[name] as questionType

from QuestionTypes  
where rule_id = @rules_id
and #filter_columns#
    #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only