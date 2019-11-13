SELECT [AssignmentConsDocuments].[Id]
      ,[AssignmentConsDocuments].[assignment_сons_id]
      ,DocumentTypes.Id as doc_type_id
      ,DocumentTypes.name as doc_type_name
      ,[AssignmentConsDocuments].[name]
      ,[AssignmentConsDocuments].[content]
      ,[AssignmentConsDocuments].[add_date]
      ,[AssignmentConsDocuments].[user_id]
      ,[AssignmentConsDocuments].[edit_date]
      ,[AssignmentConsDocuments].[user_edit_id]
  FROM [dbo].[AssignmentConsDocuments]
	left join DocumentTypes on DocumentTypes.Id = [AssignmentConsDocuments].doc_type_id
where  [AssignmentConsDocuments].[Id] = @Id