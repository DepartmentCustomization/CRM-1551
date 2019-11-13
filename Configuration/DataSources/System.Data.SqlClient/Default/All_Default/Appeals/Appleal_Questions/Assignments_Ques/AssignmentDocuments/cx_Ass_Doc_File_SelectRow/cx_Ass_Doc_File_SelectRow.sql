
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
  where Id = @Id