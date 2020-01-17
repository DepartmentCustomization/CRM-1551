declare @parent_orgId int = (select top 1 parent_organization_id from [dbo].[Organizations] where Id=@Id)
declare @orgId int = (select top 1 Id from [dbo].[Organizations] where Id=@Id)


update [CRM_1551_Analitics].[dbo].[Organizations]
  set parent_organization_id=@organization_id,
  organization_type_id=@organization_type_id,
  organization_code=@organization_code,
  short_name=@short_name,
  name=@name,
  phone_number=@phone_number,
  address=@address,
  head_name=@head_name,
  active=@active,
  population=@population,
  --user_id=@user_id,
  edit_date=getdate(),
  user_edit_id=@user_id,
  programworker=@programworker,
  notes=@notes,
  othercontacts=@othercontacts
  where [Organizations].Id=@Id
  
  
  if exists(select Id
  from [CRM_1551_Analitics].[dbo].[OrganizationInResponsibility]
  where [organization_id]=@Id)

  begin
	  update [CRM_1551_Analitics].[dbo].[OrganizationInResponsibility]
	  set position_id=@positions_id
	  where organization_id=@Id
  end
    else
  begin
  insert into [CRM_1551_Analitics].[dbo].[OrganizationInResponsibility]
(
[position_id]
      ,[organization_id]
      ,[onform]
      ,[editable]
      ,[edit_date]
      ,[user_id]
)

select @positions_id, @id, 1, 0, getutcdate(), @user_id;
  end


declare @step nvarchar(50)=N'update_organization';
  
  
  if @organization_id != @parent_orgId
  begin
    exec [dbo].[Calc_OrganizationInResponsibilityRights_byOrganization]  @parent_orgId, @user_id
    exec [dbo].[Calc_OrganizationInResponsibilityRights_byOrganization]  @organization_id, @user_id
    exec [dbo].[Calc_OrganizationInResponsibilityRights_byOrganization]  @orgId, @user_id
  end
  
  exec [dbo].[ak_UpdateOrganizationsQuestionsTypeAndParent] @step, @Id