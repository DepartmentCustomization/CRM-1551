
--declare @Id int =2

select [Organizations].Id, [OrganizationTypes].Id organization_type_id, [OrganizationTypes].name OrganizationType, [Organizations2].Id organization_id, [Organizations2].short_name ParentOrganization, [Organizations].short_name, [Organizations].name,
  [Organizations].phone_number, [Organizations].address, [Organizations].head_name, [Organizations].population, [Organizations].active
      ,[Organizations].[edit_date]
      ,[Organizations].[user_edit_id]
	  ,[Organizations].organization_code, [Organizations].programworker, [Positions].Id positions_id, [Positions].[name] positions_name
	  ,[Organizations].[notes]
      ,[Organizations].[othercontacts]
      ,[Organizations].Id organization_id_id
  from [CRM_1551_Analitics].[dbo].[Organizations]
  left join [CRM_1551_Analitics].[dbo].[OrganizationTypes] on [Organizations].organization_type_id=[OrganizationTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] [Organizations2] on [Organizations].parent_organization_id=[Organizations2].Id
  left join [CRM_1551_Analitics].[dbo].[OrganizationInResponsibility] on [Organizations].Id=[OrganizationInResponsibility].organization_id
  left join [CRM_1551_Analitics].[dbo].[Positions] on [OrganizationInResponsibility].position_id=[Positions].Id
  where [Organizations].Id=@Id