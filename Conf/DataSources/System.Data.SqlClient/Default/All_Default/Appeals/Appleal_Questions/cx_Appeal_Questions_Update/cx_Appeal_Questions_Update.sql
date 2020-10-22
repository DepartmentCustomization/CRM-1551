



--сообщение начало
IF(isnull(@object_id, 0)< (SELECT case when [Object_is]='true' then 1 else 0 end [Object_is] 
from [dbo].[QuestionTypes] where Id=@question_type_id))
  BEGIN
    RAISERROR(N'Збереження змін неможливе. Внесіть необхідну інформацію', 16, 1);
    RETURN;
  END
--сообщение конец
ELSE
	BEGIN

DECLARE @zoneVal SMALLINT = DATEPART(TZOffset, SYSDATETIMEOFFSET());
IF(CAST(@control_date AS TIME) = '23:59:59')
BEGIN
	SET @control_date = DATEADD(MINUTE,-@zoneVal,@control_date);
END

DECLARE @ass_for_check INT = (
	SELECT
		last_assignment_for_execution_id
	FROM
		dbo.Questions
	WHERE
		Id = @Id
) ;

DECLARE @blago_Id INT = (SELECT 
								[question_type_id] 
							FROM [CRM_1551_Site_Integration].[dbo].[WorkDirectionTypes]
							WHERE Id = 20);
--> Обновление территории по объекту вопроса
IF(@question_type_id = @blago_Id)
BEGIN
	IF(@object_id <> (SELECT [object_id] FROM dbo.[Questions] WHERE Id = @Id))
	BEGIN
	DECLARE @objectTerritoryId INT = (SELECT 
											[id] 
									   FROM dbo.[Territories]
									   WHERE [object_id] = @object_id);
		IF(@objectTerritoryId IS NOT NULL)
		BEGIN 
		UPDATE dbo.[QuestionsInTerritory]
			SET [territory_id] = @objectTerritoryId
		WHERE [question_id] = @Id;
		END
		ELSE 
		--> Если территория объекта не найдена в БД, спрашиваем по API
		BEGIN
		DECLARE @object_lat NVARCHAR(MAX) = (SELECT [geolocation_lat] FROM dbo.[Objects] WHERE Id = @object_id); 
		DECLARE @object_lon NVARCHAR(MAX) = (SELECT [geolocation_lon] FROM dbo.[Objects] WHERE Id = @object_id);
		DECLARE @json TABLE (json_val NVARCHAR(MAX));
		DECLARE @request_val INT;
		DECLARE @response_val NVARCHAR(MAX);
		DECLARE @token INT;
		DECLARE @url NVARCHAR(MAX) = 'https://db.blagoustriy.kiev.ua/restapi/sectors/find?lat=' + @object_lat +'&lon=' + @object_lon;
		DECLARE @result_sector INT;
		DECLARE @result_district INT;
		DECLARE @result_territory_id INT;
		DECLARE @external_data_source_id INT;

		IF(@object_lat IS NULL) 
		OR(@object_lon IS NULL)
		BEGIN
			UPDATE dbo.[Questions]
				SET [object_id] = @object_id 
			WHERE Id = @Id;
			RETURN;
		END
		EXEC @request_val = sp_OACreate 'MSXML2.ServerXMLHTTP', @token OUT ;
		
		IF(@request_val <> 0)
		BEGIN
			RAISERROR('Error! Failed on creating HTTP request', 16, 1);
			RETURN;
		END
		
		EXEC @request_val = sp_OAMethod @token, 'open', NULL, 'GET', @url, 'false';
		EXEC @request_val = sp_OAMethod @token, 'send';
		
		INSERT INTO @json 
		EXEC sp_OAGetProperty @token, 'responseText';
		SET @response_val = (SELECT TOP 1 * FROM @json);

		IF(@response_val IS NULL)
		BEGIN
			RAISERROR('Error! HTTP response not contain data', 16, 1);
			RETURN;
		END
		--> Выбираем данные с json ответа
		SET @result_sector = (
		SELECT TOP 1
			[nSector]
		FROM OPENJSON(@response_val)
		WITH
		([nSector] INT '$.nSector')
		);

		SET @result_district = (
		SELECT TOP 1
			[nDistrict]
		FROM OPENJSON(@response_val)
		WITH
		([nDistrict] INT '$.nDistrict') 
		);
		SET @external_data_source_id = CAST(CAST((@result_district * 10) AS NVARCHAR) + CAST(@result_sector AS NVARCHAR) AS INT);
		SET @result_territory_id = (SELECT [Id] FROM dbo.[Territories] WHERE [external_data_source_id] = @external_data_source_id);
		--> апдейт полученой территорией
		UPDATE dbo.[QuestionsInTerritory]
			SET [territory_id] = @result_territory_id
		WHERE [question_id] = @Id;
		END
	END
END

UPDATE
	[dbo].[Questions]
SET
	[control_date] = @control_date,
	[question_type_id] = @question_type_id,
	[edit_date] = getutcdate(),
	[user_edit_id] = @user_edit_id,
	[question_content] = @question_content,
	[object_id] = @object_id,
	[organization_id] = @organization_id,
	[answer_form_id] = @answer_type_id,
	[answer_phone] = @answer_phone,
	[answer_post] = @answer_post,
	[answer_mail] = @answer_mail
WHERE
	Id = @Id ;
	--  execute define_status_Question  @Id
	IF @ass_for_check = (
		SELECT
			last_assignment_for_execution_id
		FROM
			dbo.Questions
		WHERE
			Id = @Id
	) 
	BEGIN 
	IF @perfom_id <> (
		SELECT
			executor_organization_id
		FROM
			dbo.Assignments
		WHERE
			Id = (
				SELECT
					last_assignment_for_execution_id
				FROM
					dbo.Questions
				WHERE
					Id = @Id
			)
	) 
BEGIN 
 DECLARE @output_con TABLE (Id INT);

DECLARE @assigment INT;

SELECT
	@assigment = Id
FROM
	dbo.Assignments
WHERE
	Id = (
		SELECT
			last_assignment_for_execution_id
		FROM
			dbo.Questions
		WHERE
			Id = @Id
	) ;
UPDATE
	[dbo].[Assignments]
SET
	[executor_organization_id] = @perfom_id, -- новый исполнитель на кого переопределили
	--,[execution_date]= @execution_date  
	executor_person_id = NULL,
	organization_id = @perfom_id,
	[edit_date] = getutcdate(),
	[user_edit_id] = @user_edit_id,
	LogUpdated_Query = N'cx_Appeal_Questions_Update_ROW33'
WHERE
	Id = @assigment ;

UPDATE
	dbo.AssignmentConsiderations
SET
	[edit_date] = getutcdate(),
	[user_edit_id] = @user_edit_id,
	[consideration_date] = getutcdate()
WHERE
	Id = (
		SELECT
			current_assignment_consideration_id
		FROM
			dbo.Assignments
		WHERE
			Id = (
				SELECT
					last_assignment_for_execution_id
				FROM
					dbo.Questions
				WHERE
					Id = @Id
			)
	) ;
INSERT INTO
	dbo.AssignmentConsiderations (
		[assignment_id],
		[consideration_date],
		[assignment_result_id],
		[assignment_resolution_id],
		[user_id],
		[edit_date],
		[user_edit_id],
		[first_executor_organization_id],
		create_date,
		transfer_date
	) output inserted.Id INTO @output_con([Id])
VALUES
(
		@assigment,
		GETUTCDATE(),
		1,
		NULL,
		@user_edit_id,
		GETUTCDATE(),
		@user_edit_id,
		@perfom_id -- новый исполнитель на кого переопределили
,
		GETUTCDATE(),
		GETUTCDATE()
	) ;
DECLARE @new_con INT ;

SET
	@new_con = (
		SELECT
			TOP (1) Id
		FROM
			@output_con
	) ;

UPDATE
	dbo.[Assignments]
SET
	current_assignment_consideration_id = @new_con,
	[edit_date] = getutcdate()
WHERE
	Id = @assigment ;
END
END
END