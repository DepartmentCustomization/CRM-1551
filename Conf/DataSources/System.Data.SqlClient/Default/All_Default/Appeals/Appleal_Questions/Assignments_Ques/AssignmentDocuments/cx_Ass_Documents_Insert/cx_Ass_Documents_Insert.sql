declare @t table (Id int)
declare @doc_id int

INSERT INTO [dbo].[AssignmentConsDocuments]
           ([assignment_сons_id]
           ,[doc_type_id]
           ,[name]
           ,[content]
           ,[add_date]
           ,[user_id]
          ,[edit_date]
           ,[user_edit_id]
           )
   output inserted.Id into @t(Id) 
     VALUES
           (
            @assignment_сons_id
           ,@doc_type_id
           ,@name
           ,@content
           ,getutcdate()
           ,@user_id
          ,getutcdate()
           ,@user_edit_id)
           
    set @doc_id = (select top 1 Id from @t)
select @doc_id as Id    
return