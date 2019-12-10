select [QuestionDocFiles].[Id],
	   [QuestionDocFiles].[question_id],
	   [Questions].[registration_number],
	   [QuestionDocFiles].[link],
	   [QuestionDocFiles].[create_date]
from [CRM_1551_Analitics].[dbo].[QuestionDocFiles]
left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[Id] = [QuestionDocFiles].[question_id]
where [QuestionDocFiles].[link] is not null and #filter_columns#
order by [QuestionDocFiles].[Id]
offset @pageOffsetRows rows fetch next @pageLimitRows rows only
