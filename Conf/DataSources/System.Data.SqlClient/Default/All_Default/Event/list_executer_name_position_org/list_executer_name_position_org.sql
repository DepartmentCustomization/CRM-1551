SELECT [Executors].[Id]
    --   ,concat([Executors].[name], ' - ', [Executors].position, ' ',Organizations.short_name) as executer_name
      ,Organizations.short_name as executer_name
  FROM [dbo].[Executors]
	left join Organizations on Organizations.Id = Executors.organization_id
	where  #filter_columns#
    #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only