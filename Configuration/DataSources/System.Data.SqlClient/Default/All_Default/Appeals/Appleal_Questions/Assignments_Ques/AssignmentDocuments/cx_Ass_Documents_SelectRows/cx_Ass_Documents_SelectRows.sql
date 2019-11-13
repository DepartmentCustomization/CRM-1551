SELECT 
	   [AssignmentConsDocuments].[Id]
      ,dt.name as doc_type_id
      ,[AssignmentConsDocuments].[add_date]
      ,[AssignmentConsDocuments].[name]
  FROM [dbo].[AssignmentConsDocuments]
	left join DocumentTypes dt on dt.Id = [AssignmentConsDocuments].doc_type_id
--   where [AssignmentConsDocuments].[assignment_сons_id] = @Id
  where [AssignmentConsDocuments].[assignment_сons_id] in (select Id from [AssignmentConsiderations] where [assignment_id] = @Id )
 	and #filter_columns#
		#sort_columns#
	offset @pageOffsetRows rows fetch next @pageLimitRows rows only