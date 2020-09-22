UPDATE
       [dbo].[Complain]
SET
       [complain_type_id] = @complain_type_id,
       [culpritname] = @culpritname,
       -- [guilty] = @guilty,
       [text] = @text,
       [complain_state_id] = @complain_state_id,
       [revision_comment] = @revision_comment,
       [edit_date] = GETUTCDATE(),
       [user_edit_id] = @user_edit_id
WHERE
       Id = @Id ;