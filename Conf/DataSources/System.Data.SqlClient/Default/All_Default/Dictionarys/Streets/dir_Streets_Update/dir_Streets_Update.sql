UPDATE [dbo].[Streets]
   SET [name] = @name,
       [street_type_id] = @streetTypeId
    --   ,[old_name] = @old_name
 WHERE Id = @Id


 UPDATE [dbo].[Objects]
  SET name =ISNULL([StreetTypes].shortname+N' ', N'')+ISNULL([Streets].name+N', ', N'')+ISNULL([Buildings].name, N'')
  FROM [dbo].[Objects]
  INNER JOIN [dbo].[Buildings] ON [Objects].builbing_id=[Buildings].Id
  INNER JOIN [dbo].[Streets] ON [Buildings].street_id=[Streets].Id
  LEFT JOIN [dbo].[StreetTypes] ON [Streets].street_type_id=[StreetTypes].Id
  WHERE [Streets].Id=@Id