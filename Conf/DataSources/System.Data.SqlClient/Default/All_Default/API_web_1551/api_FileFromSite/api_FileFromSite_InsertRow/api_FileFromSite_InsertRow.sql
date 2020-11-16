IF(@appeal_from_site_id) IS NOT NULL 
AND LEN(@appeal_from_site_id) > 0
BEGIN
INSERT INTO
    [CRM_1551_Site_Integration].[dbo].[AppealFromSiteFiles] (
        [AppealFromSiteId],
        [File],
        [Name]
    )
SELECT
    @appeal_from_site_id,
    @file,
    @name;
END 

IF ((@appeal_id IS NOT NULL
    OR @question_id IS NOT NULL
    OR @appeal_from_site_id IS NOT NULL)
    AND @is_revision = 'true')
    OR (
    SELECT
        WorkDirectionTypeId
    FROM
        [CRM_1551_Site_Integration].[dbo].[AppealsFromSite]
    WHERE
        id = @appeal_from_site_id
) = 20 
BEGIN
INSERT INTO
    [dbo].[QuestionDocFiles] (
        [link],
        [create_date],
        [user_id],
        [edit_date],
        [edit_user_id],
        [name],
        [File],
        [question_id],
        --[GUID],
        [IsArchive],
        [PathToArchive]
    )
SELECT
    NULL [link],
    GETUTCDATE() [create_date],
    @user_id [user_id],
    GETUTCDATE() [edit_date],
    @user_id [edit_user_id],
    N'answer_' + ISNULL(@name, N'') [name],
    @file [File],
    (
        SELECT
            TOP 1 [Questions].Id
        FROM
            [dbo].[Appeals] [Appeals]
            LEFT JOIN [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] [AppealsFromSite] ON [AppealsFromSite].Appeal_Id = [Appeals].Id
            INNER JOIN [dbo].[Questions] [Questions] ON [Appeals].Id = [Questions].appeal_id
        WHERE
            [AppealsFromSite].Id = @appeal_from_site_id
            OR [Appeals].Id = @appeal_id
            OR [Questions].Id = @question_id
    ) [question_id],
    --,[GUID]
    NULL [IsArchive],
    NULL [PathToArchive];

END