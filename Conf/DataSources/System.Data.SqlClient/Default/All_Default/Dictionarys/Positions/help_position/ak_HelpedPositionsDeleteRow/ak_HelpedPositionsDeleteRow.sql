declare @m_positionId int = (select top 1 [main_position_id] from [dbo].[PositionsHelpers] where Id = @Id)
declare @h_positionId int = (select top 1 [helper_position_id] from [dbo].[PositionsHelpers] where Id = @Id)


delete
from [dbo].[PositionsHelpers]
where id=@Id


exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @m_positionId, @user_id
exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @h_positionId, @user_id 
 