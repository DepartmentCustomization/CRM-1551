  select [Positions].Id, N'ФІО: '+isnull([Positions].name, N'_')+N', Організація: '+isnull([Organizations].short_name, N'_')+N', Посада: '+isnull([Positions].position, N'_') name
  from [CRM_1551_Analitics].[dbo].[Positions]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Positions].organizations_id=[Organizations].Id
   where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only