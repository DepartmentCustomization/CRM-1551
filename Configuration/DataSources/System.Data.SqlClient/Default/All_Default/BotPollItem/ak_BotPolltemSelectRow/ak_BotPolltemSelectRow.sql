--declare @Id int=1;

  select [Id], [name], [active], [role_id], [poll_item_direction_id]
  from [Bot_Intagration].[dbo].[BotPollItem]
  where Id=@Id