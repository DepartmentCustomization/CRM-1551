declare @output table (Id int)

INSERT INTO [dbo].[Appeals]
           ([applicant_id]
           ,[registration_date]
           ,[registration_number]
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
           ,[user_edit_id]
           ,[LogUpdated_Query])
output [inserted].[Id] into @output (Id)
     VALUES
           (@applicant_Id
           ,getutcdate() --@registration_date
           --,@registration_number
           ,(
select 
case when not exists(
				select top 1 LTRIM(RIGHT(YEAR(getutcdate()),1))+N'-'+ltrim(substring(registration_number, 3, len(registration_number)-2)*1+1)
				from [dbo].[Appeals]
				where left(registration_number, 1) in (right(ltrim(year(getutcdate())),1))
				order by id desc
				)
			then LTRIM(RIGHT(YEAR(getutcdate()),1))+N'-1'
			else (select top 1 LTRIM(RIGHT(YEAR(getutcdate()),1))+N'-'+ltrim(substring(registration_number, 3, len(registration_number)-2)*1+1)
				from [dbo].[Appeals]
				where left(registration_number, 1) in (right(ltrim(year(getutcdate())),1))
				order by id desc)
			end
)
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
           ,N'query_Appeals_Insert'
		   )

declare @app_id int
set @app_id = (select top 1 Id from @output)

--update [dbo].[Appeals] set registration_number =  concat( YEAR(getutcdate()),'-',MONTH(getutcdate()),'/',@app_id  ) where Id =  @app_id

select @app_id as [Id]
return;