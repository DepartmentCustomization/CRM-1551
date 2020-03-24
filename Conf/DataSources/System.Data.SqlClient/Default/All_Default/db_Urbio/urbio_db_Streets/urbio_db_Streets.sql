--declare @treatment_is bit='false';
 -- declare @street_name nvarchar(500)=N'Теремковская';
  --Додавання
SELECT Id, Analitics_Id, Urbio_Id, [operations], [UrbioName], [1551Name], is_done, comment, [is_done_filter], [StreetName_filter]
FROM
  (
  SELECT ISNULL(LTRIM(sa.Id),N'')+ISNULL(LTRIM(su.Id),N'') Id, sa.Id Analitics_Id, su.Id Urbio_Id,
  N'Додавання' [operations],
  ISNULL(su.[name_shortToponym]+N' ',N'')+ISNULL(su.name_fullName+N' ', N'')+ISNULL(su.uniqueMarker_fullText+N' ',N'')+
  ISNULL(su.history_fullName+N' ', N'')+ISNULL(su.history_shortToponym+N' ',N'') [UrbioName],
  ISNULL(sta.shortname+N' ',N'')+ISNULL(sa.name,N'') [1551Name],
  su.is_done, su.comment
  ,su.is_done is_done_filter
  ,su.id [StreetName_filter]
  FROM [CRM_1551_URBIO_Integrartion].[dbo].[streets] su
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Streets] sa ON su.id=sa.urbio_id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[StreetTypes] sta ON sa.street_type_id=sta.Id
  WHERE 
  su.is_add= 'true' and
  su.is_change='false' and
  su.is_delete='false' and
  su.[is_done]='false' 

  --редагування
  union
  SELECT ISNULL(LTRIM(sa.Id),N'')+ISNULL(LTRIM(su.Id),N'') Id, sa.Id Analitics_Id, su.Id Urbio_Id,
  N'Редагування' [operations],
  ISNULL(su.[name_shortToponym]+N' ',N'')+ISNULL(su.name_fullName+N' ', N'')+ISNULL(su.uniqueMarker_fullText+N' ',N'')+
  ISNULL(su.history_fullName+N' ', N'')+ISNULL(su.history_shortToponym+N' ',N'') [UrbioName],
  ISNULL(sta.shortname+N' ',N'')+ISNULL(sa.name,N'') [1551Name],
  su.is_done, su.comment
  ,su.is_done is_done_filter
  ,su.id [UrbioName_filter]
  FROM [CRM_1551_URBIO_Integrartion].[dbo].[streets] su
  INNER JOIN [CRM_1551_Analitics].[dbo].[Streets] sa ON CONVERT(nvarchar(128),su.id)=sa.urbio_id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[StreetTypes] sta ON sa.street_type_id=sta.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Districts] d on sa.district_id=d.id
  WHERE 
  -- ISNULL(su.name_fullName+N' ', N'')+ISNULL(su.uniqueMarker_fullText+N' ',N'')+
  -- ISNULL(su.history_fullName+N' ', N'')+ISNULL(su.history_shortToponym+N' ',N'')<>ISNULL(sa.name,N'')
  --ISNULL(su.[name_shortToponym],N'')+
  --ISNULL(su.name_fullName+N' ', N'')+ISNULL(su.uniqueMarker_fullText+N' ',N'')+
  --ISNULL(su.history_fullName+N' ', N'')+ISNULL(su.history_shortToponym+N' ',N'')<>ISNULL(sta.shortname,N'')+ISNULL(sa.name,N'')


  --OR d.urbio_id<>su.ofDistrict_id
  --OR ISNULL(d.name,N'')<>ISNULL(su.ofDistrict_name_fullName,N'')
  su.is_add='false' and --is_add
su.is_change='true' and --is_change
su.is_delete='false' and --is_delete
su.[is_done]='false' --[is_done]


  --видалення
  union
  SELECT ISNULL(LTRIM(sa.Id),N'')+ISNULL(LTRIM(su.Id),N'') Id, sa.Id Analitics_Id, su.Id Urbio_Id,
  N'Видалення' [operations],
  ISNULL(su.[name_shortToponym]+N' ',N'')+ISNULL(su.name_fullName+N' ', N'')+ISNULL(su.uniqueMarker_fullText+N' ',N'')+
  ISNULL(su.history_fullName+N' ', N'')+ISNULL(su.history_shortToponym+N' ',N'') [UrbioName],
  ISNULL(sta.shortname+N' ',N'')+ISNULL(sa.name,N'') [1551Name],
  su.is_done, su.comment
  ,su.is_done is_done_filter
  ,su.id [UrbioName_filter]
  FROM [CRM_1551_Analitics].[dbo].[Streets] sa 
  INNER JOIN [CRM_1551_URBIO_Integrartion].[dbo].[streets] su ON CONVERT(nvarchar(128),su.id)=sa.urbio_id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[StreetTypes] sta ON sa.street_type_id=sta.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Districts] d on sa.district_id=d.Id 
  WHERE --sa.urbio_id IS NULL
  su.is_add='false' and
su.is_change='false' and
su.is_delete='true' and
su.[is_done]='false' 
  ) t
  WHERE #filter_columns#
   #sort_columns#
  -- offset @pageOffsetRows rows fetch next @pageLimitRows rows only

