--declare @Id int=1;

  select [Id], [name], [active], [role_id], [poll_item_direction_id]
  from [CRM_1551_Bot_Integration].[dbo].[BotPollItem]
  where Id=@Id