declare @m_positionId int = (select top 1 [main_position_id] from [dbo].[PositionsHelpers] where Id = @Id)
declare @h_positionId int = (select top 1 [helper_position_id] from [dbo].[PositionsHelpers] where Id = @Id)

exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @m_positionId, @user_id
exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @h_positionId, @user_id 
 
 
  if @type_id=1
  begin
  update [dbo].[PositionsHelpers]
  set [main_position_id]=@main_position_id
  ,helper_position_id=@helper_position_id
  ,[edit_date]=getutcdate()
  ,[user_id]=@user_id
  where Id=@Id
  end

  if @type_id=2
  begin
  update [dbo].[PositionsHelpers]
  set [main_position_id]=@helper_position_id
  ,helper_position_id=@main_position_id
  ,[edit_date]=getutcdate()
  ,[user_id]=@user_id
  where Id=@Id
  end
  
exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @helper_position_id, @user_id
exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @main_position_id, @user_id  