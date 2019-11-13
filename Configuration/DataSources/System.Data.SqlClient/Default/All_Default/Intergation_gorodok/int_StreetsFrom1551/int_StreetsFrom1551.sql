
SELECT cat_log.[id] as Id
      ,str_old.id as id_str_gor
	  ,str_old.name as name_str_gor
	  ,str_1515.Id as id_str_1551
	  ,str_1515.name + ' ' + str_type.shortname as name_str_1551
  FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Programs_1551_catalog] as cat_log
  join [CRM_1551_GORODOK_Integrartion].[dbo].Gorodok_streets_old as str_old on str_old.id = cat_log.integration_tables_id
  join CRM_1551_Analitics.dbo.Streets as str_1515 on str_1515.Id = cat_log.[1551_id]
  join  CRM_1551_Analitics.dbo.StreetTypes as str_type on str_type.Id = str_1515.street_type_id


/*SELECT [Streets].[Id]
      ,[Streets].[name] + ' ' + StreetTypes.shortname as streets
  FROM [dbo].[Streets]
  join StreetTypes on StreetTypes.Id = Streets.street_type_id
  where [Streets].Id not in (1)*/