UPDATE [dbo].[Streets]
   SET [name] = @name,
       [street_type_id] = @streetTypeId
    --   ,[old_name] = @old_name
 WHERE Id = @Id