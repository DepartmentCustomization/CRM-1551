UPDATE [dbo].[AppealsFromSite]
     SET    
           [site_appeals_states_id]= @state_id
           ,[comment_moderator]= @comment_moderator
           ,[edit_date] = GETUTCDATE()
           ,[user_edit_id]= @user_edit_id
		   WHERE Id = @Id