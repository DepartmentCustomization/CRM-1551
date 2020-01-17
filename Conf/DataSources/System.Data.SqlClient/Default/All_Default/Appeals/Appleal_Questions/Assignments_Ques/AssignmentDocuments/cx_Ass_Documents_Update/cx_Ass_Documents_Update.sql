if @ass_status = 5 
begin
    return
end
else
begin

update [dbo].[AssignmentConsDocuments]
         set [doc_type_id] = @doc_type_id
           ,[name] = @name
           ,[content] = @content
           ,[user_edit_id] = @user_edit_id
           ,[edit_date] = getutcdate()
	where Id = @Id
end