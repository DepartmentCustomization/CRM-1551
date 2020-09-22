--declare @Id int = 231;
-- declare @start_date datetime = (select registration_date from Events where Id = @Id)
SELECT
DISTINCT
	Questions.Id,
	Questions.registration_number,
	Questions.registration_date,
	Organizations.short_name AS org_name
FROM
	[dbo].[Events] AS e
	INNER JOIN [dbo].Questions ON Questions.event_id = e.Id
	LEFT JOIN [dbo].Assignments ON Assignments.Id = Questions.last_assignment_for_execution_id
	LEFT JOIN [dbo].Organizations ON Organizations.Id = Assignments.executor_organization_id
WHERE e.Id = @Id
	AND #filter_columns#
		#sort_columns#
	OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY;