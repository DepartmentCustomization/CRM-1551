SELECT Id, [Name]
FROM [dbo].[ControlComments]
WHERE [control_type_id]=2
AND #filter_columns#
--#sort_columns#
order by 1
--offset @pageOffsetRows rows fetch next @pageLimitRows rows only
