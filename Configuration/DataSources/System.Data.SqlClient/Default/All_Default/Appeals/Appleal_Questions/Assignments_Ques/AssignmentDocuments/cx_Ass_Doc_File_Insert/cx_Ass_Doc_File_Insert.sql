declare @output table (Id int)

INSERT INTO [dbo].[AssignmentConsDocFiles]
           ([assignment_cons_doc_id]
           ,[create_date]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id]
           ,[name]
           ,[File])
     output [inserted].[Id] into  @output(Id)
     VALUES
           (@assignment_cons_doc_id
           ,getutcdate() 
           ,@user_id
           ,getutcdate() 
           ,@user_edit_i
           ,@name
           ,@File)
           
           
declare @doc_id int
set @doc_id = (select top (1) Id from @output)

select @doc_id as Id
return