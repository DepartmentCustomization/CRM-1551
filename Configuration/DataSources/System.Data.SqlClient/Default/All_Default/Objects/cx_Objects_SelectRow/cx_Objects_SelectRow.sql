SELECT [Objects].[Id]
      ,ObjectTypes.name as obj_type_name
	  ,ObjectTypes.Id as obj_type_id
      ,Objects.name as object_name
      ,Districts.name as district_name
	  ,Districts.Id as district_id
      ,[Buildings].[street_id]
      --,concat(Streets.name, ' ', Buildings.number,Buildings.letter) as build_name
      , concat(StreetTypes.shortname, N' ', Streets.name, N' ', Buildings.number,isnull(Buildings.letter, null)) as build_name
      ,Buildings.Id as builbing_id
      ,Objects.is_active
  FROM [dbo].[Objects]
	left join Buildings on Buildings.Id = [Objects].[builbing_id]
	left join Streets on Streets.Id = Buildings.street_id
	left join ObjectTypes on ObjectTypes.Id = Objects.object_type_id
	left join Districts on Districts.Id = Buildings.district_id
	left join [CRM_1551_Analitics].[dbo].[StreetTypes] on Streets.street_type_id=StreetTypes.Id
where Objects.Id = @Id