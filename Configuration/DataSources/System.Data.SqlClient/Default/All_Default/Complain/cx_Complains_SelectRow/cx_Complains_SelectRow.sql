SELECT
  c.[Id],
  c.[registration_date],
  ct.[name] AS complain_type_name,
  ct.id AS complain_type_id,
  c.[culpritname],
  c.[guilty] AS guilty_id,
  c.[text],
  w.[name] AS [user_name],
  w.Id AS [user_id],
  ISNULL([LastName], N'') + N' ' + ISNULL([FirstName], N'') + N' ' + ISNULL([Patronymic], N'') guilty_name
FROM [dbo].[Complain] c
  LEFT JOIN ComplainTypes ct ON ct.Id = c.complain_type_id
  LEFT JOIN Workers w ON w.worker_user_id = c.[user_id]
  LEFT JOIN [#system_database_name#].dbo.[User] u ON u.UserId = c.[guilty]
WHERE
  c.Id = @Id