DECLARE @info TABLE (
      guiltyId NVARCHAR(128),
      complainId INT,
      COMMENT NVARCHAR(2000)
);

INSERT INTO
      [dbo].[Complain] (
            [registration_date],
            [complain_type_id],
            [culpritname],
            [guilty],
            [text],
            [user_id]
      ) OUTPUT 
      inserted.[guilty],
      inserted.[Id],
      inserted.[text] INTO @info(guiltyId, complainId, COMMENT)
VALUES
      (
            GETUTCDATE(),
            @complain_type_id,
            @culpritname,
            @guilty,
            @text,
            @user_id
      );

---> Отправить нотификацию на родительскую должность виновника жалобы
DECLARE @ComplainID INT = (
      SELECT
            TOP 1 complainId
      FROM
            @info
);

DECLARE @guiltyUser NVARCHAR(128) = (
      SELECT
            TOP 1 guiltyId
      FROM
            @info
);

IF (@guiltyUser IS NOT NULL) 
BEGIN 
DECLARE @ParentOfGuiltyPositionID TABLE (Id INT);

INSERT INTO
      @ParentOfGuiltyPositionID(Id)
SELECT
      parent_id
FROM
      [dbo].[Positions]
WHERE
      programuser_id = @guiltyUser;

IF(
      SELECT
            COUNT(1)
      FROM
            @ParentOfGuiltyPositionID
) > 0 
BEGIN 
DECLARE @ParentOfGuiltyUserID TABLE(Id NVARCHAR(128));

INSERT INTO
      @ParentOfGuiltyUserID
SELECT
      programuser_id
FROM
      [dbo].[Positions]
WHERE
      Id IN (
            SELECT
                  Id
            FROM
                  @ParentOfGuiltyPositionID
      )
      AND programuser_id IS NOT NULL;

IF(
      SELECT
            COUNT(1)
      FROM
            @ParentOfGuiltyUserID
) = 0 
BEGIN
INSERT INTO
      @ParentOfGuiltyUserID
SELECT
      programuser_id
FROM
      [dbo].[Positions]
WHERE
      Id IN (
            SELECT
                  helper_position_id
            FROM
                  dbo.[PositionsHelpers]
            WHERE
                  main_position_id IN (
                        SELECT
                              Id
                        FROM
                              @ParentOfGuiltyPositionID
                  )
      )
      AND programuser_id <> @guiltyUser;

END 
IF(
      SELECT
            COUNT(1)
      FROM
            @ParentOfGuiltyUserID
) > 0 
BEGIN 
DECLARE @Sender NVARCHAR(128) = (
      SELECT
            UserId
      FROM
            [#system_database_name#].[dbo].[User]
      WHERE
            UserName = 'Administrator'
);

DECLARE @Comment NVARCHAR(2000) = (
      SELECT
            TOP 1 COMMENT
      FROM
            @info
);

DECLARE @quiltyUserPIB NVARCHAR(300) = (
      SELECT
            ISNULL([LastName], N'') + N' ' + ISNULL([FirstName], N'') + N' ' + ISNULL([Patronymic], N'')
      FROM
            [#system_database_name#].[dbo].[User]
      WHERE
            UserId = @guiltyUser
);

INSERT INTO
      [#system_database_name#].dbo.[Notification] (
            CreatedOn,
            [Url],
            [NotificationTypeId],
            [SenderId],
            [Text],
            [NotificationPriorityId],
            [RecipientId],
            [Read],
            [HasAudio]
      )
SELECT
      GETUTCDATE(),
      N'/sections/Complains/view/' + CAST(@ComplainID AS NVARCHAR(20)),
      7,
      @Sender,
      @quiltyUserPIB + N' ' + @Comment,
      3,
      parent.Id,
      0,
      1
FROM
      @ParentOfGuiltyUserID parent
WHERE
      parent.Id IN (
            SELECT
                  UserId
            FROM
                  [#system_database_name#].[dbo].[User]
      );

END -- check @ParentOfGuiltyUserID
END -- check @ParentOfGuiltyPositionID
END -- check @guiltyUser
IF(@ComplainID IS NOT NULL) 
BEGIN
SELECT
      N'OK' AS result;

END