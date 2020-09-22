-- DECLARE @user_id NVARCHAR(128) = '016cca2b-dcd8-437e-8754-d4ff679ef6b9';

DECLARE @user_org_str TABLE (Id INT); 
INSERT INTO @user_org_str
SELECT 
	OrganisationStructureId 
FROM [#system_database_name#].dbo.[UserInOrganisation] 
WHERE UserId = @user_id;
IF OBJECT_ID('tempdb..#Complains') IS NOT NULL
BEGIN
	DROP TABLE #Complains;
END

CREATE TABLE #Complains ([Id] INT,
						 [registration_date] DATETIME,
						 [complain_type_name] NVARCHAR(100),
						 [culpritname] NVARCHAR(200),
						 [guilty] NVARCHAR(128),
						 [text] NVARCHAR(2000),
						 [user_name] NVARCHAR(200)) 
             WITH (DATA_COMPRESSION = PAGE); 

---> Выборка всех для админов и главарей КБУ
IF EXISTS (SELECT Id FROM @user_org_str WHERE Id IN (2,4))
BEGIN
INSERT INTO #Complains
SELECT
  [Complain].[Id],
  [Complain].[registration_date],
  ComplainTypes.name AS complain_type_name,
  [Complain].[culpritname],
  [Complain].[guilty],
  [Complain].[text],
  Workers.name AS [user_name]
FROM
  [dbo].[Complain] [Complain] 
  LEFT JOIN [dbo].[ComplainTypes] [ComplainTypes] ON ComplainTypes.Id = Complain.complain_type_id
  LEFT JOIN [dbo].[Workers] [Workers] ON Workers.worker_user_id = Complain.[user_id] 
;
END

---> Выборка по подчиненным организациям пользователя, который смотрит (если он не админ или главарь КБУ)
ELSE 
BEGIN
DECLARE @RootUserOrg INT;
SELECT @RootUserOrg = organizations_id
FROM dbo.Positions 
WHERE programuser_id = @user_id ;

DECLARE @DotersOfUserOrgs TABLE (Id INT);
WITH RecursiveOrg (Id, parentID) AS (
    SELECT
        o.Id,
        parent_organization_id
    FROM
        [dbo].[Organizations] o
    WHERE
        o.Id = @RootUserOrg
    UNION
    ALL
    SELECT
        o.Id,
        o.parent_organization_id
    FROM
        [dbo].[Organizations] o
        INNER JOIN RecursiveOrg r ON o.parent_organization_id = r.Id
)

INSERT INTO @DotersOfUserOrgs
SELECT 
DISTINCT 
	Id
FROM RecursiveOrg
WHERE Id <> @RootUserOrg;

INSERT INTO #Complains
SELECT
  [Complain].[Id],
  [Complain].[registration_date],
  ComplainTypes.name AS complain_type_name,
  [Complain].[culpritname],
  [Complain].[guilty],
  [Complain].[text],
  Workers.name AS [user_name]
FROM
  [dbo].[Complain] [Complain] 
  LEFT JOIN [dbo].[Positions] [Positions] ON [Complain].guilty = [Positions].programuser_id
  LEFT JOIN [dbo].[ComplainTypes] [ComplainTypes] ON [ComplainTypes].Id = [Complain].complain_type_id
  LEFT JOIN [dbo].[Workers] [Workers] ON [Workers].worker_user_id = [Complain].[user_id]
  WHERE [Positions].organizations_id IN (SELECT Id FROM @DotersOfUserOrgs);
END

SELECT 
	[Id],
	[registration_date],
	[complain_type_name],
	[culpritname],
	[guilty],
	[text],
	[user_name] 
FROM #Complains
WHERE
  #filter_columns#
  #sort_columns#
  OFFSET @pageOffsetRows ROWS FETCH next @pageLimitRows ROWS ONLY 
 ;