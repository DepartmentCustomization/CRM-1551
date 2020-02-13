--DECLARE @user_Id NVARCHAR(128) = N'29796543-b903-48a6-9399-4840f6eac396';

DECLARE @Organization TABLE (
	Id INT
);
WITH cte1 -- все подчиненные 3 и 3
AS
(SELECT
		Id
	   ,[parent_organization_id] ParentId
	FROM [dbo].[Organizations] t
	WHERE Id IN (SELECT DISTINCT
			[organization_id]
		FROM [dbo].[Workers]
		WHERE worker_user_id = @user_Id)
	UNION ALL
	SELECT
		tp.Id
	   ,[parent_organization_id] ParentId
	FROM [dbo].[Organizations] tp
	INNER JOIN cte1 curr
		ON tp.[parent_organization_id] = curr.Id)

INSERT INTO @Organization (Id)
	SELECT
		Id
	FROM cte1;

-- показать всех, кто в 1761 и роль администратора 7

-- подорганизации 1761 начало

DECLARE @Organization1761 TABLE (
	Id INT
);

WITH cte1 -- все подчиненные 3 и 3
AS
(SELECT
		Id
	   ,[parent_organization_id] ParentId
	FROM [dbo].[Organizations] t
	WHERE Id = 1761
	UNION ALL
	SELECT
		tp.Id
	   ,[parent_organization_id] ParentId
	FROM [dbo].[Organizations] tp
	INNER JOIN cte1 curr
		ON tp.[parent_organization_id] = curr.Id)

INSERT INTO @Organization1761 (cte1.Id)
	SELECT
		Id
	FROM cte1;


-- 1761 конец

-- 7 начало
DECLARE @ad INT = (SELECT DISTINCT
		d
	FROM (SELECT
			CASE
				WHEN [roles_id] = 7 THEN 7
				ELSE NULL
			END d
		FROM [dbo].[Workers]
		WHERE [worker_user_id] = @user_Id) t
	WHERE d IS NOT NULL);
-- 7 конец


--сам запрос

IF @ad=7 OR EXISTS(SELECT Id FROM @Organization1761 WHERE id IN (SELECT DISTINCT organization_id
  FROM [dbo].[Workers]
  WHERE [worker_user_id]=@user_id))

	BEGIN
		SELECT Id, short_name
		FROM [dbo].[Organizations]
		/**/WHERE #filter_columns#
  #sort_columns#
 offset @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS only 
	END

ELSE
	BEGIN
		SELECT [Organizations].Id, [Organizations].short_name
		FROM @Organization o INNER JOIN [Organizations] ON o.Id=[Organizations].Id
	

/**/WHERE #filter_columns#
  #sort_columns#
 offset @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS only 
END
