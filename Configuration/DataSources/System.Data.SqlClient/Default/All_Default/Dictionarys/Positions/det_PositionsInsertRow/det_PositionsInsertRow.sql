insert [CRM_1551_Analitics].[dbo].[OrganizationInResponsibility]
  (
       [position_id]
      ,[organization_id]
      ,[onform]
      ,[editable]
      ,[edit_date]
      ,[user_id]
  )
  select @position_id, @organization_id, 1, 0, getutcdate(), @user_id