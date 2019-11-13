UPDATE [dbo].[LiveAddress]
   SET [applicant_id] = @applicant_id
      ,[building_id] = @building_address
      ,[house_block] = @house_block
      ,[entrance] = @entrance
      ,[flat] = @flat
      ,[main] = @main
      ,[active] = @active
 WHERE Id = @Id