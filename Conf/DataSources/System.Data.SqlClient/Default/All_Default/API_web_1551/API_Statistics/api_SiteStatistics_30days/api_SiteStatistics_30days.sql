  SELECT [Id]
      ,Vroboti as [vroboti]
      ,Obrobleni as [obrobleni]
      ,Vykonani as [vykonani]
      ,Nadoopratsiyvanni as [nadoopratsiyvanni]
      ,Prostrocheni as [prostrocheni]
      ,NotCloseEvents as [NotCloseEvents]
  FROM [CRM_1551_Site_Integration].[dbo].[Statistics_Questions_30days]
 where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
