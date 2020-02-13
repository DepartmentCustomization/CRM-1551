  --declare @house_Id int=2;

 select 
[Elevators].Id,
[Elevators].claim_id, 
[Elevators].claim_type_name, 
[Elevators].start_from, 
[Elevators].due_to, 
[Elevators].is_profilactic, 
[Elevators].with_people, 
[Elevators].modernization, 
[Elevators].switched_off,
[Elevators].entrance, 
[Elevators].name, 
[Gorodok_1551_houses].[1551_houses_id] as house_id,
Replace(Replace([Elevators].[report_name], N'. Ліфти', ''), N'.Ліфти', '') as executor_name
, CONCAT([StreetTypes].[shortname], ' ', [Streets].[name]) as street_name
, [Buildings].[name] as house_name
  from [CRM_1551_GORODOK_Integrartion].[dbo].[Elevators]
  inner join [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] on [Elevators].house_id=[Gorodok_1551_houses].gorodok_houses_id
  inner join CRM_1551_Analitics.[dbo].[Buildings] ON [Gorodok_1551_houses].[1551_houses_id] = [Buildings].id
  inner join CRM_1551_Analitics.[dbo].[Streets] ON  [Buildings].[street_id] = [Streets].[Id]
  inner join CRM_1551_Analitics.[dbo].[StreetTypes] ON [Streets].[street_type_id] = [StreetTypes].id
where [Gorodok_1551_houses].[1551_houses_id]=@house_Id
  and 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
