SELECT [Id]
      ,[assignment_cons_doc_id]
      ,[link]
      ,[create_date]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
      ,[name]
      ,[File]
  FROM [dbo].[AssignmentConsDocFiles]
  where [assignment_cons_doc_id] = @Id
  and #filter_columns#
-- 		#sort_columns#
		order by 1
	offset @pageOffsetRows rows fetch next @pageLimitRows rows only