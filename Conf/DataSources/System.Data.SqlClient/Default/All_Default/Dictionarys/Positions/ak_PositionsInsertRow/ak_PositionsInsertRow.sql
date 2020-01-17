declare @output table (Id int);

insert into [CRM_1551_Analitics].[dbo].[Positions]
  (
  [parent_id]
      ,[position_code]
      ,[position]
      ,[phone_number]
      ,[address]
      ,[name]
      ,[active]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
	  ,[organizations_id]
      ,[role_id]
      ,[programuser_id]
      ,[is_main]
  )
output [inserted].[Id] into @output (Id)

  select
  @parent_id
      ,@position_code
      ,@position
      ,@phone_number
      ,@address
      ,@name
      ,@active
      ,@user_id
      ,GETUTCDATE()
      ,@user_id
	  ,@organization_id
      ,@role_id
      ,@programuser_id
      ,@is_main

	  
declare @org_id int = (select top 1 Id from @output);

insert into [OrganizationInResponsibility]
  ([position_id]
      ,[organization_id]
      ,[onform]
      ,[editable]
      ,[edit_date]
      ,[user_id])

  select 
  @org_id
      ,@organization_id
      ,1
      ,1
      ,getutcdate()
      ,@user_id


exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @org_id, @user_id



	  insert into [CRM_1551_Analitics].[dbo].[Workers]
  (
  [organization_id]
      ,[roles_id]
      ,[name]
      ,[phone_number]
      ,[position]
      ,[active]
      ,[worker_user_id]
      ,[user_id]
      ,[registration_date]
      ,[edit_date]
      ,[user_edit_id]
	  ,[position_id]
  )

  SELECT 
       @organization_id
      ,@role_id
      ,@name
      ,@phone_number
      ,@position
      ,@active
      ,@programuser_id
      ,@user_id
      ,GETUTCDATE()
      ,GETUTCDATE()
      ,@user_id
	  ,(select top 1 Id from @output o)
	  
select @org_id as Id
return;