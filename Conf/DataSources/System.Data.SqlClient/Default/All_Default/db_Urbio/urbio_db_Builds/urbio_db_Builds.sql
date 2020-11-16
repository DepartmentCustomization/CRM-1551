--declare @treatment_is bit='false';
--declare @build_name nvarchar(500)=N'Теремковская';

SELECT Id, buid_Id Analitics_Id, addressObject_Id Urbio_Id, [operations], Urbio_build, Urbio_District, [1551_District], [1551_Build], is_done_filter is_done, comment,
is_done_filter, name_fullName_filter [BuildName_filter]
FROM
(
select ISNULL(LTRIM(b.Id),N'')+ISNULL(LTRIM(ao.Id),N'') Id, b.Id buid_Id, ao.Id addressObject_Id,
  N'Додавання' [operations]
  ,ao.ofDistrict_name_fullName Urbio_District
  ,d.name [1551_District], ISNULL(st.shortname+N' ',N'')+ISNULL(s.name+N' ', N'')+ISNULL(b.name,N'') [1551_Build], ao.comment
  ,ISNULL(ao.[ofStreet_name_shortToponym]+N' ',N'')+ISNULL(ao.ofStreet_name_shortName+N' ', N'')+ISNULL(ao.[name_ofFirstLevel_fullName],N'') Urbio_build
  , ao.is_done is_done_filter
  , ao.Id name_fullName_filter
  from [CRM_1551_URBIO_Integrartion].[dbo].[addressObject] ao
  LEFT join   [dbo].[Buildings] b on ao.id=b.urbio_id
  left join   [dbo].[Streets] s on b.street_id=s.Id
  left join   [dbo].[StreetTypes] st on s.street_type_id=st.Id
  left join   [dbo].[Districts] d on b.district_id=d.Id
  where --b.urbio_id is null
  ao.is_add= 'true' and
  ao.is_change='false' and
  ao.is_delete='false' and
  ao.[is_done]='false' 

 -- редагування
 UNION
select ISNULL(LTRIM(b.Id),N'')+ISNULL(LTRIM(ao.Id),N'') Id, b.Id buid_Id, ao.Id addressObject_Id,
  N'Редагування' [operations]
  ,ao.ofDistrict_name_fullName Urbio_District
  ,d.name [1551_District], ISNULL(st.shortname+N' ',N'')+ISNULL(s.name+N' ', N'')+ISNULL(b.name,N'') [1551_Build], ao.comment
  ,ISNULL(ao.[ofStreet_name_shortToponym]+N' ',N'')+ISNULL(ao.ofStreet_name_shortName+N' ', N'')+ISNULL(ao.[name_ofFirstLevel_fullName],N'') Urbio_build
  , ao.is_done is_done_filter
  , ao.Id name_fullName_filter
  from [CRM_1551_URBIO_Integrartion].[dbo].[addressObject] ao
  INNER JOIN   [dbo].[Buildings] b on ao.id=b.urbio_id
  LEFT JOIN   [dbo].[Objects] o ON b.Id=o.builbing_id
  left join   [dbo].[Streets] s on b.street_id=s.Id
  left join   [dbo].[StreetTypes] st on s.street_type_id=st.Id
  left join   [dbo].[Districts] d on b.district_id=d.Id
  where 
  --b.urbio_id is null
  --where ISNULL(convert(nvarchar(128),ao.ofDistrict_id), N'')<>ISNULL(d.urbio_id, N'')
  --OR ISNULL(convert(nvarchar(128),ao.ofStreet_id), N'')<>ISNULL(s.urbio_id, N'')
  --OR ISNULL(ao.name_ofFirstLevel_fullName, N'')<>ISNULL(b.name, N'')
  --OR ISNULL(ao.name_ofSecondLevel_fullName+N' ', N'')+ISNULL(ao.name_ofThirdLevel_fullName, N'')<>ISNULL(b.bsecondname, N'')
  ----1551 name
  --OR ISNULL(ao.zip, N'')<>ISNULL(b.[index], N'')

  ao.is_add='false' 
and ao.is_change='true' 
and ao.is_delete='false' 
and ao.[is_done]='false' 
and ao.[done_date] is null 

  --удаление
  UNION
  select ISNULL(LTRIM(b.Id),N'')+ISNULL(LTRIM(ao.Id),N'') Id, b.Id buid_Id, ao.Id addressObject_Id, 
  N'Видалення' [operations]
  ,ao.ofDistrict_name_fullName Urbio_District
  ,d.name [1551_District], ISNULL(st.shortname+N' ',N'')+ISNULL(s.name+N' ', N'')+ISNULL(b.name,N'') [1551_Build], ao.comment
  ,ISNULL(ao.[ofStreet_name_shortToponym]+N' ',N'')+ISNULL(ao.ofStreet_name_shortName+N' ', N'')+ISNULL(ao.[name_ofFirstLevel_fullName],N'') Urbio_build
  , ao.is_done is_done_filter
  , ao.Id name_fullName_filter
  from [CRM_1551_URBIO_Integrartion].[dbo].[addressObject] ao
  INNER JOIN   [dbo].[Buildings] b on ao.id=b.urbio_id
  LEFT JOIN   [dbo].[Objects] o ON b.Id=o.builbing_id
  left join   [dbo].[Streets] s on b.street_id=s.Id
  left join   [dbo].[StreetTypes] st on s.street_type_id=st.Id
  left join   [dbo].[Districts] d on b.district_id=d.Id--ao.DistrictId_1551=d.Id
  where 
  ao.is_add='false'
and ao.is_change='false'
and ao.is_delete='true'
and ao.[is_done]='false' 
and ao.[done_date] is null 
  ) t
  where #filter_columns#
--  #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only