SELECT ROW_NUMBER() OVER(ORDER BY name_fullName) Id, Id UrdioId, name_fullName [Name]
  FROM [CRM_1551_URBIO_Integrartion].[dbo].[streets]
  WHERE #filter_columns#
  #sort_columns#
  OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY