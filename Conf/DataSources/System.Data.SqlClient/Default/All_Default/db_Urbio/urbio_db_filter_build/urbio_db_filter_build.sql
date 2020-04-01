

  select Id, UrbioId, [Name]
  from (
  SELECT ROW_NUMBER() OVER(ORDER BY ao.[name_ofFirstLevel_fullName]) Id, Id UrbioId, ISNULL(ao.ofStreet_name_shortName+N' ', N'')+ISNULL(ao.[name_ofFirstLevel_fullName],N'') [Name]
  FROM [CRM_1551_URBIO_Integrartion].[dbo].[addressObject] ao
  ) t
 where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
