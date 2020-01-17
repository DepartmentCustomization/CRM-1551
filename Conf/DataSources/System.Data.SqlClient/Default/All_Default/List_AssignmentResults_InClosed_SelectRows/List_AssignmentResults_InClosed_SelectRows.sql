

if (select count(1)
from [dbo].[Questions]
inner join [dbo].[QuestionStates] on [QuestionStates].Id =  [Questions].[question_state_id]
inner join [dbo].[Assignments] on [Assignments].Id =  [Questions].[last_assignment_for_execution_id]
inner join [dbo].[AssignmentConsiderations] on [AssignmentConsiderations].Id =  [Assignments].[current_assignment_consideration_id]
inner join [dbo].[AssignmentRevisions] on [AssignmentRevisions].assignment_consideration_іd =  [AssignmentConsiderations].[Id]
where [Questions].[Id] = @QuestionId
	and [Questions].[question_state_id] = 3	/*На перевірці*/
and [Assignments].[AssignmentResultsId] in (SELECT [Id] FROM [dbo].[AssignmentResults]  where code in ( N'WasExplained', N'Done', N'ItIsNotPossibleToPerformThisPeriod')) /*Роз"яснено, Виконано, Не можливо виконати в данний період.*/
) > 0
begin
    SELECT [Id]
          ,[name] as Name
      FROM [dbo].[AssignmentResults]
        WHERE code in (N'Done' , N'Independently', N'ForWork', N'Cancel')
        and
    	#filter_columns#
         #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only
end
else
begin
    SELECT [Id]
          ,[name] as Name
      FROM [dbo].[AssignmentResults]
        WHERE code in (N'Done' , N'Independently', N'Cancel')
        and
    	#filter_columns#
         #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only
end