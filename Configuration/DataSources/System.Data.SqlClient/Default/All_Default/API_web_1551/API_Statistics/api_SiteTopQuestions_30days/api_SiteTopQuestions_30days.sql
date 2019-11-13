select  [Statistics_TopQuestions_30days].QuestionTypeId Id, 
		[QuestionTypes].name QuestionTypes_Name, 
		[Statistics_TopQuestions_30days].CountQuestion as count_question, 
        [Statistics_TopQuestions_30days].CountQuestionPre as count_question_pre, 
		ltrim([Statistics_TopQuestions_30days].[Percent])+N'%' [percent]
  from [CRM_1551_Site_Integration].[dbo].[Statistics_TopQuestions_30days]
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Statistics_TopQuestions_30days].QuestionTypeId = [QuestionTypes].Id
  where [Statistics_TopQuestions_30days].QuestionTypeId<>0
--   and #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
