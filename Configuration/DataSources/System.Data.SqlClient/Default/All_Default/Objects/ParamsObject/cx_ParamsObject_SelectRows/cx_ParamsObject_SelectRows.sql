SELECT [ValuesParamsObjects].[Id]
	   ,ParamsObjects.name as params_name
      ,[ValuesParamsObjects].[value]
  FROM [dbo].[ValuesParamsObjects]
	left join ParamsObjects on ParamsObjects.Id = ValuesParamsObjects.param_object_id
where ValuesParamsObjects.object_id = @Id
and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only