-- DECLARE @Id INT = 2;

SELECT 
	Id,
	SystemUserId,
	isnull(LastName, N'')+N' '+isnull([FirstName], N'')+N' '+isnull([Patronymic], N'') AS UserName
FROM dbo.Test_Bag tb
INNER JOIN [#system_database_name#].dbo.[User] su ON su.UserId = tb.SystemUserId
WHERE tb.Id = @Id;