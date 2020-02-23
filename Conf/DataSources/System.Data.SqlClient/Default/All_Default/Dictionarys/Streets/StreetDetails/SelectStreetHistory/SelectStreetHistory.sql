SELECT
    [user_id],
    [field],
    [before],
    [after],
    [change_datetime]
FROM
    [CRM_1551_Analitics].[dbo].[Object_History]
WHERE
    element_id = @Id
    AND #filter_columns#
    #sort_columns#
    OFFSET @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS ONLY;