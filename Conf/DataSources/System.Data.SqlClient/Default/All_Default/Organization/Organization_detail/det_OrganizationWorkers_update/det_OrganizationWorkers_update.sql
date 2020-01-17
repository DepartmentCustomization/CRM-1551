update [CRM_1551_Analitics].[dbo].[Workers]
set
[organization_id]=@organization_id
      ,[roles_id]=@roles_id
      ,[name]=@name
      ,[phone_number]=@phone_number
      ,[position]=@position
      ,[active]=@active
      ,[worker_user_id]=@worker_user_id
      --,[login]=@login
      --,[password]=@password
      --,[user_id]=@user_id
      --,[registration_date]=@registration_date
      ,[edit_date]=getdate()
      ,[user_edit_id]=@user_id

where id =@Id