DECLARE @Organization TABLE (
	Id INT
);

DECLARE @OrganizationId INT = @organization_id;

DECLARE @IdT TABLE (
	Id INT
);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
INSERT INTO @IdT (Id)
	SELECT
		Id
	FROM [CRM_1551_Analitics].[dbo].[Organizations]
	WHERE (Id = @OrganizationId
	OR [parent_organization_id] = @OrganizationId)
	AND Id NOT IN (SELECT
			Id
		FROM @IdT);

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
WHILE (SELECT
		COUNT(Id)
	FROM (SELECT
			Id
		FROM [CRM_1551_Analitics].[dbo].[Organizations]
		WHERE [parent_organization_id] IN (SELECT
				Id
			FROM @IdT) --or Id in (select Id from @IdT)
		AND Id NOT IN (SELECT
				Id
			FROM @IdT)) q)
!= 0
BEGIN

INSERT INTO @IdT
	SELECT
		Id
	FROM [CRM_1551_Analitics].[dbo].[Organizations]
	WHERE [parent_organization_id] IN (SELECT
			Id
		FROM @IdT) --or Id in (select Id from @IdT)
	AND Id NOT IN (SELECT
			Id
		FROM @IdT);
END

INSERT INTO @Organization (Id)

	SELECT
		Id
	FROM @IdT;

SELECT
	Id
   ,name
	-- ,short_name
   ,CONCAT([short_name], ' ( ' + address + ')') AS [short_name]
FROM [CRM_1551_Analitics].[dbo].[Organizations]
WHERE Id NOT IN (SELECT
		Id
	FROM @Organization o)
AND #filter_columns# 
  #sort_columns#
 OFFSET @pageOffsetRows ROWS
FETCH NEXT @pageLimitRows ROWS only


