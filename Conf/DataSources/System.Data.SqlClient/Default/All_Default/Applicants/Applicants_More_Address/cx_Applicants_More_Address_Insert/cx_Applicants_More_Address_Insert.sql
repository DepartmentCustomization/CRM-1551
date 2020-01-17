INSERT INTO [dbo].[LiveAddress]
           ([applicant_id]
           ,[building_id]
           ,[house_block]
           ,[entrance]
           ,[flat]
           ,[main]
           ,[active])
	output [inserted].[applicant_id]
     VALUES
           (@applicant_id
           ,@building_address
           ,@house_block
           ,@entrance
           ,@flat
           ,@main
           ,@active
		   )