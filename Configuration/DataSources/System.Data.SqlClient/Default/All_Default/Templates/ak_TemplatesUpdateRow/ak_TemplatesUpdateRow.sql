update [Templates]
set name=@name
,content=@content
,[user_edit_id]=@user_Id
,[edit_date]=GETUTCDATE()
where Id=@Id