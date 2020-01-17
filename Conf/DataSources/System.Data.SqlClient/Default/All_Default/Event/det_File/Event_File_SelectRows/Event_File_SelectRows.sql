
SELECT
	Id,
	[name] AS [Name],
	[File]
FROM [dbo].[EventFiles]
WHERE [event_id] =@Id
	AND [File] IS NOT NULL
	AND #filter_columns#
--	#sort_columns#
ORDER BY 1
	offset @pageOffsetRows rows fetch next @pageLimitRows rows only
