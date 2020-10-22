update [dbo].[ControlComments]

set [name]=@name
      ,[control_type_id]=@control_type_id
      --,[user_id]=@user_id
      --,[create_date]
      ,[user_edit_id]=@user_id
      ,[edit_date]=getutcdate()
      ,[template_name]=@template_name
where Id=@Id