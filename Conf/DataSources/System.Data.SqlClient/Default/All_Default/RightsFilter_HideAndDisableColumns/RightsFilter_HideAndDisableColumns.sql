--declare @programuser_id nvarchar(128) = N'45d2f527-bd52-47ef-bc6c-4e0943d8e333'
DECLARE @form NVARCHAR(128) = N'Assignment' ;

SELECT
    posfr.colunmcode,
    rtfr.code,
    *
FROM
    [dbo].[PosibilitiesForRoles] posfr
    LEFT JOIN [dbo].[RulesforRights] rfr ON rfr.id = posfr.RulesforRightsId
    LEFT JOIN [dbo].[RulestypeforRights] rtfr ON rtfr.id = rfr.ruletype_id
WHERE
    posfr.role_id IN (
        SELECT
            [role_id]
        FROM
            [dbo].[Positions]
        WHERE
            programuser_id = @programuser_id
    )
    AND RulesforRightsId IN (
        SELECT
            [id]
        FROM
            [dbo].[RulesforRights]
        WHERE
            formcode = @form
    )
    AND [posfr].colunmcode NOT IN (N'complaintype', N'transitionassignmentstate')
    AND posfr.can_do = 0 ;