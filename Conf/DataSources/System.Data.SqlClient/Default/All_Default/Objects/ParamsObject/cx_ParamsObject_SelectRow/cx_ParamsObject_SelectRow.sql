SELECT [ValuesParamsObjects].[Id]
	   ,ParamsObjects.name as params_name
	   ,ParamsObjects.Id as params_id
      ,[ValuesParamsObjects].[value]
      ,ValuesParamsObjects.object_id
  FROM [dbo].[ValuesParamsObjects]
	left join ParamsObjects on ParamsObjects.Id = ValuesParamsObjects.param_object_id
where ValuesParamsObjects.Id = @Id

