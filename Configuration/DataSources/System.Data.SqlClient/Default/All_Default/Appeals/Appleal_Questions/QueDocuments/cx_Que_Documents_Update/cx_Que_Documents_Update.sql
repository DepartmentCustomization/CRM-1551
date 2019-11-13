update [dbo].[QuestionDocuments]
         set [doc_type_id] = @doc_type_id
           ,[name] = @name
           ,[content] = @content
           ,[edit_user_id] = @edit_user_id
           ,[edit_date] = getutcdate()
	where Id = @Id