insert into QGroupIncludeQTypes (group_question_id, type_question_id)
output [inserted].[Id]
values ((select Id from QuestionGroups where name = @groupName), @typeName);
