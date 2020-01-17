SELECT [id]
      ,[name]
      ,[global_id]
      ,[event_type_id]
  FROM [dbo].[Event_Class]
 where #filter_columns#
	   #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only