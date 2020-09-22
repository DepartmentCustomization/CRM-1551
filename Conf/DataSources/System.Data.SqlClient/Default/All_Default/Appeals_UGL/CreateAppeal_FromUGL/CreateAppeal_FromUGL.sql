--declare @uglId int = 15371;
DECLARE @outId TABLE (Id INT);

DECLARE @Is_AppealCreated BIT;

SET
    @Is_AppealCreated = (
        SELECT
            CASE
                WHEN Appeals_Id IS NOT NULL 
				THEN 1
                ELSE 0
            END
        FROM
            dbo.[Звернення УГЛ]
        WHERE
            Id = @uglId
    ) ;
IF (@Is_AppealCreated = 0) 
BEGIN 
BEGIN TRY
BEGIN TRANSACTION;

DECLARE @phone NVARCHAR(15);

SET
    @phone = (
        SELECT
            IIF(
                charindex(',', Телефон) > 0,
                (substring(Телефон, 1, 10)),
                Телефон
            )
        FROM
             dbo.[Звернення УГЛ]
        WHERE
            Id = @uglId
    );
INSERT INTO
    dbo.Appeals (
        registration_date,
		registration_number,
        receipt_source_id,
        phone_number,
        receipt_date,
        [start_date],
        [user_id],
        edit_date,
        user_edit_id,
        [LogUpdated_Query]
    ) 
output inserted.Id INTO @outId (Id)
VALUES
    (
        getutcdate(),
		(
			SELECT 
			case when not exists(
				select top 1 LTRIM(RIGHT(YEAR(getutcdate()),1))+N'-'+ltrim(substring(registration_number, 3, len(registration_number)-2)*1+1)
				from [dbo].[Appeals]
				where left(registration_number, 1) in (right(ltrim(year(getutcdate())),1))
				order by id desc
				)
			then LTRIM(RIGHT(YEAR(getutcdate()),1))+N'-1'
			else (select top 1 LTRIM(RIGHT(YEAR(getutcdate()),1))+N'-'+ltrim(substring(registration_number, 3, len(registration_number)-2)*1+1)
				from [dbo].[Appeals]
				where left(registration_number, 1) in (right(ltrim(year(getutcdate())),1))
				order by id desc)
			end
		),
        3,
        @phone,
        getutcdate(),
        getutcdate(),
        @user_id,
        getutcdate(),
        @user_id,
        N'query_CreateAppeal_FromUGL'
    ) ;
    DECLARE @newId INT = (
        SELECT
            TOP 1 Id
        FROM
            @outId
    );

UPDATE
    [dbo].[Appeals]
SET
    --registration_number = concat(
    --    SUBSTRING (rtrim(YEAR(getutcdate())), 4, 1),
    --    '-',
    --    (
    --        SELECT
    --            count(Id)
    --        FROM
    --             dbo.Appeals
    --        WHERE
    --            year(Appeals.registration_date) = year(getutcdate())
    --    )
    --),
    enter_number = (SELECT [№ звернення] FROM dbo.[Звернення УГЛ] WHERE Id = @uglId)
WHERE
    Id = @newId ;

UPDATE
    [dbo].[Звернення УГЛ]
SET
    Appeals_id = @newId,
    [Опрацював] = @user_id,
    [Дата опрацювання] = GETUTCDATE(),
    [Опрацьовано] = 1
WHERE
    Id = @uglId ;

SELECT
    @newId AS [Id] ;
    
	COMMIT;
	END TRY
BEGIN CATCH 
	ROLLBACK;
	RAISERROR (N'Помилка обробки! Дані не змінено.', 15, 1);
END CATCH;
END
ELSE 
BEGIN
SELECT
    Appeals_Id AS Id
FROM
     dbo.[Звернення УГЛ]
WHERE
    Id = @uglId;
     RETURN;
END