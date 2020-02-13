
 --  declare @service_type_id int =1;
 ---  declare @object_id int=150217;
   
--if @service_type_id in (1,2,3,4)
 -- begin

  select l.[claim_number] --
      ,l.[claims_type] --
      ,l.[status]-- не future
      ,l.[object_name] --
      ,l.[executor] --
      ,l.[plan_finish_date] --
	  ,l.[display_name]
  from [CRM_1551_GORODOK_Integrartion].[dbo].[Claims_types]
  inner join [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] l on [Claims_types].claim_number=l.claim_number
  inner join [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] on [Claims_types].claim_number=[AllObjectInClaim].[claims_number_id]
  inner join [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] on [AllObjectInClaim].object_id = [Gorodok_1551_houses].gorodok_houses_id
  where ([Claims_types].is_bad_quality is null or [Claims_types].is_bad_quality='false') and [Claims_types].service_type_id=@service_type_id
  and l.status<>'future' and [Gorodok_1551_houses].[1551_houses_id]=@object_id
  union
  select l.[claim_number] --
      ,l.[claims_type] --
      ,l.[status]-- не future
      ,l.[object_name] --
      ,l.[executor] --
      ,l.[plan_finish_date] --
	  ,l.[display_name]
  from [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim]
  inner join [CRM_1551_GORODOK_Integrartion].[dbo].[Claims_places_deleted] on [AllObjectInClaim].claim_places_id=[Claims_places_deleted].claim_places_id
  inner join [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] l on [AllObjectInClaim].claims_number_id=l.claim_number
  inner join [CRM_1551_GORODOK_Integrartion].[dbo].[Claims_types] on [Claims_types].claim_number=l.claim_number
  inner join [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] on [AllObjectInClaim].object_id = [Gorodok_1551_houses].[gorodok_houses_id]
  where ([Claims_types].is_bad_quality is null or [Claims_types].is_bad_quality='false') and [Claims_types].[service_type_id]=@service_type_id
  and l.status<>'future' and [Gorodok_1551_houses].[1551_houses_id]=@object_id


  --end