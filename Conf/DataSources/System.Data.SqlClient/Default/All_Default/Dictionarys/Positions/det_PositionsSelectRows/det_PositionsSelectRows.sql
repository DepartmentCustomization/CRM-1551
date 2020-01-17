select [OrganizationInResponsibility].Id, [Organizations].address, [Organizations].short_name
  from /*[CRM_1551_Analitics].[dbo].[Positions]
  inner join*/ [CRM_1551_Analitics].[dbo].[OrganizationInResponsibility] /*on [Positions].Id=[OrganizationInResponsibility].position_id*/
  inner join [CRM_1551_Analitics].[dbo].[Organizations] on [OrganizationInResponsibility].organization_id=[Organizations].Id
  where [OrganizationInResponsibility].position_id=@position_id
   and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only