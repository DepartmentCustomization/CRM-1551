SELECT s.[Id]
      ,s.[name]
      ,d.[name] as district
      ,st.[name] as streetTypeName
      ,st.[Id] as streetTypeId
    --   ,[old_name]
  FROM [dbo].[Streets] s
  join [dbo].[Districts] d on s.district_id = d.Id
  join [dbo].[StreetTypes] st on st.id = s.street_type_id
    WHERE s.Id = @Id