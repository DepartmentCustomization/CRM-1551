





declare @is_exe int;

if (select first_executor_organization_id from AssignmentConsiderations where Id = 
					(select current_assignment_consideration_id from Assignments where Id = @Id)) <> 
	(select organization_id /*executor_organization_id*/ from Assignments where Id = @Id)
	begin 
		select @is_exe = 0 
	end
else
	begin
		select @is_exe = 1
	end
		
select @is_exe as is_exe
