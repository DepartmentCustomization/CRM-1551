
update [dbo].[QuestionDocFiles]
set
    [question_doc_id] = @question_doc_id,
    [Name] = @Name,
    [File] = @File,
    [edit_date] = getutcdate(),
    [edit_user_id] = @edit_user_id 
where
    [Id] = @Id