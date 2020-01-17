if (select edit_date from Assignments where Id = @assigment_id ) = @edit_date_form
begin
	select 1 as checkDate
end
else
begin 
	select 0  as checkDate
end