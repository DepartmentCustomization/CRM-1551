select [OrganizationInResponsibility].Id, [Positions].Id position_id, [Positions].position, [Organizations].Id organization_id,
  [Organizations].short_name
  from [CRM_1551_Analitics].[dbo].[OrganizationInResponsibility]
  inner join [CRM_1551_Analitics].[dbo].[Positions] on [OrganizationInResponsibility].position_id=[Positions].Id
  inner join [CRM_1551_Analitics].[dbo].[Organizations] on [OrganizationInResponsibility].organization_id=[Organizations].Id
  where [OrganizationInResponsibility].Id= @Id