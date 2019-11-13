declare @output table (Id int)

INSERT INTO [dbo].[Appeals]
           ([applicant_id]
           ,[registration_date]
           --,[registration_number]
           ,[receipt_source_id]
           ,[phone_number]
           ,[mail]
           ,[enter_number]
           ,[submission_date]
           ,[receipt_date]
           ,[start_date]
           ,[end_date]
           ,[article]
           ,[sender_name]
           ,[sender_post_adrress]
           ,[city_receipt]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id])
output [inserted].[Id] into @output (Id)
     VALUES
           (@applicant_Id
           ,getutcdate() --@registration_date
           --,@registration_number
           ,@receipt_source_id
           ,@phone_number
           ,@mail
           ,@enter_number
           ,@submission_date
           ,getutcdate() -- @receipt_date
           ,@start_date
           ,@end_date
           ,@article
           ,@sender_name
           ,@sender_post_adrress
           ,@city_receipt
           ,@user_id
           ,getutcdate() -- @edit_date
           ,@user_edit_id
		   )

declare @app_id int
set @app_id = (select top 1 Id from @output)

update [dbo].[Appeals] set registration_number =  concat( YEAR(getdate()),'-',MONTH(getdate()),'/',@app_id  ) where Id =  @app_id

select @app_id as [Id]
return;