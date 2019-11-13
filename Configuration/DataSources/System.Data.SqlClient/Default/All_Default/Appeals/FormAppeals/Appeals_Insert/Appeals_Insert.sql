declare @output table (Id int)

INSERT INTO [dbo].[Appeals]
           ([registration_date]
           ,[registration_number]
           ,[receipt_source_id]
           ,[phone_number]
           ,[receipt_date]
           ,[start_date]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id])
output [inserted].[Id] into @output (Id)
     VALUES
           (getutcdate() --@registration_date
           --,@registration_number
		   ,concat( SUBSTRING ( rtrim(YEAR(getdate())),4,1),'-',(select count(Id)+1 from Appeals where year(Appeals.registration_date) = year(getdate())) ) 
           ,@receipt_source_id
           ,@phone_number
           ,getutcdate() -- @receipt_date
           ,getutcdate() -- @start_date
           ,@user_id
           ,getutcdate() -- @edit_date
           ,@user_id
		   )

declare @app_id int
set @app_id = (select top 1 Id from @output)

-- update [dbo].[Appeals] set registration_number =  concat( YEAR(getdate()),'-',MONTH(getdate()),'/',@app_id  ) where Id =  @app_id
/*
update [dbo].[Appeals] 
set registration_number =  concat( SUBSTRING ( rtrim(YEAR(getdate())),4,1),'-',(select count(Id) from Appeals where year(Appeals.registration_date) = year(getdate())) ) 
where Id =  @app_id
*/
select @app_id as [Id]
return;