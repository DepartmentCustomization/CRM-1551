SELECT [QuestionDocuments].[Id]
      ,[QuestionDocuments].[question_id]
      ,DocumentTypes.Id as doc_type_id
      ,DocumentTypes.name as doc_type_name
      ,[QuestionDocuments].[name]
      ,[QuestionDocuments].[content]
      ,[QuestionDocuments].[add_date]
      ,[QuestionDocuments].[add_user_id]
      ,[QuestionDocuments].[edit_date]
      ,[QuestionDocuments].[edit_user_id]
      ,[QuestionDocuments].[Id] as [QuestionDocumentsId]
  FROM [dbo].[QuestionDocuments]
	left join DocumentTypes on DocumentTypes.Id = [QuestionDocuments].doc_type_id
where  [QuestionDocuments].[Id] = @Id