select	0 Id, 
		N'Всього подано звернень' [Name], 
		CountQuestion as [count_question], 
		CountQuestionPre as [count_question_pre], 
		ltrim([Percent])+N'%' [percent]
 from [CRM_1551_Site_Integration].[dbo].[Statistics_TopQuestions_30days]
 where QuestionTypeId=0

 and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 