IF (select assignment_state_id from Assignments where current_assignment_consideration_id = (
	select id from AssignmentConsiderations where id = (
		select assignment_сons_id from AssignmentConsDocuments where id = (
			select assignment_cons_doc_id FROM [dbo].[AssignmentConsDocFiles] where Id= @Id) )  ) ) = 5
	BEGIN 
		return
	END
	else
	BEGIN
		 delete FROM [dbo].[AssignmentConsDocFiles] where Id = @Id
	END





--  delete
--   FROM [dbo].[AssignmentConsDocFiles]
--   where Id = @Id