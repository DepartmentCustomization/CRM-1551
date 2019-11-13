  select [Buildings].Id,
  [StreetTypes].shortname+N' '+[Streets].name+N', '+[Buildings].name full_name
  
  from [CRM_1551_Analitics].[dbo].[Buildings] left join [CRM_1551_Analitics].[dbo].[Districts] on [Buildings].district_id=[Districts].Id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=Streets.Id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  where [Buildings].Id = @Id