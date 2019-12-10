insert into [CRM_1551_Bot_Integration].[dbo].[BotPollItem]
  (
  [name]
      ,[active]
      ,[role_id]
      ,[poll_item_direction_id]
  )

  select @name, @active, @role_id, @poll_item_direction_id