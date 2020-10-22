DECLARE @updated TABLE (prevId INT);

UPDATE
    dbo.[Questions]
SET
    [object_id] = (
        SELECT
            Id
        FROM
            dbo.[Objects]
        WHERE
            builbing_id = @building
    ),
    [CodeOperation] = N'ChangeFromFormBuilding',
    [edit_date] = GETUTCDATE() 
    OUTPUT deleted.Id INTO @updated
WHERE
    Id IN (
        SELECT
            DISTINCT q.Id AS question
        FROM
            dbo.[Questions] q
            JOIN dbo.[Assignments] ass ON ass.question_id = q.Id
            JOIN dbo.[Objects] obj ON obj.Id = q.[object_id]
            JOIN dbo.[Buildings] b ON b.Id = obj.builbing_id
            JOIN dbo.[Organizations] o ON ass.executor_organization_id = o.Id
        WHERE
            b.Id = @Id
    );

UPDATE
    dbo.[EventObjects]
SET
    object_id = (
        SELECT
            Id
        FROM
            dbo.[Objects]
        WHERE
            builbing_id = @building
    )
WHERE
    object_id = (
        SELECT
            Id
        FROM
            dbo.[Objects]
        WHERE
            builbing_id = @Id
    );

UPDATE
    dbo.[LiveAddress]
SET
    building_id = @building,
	edit_date = GETUTCDATE(),
	user_edit_id = @user_id
	OUTPUT deleted.Id INTO @updated
WHERE
    applicant_id IN (
        SELECT
            a.Id AS applicant
        FROM
            dbo.[Applicants] a
            JOIN dbo.[LiveAddress] la ON la.applicant_id = a.Id
        WHERE
            la.building_id = @Id
    );

UPDATE
    dbo.[ExecutorInRoleForObject]
SET
    object_id = (
        SELECT
            Id
        FROM
            dbo.[Objects]
        WHERE
            builbing_id = @building
    ) -- building_id = @building 
WHERE
    Id IN (
        SELECT
            Id
        FROM
            dbo.[ExecutorInRoleForObject] ex
        WHERE
            object_id = @Id
    );

UPDATE
    dbo.[ValuesParamsObjects]
SET
    object_id = (
        SELECT
            Id
        FROM
            dbo.[Objects]
        WHERE
            builbing_id = @building
    )
WHERE
    object_id = (
        SELECT
            Id
        FROM
            dbo.[Objects]
        WHERE
            builbing_id = @Id
    );

SELECT
    *
FROM
    @updated;