SELECT TOP (1) [LoadServer].[Id]
      ,[LoadServer].[StateId]
	  ,[LoadServerState].[Name] as [StateName]
	  ,[LoadServerState].[Code] as [StateCode]
      ,[LoadServer].[UpdatedAt]
      ,[LoadServer].[UpdatedById]
      ,[LoadServer].[UpdatedByName]
FROM [dbo].[LoadServer]
left join [dbo].[LoadServerState] on [LoadServerState].Id = [LoadServer].StateId
order by [LoadServer].[Id] desc