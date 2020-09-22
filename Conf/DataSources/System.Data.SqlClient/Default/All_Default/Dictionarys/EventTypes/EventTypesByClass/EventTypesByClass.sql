-- DECLARE @classId SMALLINT = 1;

SELECT
    et.Id,
    et.[name]
FROM
    [dbo].[Event_Class] ec
    INNER JOIN [dbo].EventTypes et ON ec.event_type_id = et.Id
WHERE
    ec.id = @classId
    AND #filter_columns#
        #sort_columns#
    OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY;