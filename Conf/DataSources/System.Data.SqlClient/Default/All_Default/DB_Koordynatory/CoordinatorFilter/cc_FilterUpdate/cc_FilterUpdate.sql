update [CRM_1551_Analitics].[dbo].[FiltersForControler]
  set [user_id]=@user_id
      ,[district_id]=@district_id
      ,[questiondirection_id]=@questiondirection_id
  where Id=@id