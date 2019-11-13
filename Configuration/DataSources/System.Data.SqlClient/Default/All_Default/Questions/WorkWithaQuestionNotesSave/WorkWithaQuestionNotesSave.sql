 update Questions 
    set operator_notes = @notes
	,edit_date = GETUTCDATE()
	,user_edit_id = @user_id
    where Id = @que_id



-- if (@notes not null and @que_id not null)
-- begin
--     update Questions 
--     set operator_notes = @notes
--     where Id = @que_id
--  end