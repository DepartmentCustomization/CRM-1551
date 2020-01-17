 declare @step nvarchar(50)=N'delete_organization';
 
  exec [dbo].[Calc_OrganizationInResponsibilityRights_byOrganization]  @Id, @user_id
  exec [dbo].[ak_UpdateOrganizationsQuestionsTypeAndParent] @step, @Id
  
  update [dbo].[Organizations] set active = 0  where Id =@Id
  
  /*
  delete 
  from [CRM_1551_Analitics].[dbo].[Organizations]
 where id =@Id
   */
  
--   delete
--   from [CRM_1551_Analitics].[dbo].[OrganizationInResponsibility]
--   where organization_id=@Id
  
  
