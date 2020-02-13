SELECT e.Id, e.[event_date] receipt_date, e.[longitude], e.[latitude], app.person_phone, e.[content],
  ISNULL(app.last_name+N' ',N'')+ISNULL(app.first_name+N' ',N'')+ISNULL(app.middle_name,N'') FIO,
  ISNULL(st.shortname, N'')+ISNULL(s.name, N'')+ISNULL(N' '+b.name, N'')+
  ISNULL(N', кв.'+LTRIM(e.floor), N'')+ISNULL(N', під`їзд '+LTRIM(e.entrance), N'')+
  ISNULL(N' (код '+e.entercode+N')', N'')+ISNULL(N', поверх: '+LTRIM(e.floor), N'')+ISNULL(N'/'+LTRIM(e.storeysnumber),N'') event_address
  , c.name category_name

  FROM [dbo].[Events] e
  LEFT JOIN [dbo].[Categories] c ON e.category_id=c.id
  LEFT JOIN [dbo].[Persons] app ON e.applicant_id=app.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Buildings] b  ON e.building_id=b.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Streets] s ON b.street_id=s.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[StreetTypes] st ON s.street_type_id=st.Id
  WHERE 
  #filter_columns#
  ORDER BY 1 DESC--#sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
