-- declare @t table (Id int)
-- declare @doc_id int

INSERT INTO [dbo].[QuestionDocuments]
           ([question_id]
           ,[doc_type_id]
           ,[name]
           ,[content]
           ,[add_date]
           ,[add_user_id]
          ,[edit_date]
           ,[edit_user_id]
           )
-- output inserted.Id into @t(Id)
output [inserted].[Id]
     VALUES
           (@question_id
           ,@doc_type_id
           ,@name
           ,@content
           ,getutcdate()
           ,@add_user_id
          ,getutcdate()
           ,@edit_user_id)
           
-- set @doc_id = (select top 1 Id from @t)
-- select @doc_id as Id    
-- return