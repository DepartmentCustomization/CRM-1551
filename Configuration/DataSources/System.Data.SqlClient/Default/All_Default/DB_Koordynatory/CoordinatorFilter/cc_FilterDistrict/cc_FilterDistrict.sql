
  
    select Id, short_name [name]
  from [Organizations]
  where [organization_type_id]=5 and Id not in (4007, 3)
  /* and  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
*/
  /*select 0 [Id], N'Усі' [name]
  union all
  SELECT [Id], [name]
  FROM [CRM_1551_Analitics].[dbo].[Districts]
  */