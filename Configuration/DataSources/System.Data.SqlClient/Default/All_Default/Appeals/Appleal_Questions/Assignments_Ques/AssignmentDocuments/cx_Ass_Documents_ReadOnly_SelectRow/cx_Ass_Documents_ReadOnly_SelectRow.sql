SELECT 
	   [AssignmentConsDocuments].[Id]
      ,dt.id as doc_type_id
      ,dt.name as doc_type_name
      ,[AssignmentConsDocuments].[add_date]
      ,[AssignmentConsDocuments].[name]
	  ,[AssignmentConsDocuments].content
  FROM [dbo].[AssignmentConsDocuments]
	left join DocumentTypes dt on dt.Id = [AssignmentConsDocuments].doc_type_id
  where [AssignmentConsDocuments].[Id] = @Id
