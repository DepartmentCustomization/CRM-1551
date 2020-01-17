select qgqt.Id as Id, qt.name as typeName 
from QGroupIncludeQTypes qgqt
join QuestionGroups qg on qgqt.group_question_id = qg.Id
join QuestionTypes qt on qt.Id = qgqt.type_question_id
where group_question_id = @Id and
    #filter_columns#
    #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only