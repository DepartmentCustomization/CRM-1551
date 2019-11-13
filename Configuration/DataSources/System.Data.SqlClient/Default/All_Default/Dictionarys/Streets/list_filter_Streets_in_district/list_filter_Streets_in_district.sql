-- declare @district_id int =5;

select [Buildings].Id, 
  case when [Buildings].street_id is not null then [StreetTypes].shortname+N' '+[Streets].name else N'' end+
  case when [Buildings].name is not null then N', буд. '+[Buildings].name else N'' end name
  --case when [Buildings].letter is not null then [Buildings].letter else N'' end name
  from [CRM_1551_Analitics].[dbo].[Buildings]
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  where [Buildings].district_id=@district_id 
  and #filter_columns#
  order by [Buildings].street_id, [Buildings].Id
  offset @pageOffsetRows rows fetch next @pageLimitRows rows only