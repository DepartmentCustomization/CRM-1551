select [Organizations].Id
, [OrganizationTypes].name OrganizationType
, [Organizations2].name ParentOrganization
, [Organizations].short_name
, [Organizations].name
, [Organizations].phone_number
, [Organizations].address
, [Organizations].head_name
, [Organizations].population
, [Organizations].active
  from [CRM_1551_Analitics].[dbo].[Organizations]
  left join [CRM_1551_Analitics].[dbo].[OrganizationTypes] on [Organizations].organization_type_id=[OrganizationTypes].Id
 left join [CRM_1551_Analitics].[dbo].[Organizations] [Organizations2] on [Organizations].parent_organization_id=[Organizations2].Id
   where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 