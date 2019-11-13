update [Bot_Intagration].[dbo].[BotPollItem]
  set [name]= @name
      ,[active]= @active
      ,[role_id]= @role_id
      ,[poll_item_direction_id]= @poll_item_direction_id
  where Id=@Id