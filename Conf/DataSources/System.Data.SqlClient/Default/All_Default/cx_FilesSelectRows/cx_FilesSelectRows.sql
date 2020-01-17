  select Id, 
  [File],
  [FileName] as [Name]
  from [CRM_1551_Analitics].[dbo].[Events]
  where Id=@id and [File] is not null and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only