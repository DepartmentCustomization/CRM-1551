SELECT p.Id
		,concat(p.[name], ' (' + p.[position] +')') as executor_person
  FROM [dbo].[PersonExecutorChoose] as pe
	 join Positions as p on p.Id = pe.position_id
	 WHERE p.organizations_id = @org_id
		AND p.active <> 0
    and #filter_columns#
        #sort_columns#
--offset @pageOffsetRows rows fetch next @pageLimitRows rows only


/*SELECT [Id]
      , concat([name], ' (' + [position] +')') as executor_person
FROM [dbo].[Positions]
WHERE organizations_id = @org_id
  AND active <> 0*/