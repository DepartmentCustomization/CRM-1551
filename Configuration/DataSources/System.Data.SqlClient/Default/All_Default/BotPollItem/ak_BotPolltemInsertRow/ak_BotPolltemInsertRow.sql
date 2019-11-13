insert into [Bot_Intagration].[dbo].[BotPollItem]
  (
  [name]
      ,[active]
      ,[role_id]
      ,[poll_item_direction_id]
  )

  select @name, @active, @role_id, @poll_item_direction_id