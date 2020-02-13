

UPDATE [dbo].[Questions]
	SET event_id = @event_id
	,[edit_date]=GETUTCDATE()
      ,[user_edit_id]=@user_id
WHERE Id = @question_id AND  [registration_number]>
(SELECT [registration_date] FROM [dbo].[Events] WHERE Id=@event_id);