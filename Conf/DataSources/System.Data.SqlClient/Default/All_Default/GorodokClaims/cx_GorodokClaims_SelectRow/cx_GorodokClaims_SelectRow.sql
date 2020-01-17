SELECT [GorodokClaims].[Id]
      ,[GorodokClaims].[claim_number]
      ,[GorodokClaims].[claim_state]
      ,[GorodokClaims].[claim_type]
      ,[GorodokClaims].[claim_content]
    --   ,[GorodokClaims].[main_object_id]
      ,Objects.Id as main_object_id
      ,concat(ObjectTypes.name, ': ',Streets.name, ' ', Buildings.number,Buildings.letter) as [object_name]
      ,[GorodokClaims].[executor]
      ,[GorodokClaims].[start_date]
      ,[GorodokClaims].[planned_end_date]
      ,[GorodokClaims].[fact_end_date]
      ,[GorodokClaims].[comment_executor]
      ,[GorodokClaims].[global]
      ,[GorodokClaims].[audio_start_date]
      ,[GorodokClaims].[audio_end_date]
      ,[GorodokClaims].[standart_audio]
      ,[GorodokClaims].[say_liveAddress_id]
      ,[GorodokClaims].[say_organization_id]
      ,[GorodokClaims].[say_phone_for_information]
      ,[GorodokClaims].[phone_for_information]
      ,[GorodokClaims].[say_plan_end_date]
      ,[GorodokClaims].[audio_on]
  FROM [dbo].[GorodokClaims]
    left join Objects on Objects.Id = GorodokClaims.main_object_id
	left join Buildings on Buildings.Id = [Objects].Id
	left join Streets on Streets.Id = Buildings.street_id
	left join ObjectTypes on ObjectTypes.Id = [Objects].object_type_id
    
	where [GorodokClaims].Id = @Id