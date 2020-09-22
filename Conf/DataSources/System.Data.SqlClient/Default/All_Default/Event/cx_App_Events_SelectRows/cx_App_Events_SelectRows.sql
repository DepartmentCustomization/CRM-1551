-- DECLARE @Id INT = 6695929;

SELECT 
	e.[Id],
	e.[start_date],
	et.[name] AS EventType,
	e.[plan_end_date] 
FROM dbo.Questions q
INNER JOIN dbo.[Events] e ON q.event_id = e.Id 
INNER JOIN dbo.[EventTypes] et ON et.Id = e.event_type_id
WHERE q.Id = @Id
;