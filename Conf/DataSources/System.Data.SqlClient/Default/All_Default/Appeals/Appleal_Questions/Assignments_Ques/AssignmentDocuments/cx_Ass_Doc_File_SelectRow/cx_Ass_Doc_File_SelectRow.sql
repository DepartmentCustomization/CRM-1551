
-- SELECT [Id]
--       ,[assignment_cons_doc_id]
--       ,[link]
--       ,[create_date]
--       ,[user_id]
--       ,[edit_date]
--       ,[user_edit_id]
--       ,[name]
--       ,[File]
--   FROM [dbo].[AssignmentConsDocFiles]
--   where Id = @Id


--declare @Id int = 1148

  if (SELECT isnull(IsArchive,0) FROM [dbo].[AssignmentConsDocFiles] WHERE Id = @Id) = 1
begin
	declare @PathToArchive nvarchar(max) = (SELECT PathToArchive FROM [dbo].[AssignmentConsDocFiles] WHERE Id = @Id)
	declare @SqlText nvarchar(max)
	set @SqlText = N'
				 SELECT TOP 1 [Id]
                            ,[assignment_cons_doc_id]
                            ,[link]
                            ,[create_date]
                            ,[user_id]
                            ,[edit_date]
                            ,[user_edit_id]
                            ,[name]
                            ,[File]
				 FROM ['+@PathToArchive+'].[dbo].[AssignmentConsDocFiles]
				 WHERE Id = '+rtrim(@Id)+'
				'
	exec sp_executesql  @SqlText
end
else
begin
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
	WHERE Id = @Id
end
