SELECT [Id]
      ,[name]
      ,[Id] RulesId
      ,ltrim(Id)+N'-'+[name] [Idname]
  FROM [CRM_1551_Analitics].[dbo].[Rules]
  where id=@Id