
SELECT [Id]
      ,[claim_number]
      ,[claim_state]
      ,[claim_type]
      ,[main_object_id]
      ,[executor]
      ,[start_date]
      ,[planned_end_date]
      ,[global]
      ,[audio_on]
  FROM [dbo].[GorodokClaims]
	where  #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only