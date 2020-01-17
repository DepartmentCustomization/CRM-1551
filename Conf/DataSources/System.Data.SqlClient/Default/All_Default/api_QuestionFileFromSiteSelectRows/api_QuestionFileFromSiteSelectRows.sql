select [QuestionDocFiles].Id as [QuestionFileId], 
	   [QuestionDocFiles].name  as [QuestionFileName], 
	   [QuestionDocFiles].[File] as [QuestionFile]
  from  [CRM_1551_Analitics].[dbo].[Questions]
--   inner join [CRM_1551_Analitics].[dbo].[QuestionDocuments] on [QuestionDocuments].question_id=[Questions].Id  
  inner join [CRM_1551_Analitics].[dbo].[QuestionDocFiles] on [QuestionDocFiles].question_id=[Questions].Id
  where [Questions].appeal_id=@appeal_id
--   and #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only