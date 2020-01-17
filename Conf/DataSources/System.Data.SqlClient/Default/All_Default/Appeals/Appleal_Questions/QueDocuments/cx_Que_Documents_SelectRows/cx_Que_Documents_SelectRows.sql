SELECT 
	   [QuestionDocuments].[Id]
      ,dt.name as doc_type_id
      ,[QuestionDocuments].[add_date]
      ,[QuestionDocuments].[name]
  FROM [dbo].[QuestionDocuments]
	left join DocumentTypes dt on dt.Id = QuestionDocuments.doc_type_id
  where [QuestionDocuments].[question_id] = @Id
	and #filter_columns#
		#sort_columns#
	offset @pageOffsetRows rows fetch next @pageLimitRows rows only