INSERT INTO [dbo].[Event_Class]
           ([name]
           ,[global_id]
           ,[event_type_id])
     VALUES (@name, (select id 
     from [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_new] 
     where name = @name), @eventClassTypeId)