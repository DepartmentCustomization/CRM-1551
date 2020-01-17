 --declare @Id int =234113;

--   select [QuestionDocuments].Id, [QuestionDocuments].name QuestionDocumentName
--   , [Questions].Id Questions_Id
--   from [QuestionDocuments]
--   inner join [Questions] on [QuestionDocuments].question_id=[Questions].Id
--   inner join [Assignments] on [Assignments].question_id=[Questions].Id
--   where [Assignments].Id=@Id

-- SELECT 
-- 	   [QuestionDocuments].[Id]
--       ,[QuestionDocuments].[name] QuestionDocumentName
-- 	  ,[QuestionDocFiles].name [FileName]
-- 	  ,[QuestionDocFiles].create_date
--   FROM [dbo].[QuestionDocuments]
--   inner join [QuestionDocFiles] on [QuestionDocFiles].question_doc_id=[QuestionDocuments].Id
--   where [QuestionDocuments].[question_id] = @Id
  
  SELECT 
	   [QuestionDocFiles].[Id]
	  ,[QuestionDocFiles].name
	  ,[QuestionDocFiles].File 
	  ,[QuestionDocFiles].create_date
  FROM [dbo].[QuestionDocFiles]
  where [QuestionDocFiles].[question_id] = @Id
  and #filter_columns#
  #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
