select [PositionsHelpers].Id, [PositionsHelpers].[main_position_id], [Positions1].name main_position_name,
  [PositionsHelpers].helper_position_id, [Positions2].name helper_position_name,
  1 [type_id], N'помічник' [type_name],
  [PositionsHelpers].[edit_date], [User].UserName
  from [CRM_1551_Analitics].[dbo].[PositionsHelpers]
  left join [CRM_1551_Analitics].[dbo].[Positions] [Positions1] on [PositionsHelpers].[main_position_id]=[Positions1].Id
  left join [CRM_1551_Analitics].[dbo].[Positions] [Positions2] on [PositionsHelpers].[helper_position_id]=[Positions2].Id
  left join [CRM_1551_System].[dbo].[User] on [PositionsHelpers].user_id=[User].UserId
  where [PositionsHelpers].Id=@id