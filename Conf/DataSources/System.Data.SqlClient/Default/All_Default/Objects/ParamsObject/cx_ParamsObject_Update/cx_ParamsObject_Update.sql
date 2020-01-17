UPDATE [dbo].[ValuesParamsObjects]
       SET  
			[param_object_id] = @params_id
           ,[value] =@value
WHERE Id = @Id