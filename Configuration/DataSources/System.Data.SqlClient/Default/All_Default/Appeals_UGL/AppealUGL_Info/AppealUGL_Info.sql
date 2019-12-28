-- DECLARE @Id INT = 5399849;
DECLARE @uglId INT = (
  SELECT TOP 1 Id
  FROM [Звернення УГЛ]
  WHERE Appeals_id = @Id
) 
DECLARE @full_phone1 NVARCHAR(500) = (
  SELECT
    TOP 1 Телефон
  FROM
    [Звернення УГЛ]
  WHERE
    Id = @uglId
) 

DECLARE @numbers TABLE (rownum INT, uglId INT, num NVARCHAR(15));

INSERT INTO
  @numbers
SELECT
  ROW_NUMBER() OVER(
    ORDER BY
      value ASC
  ),
  @uglId,
  value 
  FROM
  string_split(@full_phone1, ',');

UPDATE
  @numbers
SET
  num = REPLACE(num, ' ', '')
UPDATE
  @numbers
SET
  num = CASE
    WHEN len(num) > 10 THEN CASE
      WHEN (LEFT(num, 2) = '38') THEN RIGHT(num, len(num) -2)
      WHEN (LEFT(num, 1) = '3')
      AND (LEFT(num, 2) <> '38') THEN RIGHT(num, len(num) -1)
      WHEN (LEFT(num, 1) = '8') THEN RIGHT(num, len(num) -1)
    END
    WHEN len(num) < 10
    AND (LEFT(num, 1) != '0') THEN N'0' + num
    ELSE num
  END declare @phone_qty int = (
    SELECT
      count(1)
    FROM
      @numbers
  );

DECLARE @step INT = 1;
DECLARE @full_phone2 NVARCHAR(500);
DECLARE @current_phone NVARCHAR(10);

WHILE (@step <= @phone_qty) 
BEGIN
SET
  @current_phone = (
    SELECT num
    FROM @numbers
    ORDER BY rownum ASC OFFSET @step-1 ROW FETCH NEXT 1 ROW ONLY
  );

SET @full_phone2 = isnull(@full_phone2, '') + IIF(
    len(@full_phone2) > 1,
    N', ' + @current_phone,
    @current_phone
  )
SET @step += 1;
END

SELECT TOP 1 
  [№ звернення] AS incomNum,
  @full_phone2 AS phone,
  @full_phone2 AS full_phone,
  CONVERT(varchar, [Дата завантаження],(120)) AS incomDate,
  Заявник AS Applicant_PIB,
  Зміст AS Question_Content,
  Заявник + + CHAR(13) + CASE
    WHEN Адреса IS NOT NULL THEN 'Адреса: ' + Адреса
    ELSE ''
  END + CHAR(13) + CASE
    WHEN [E-mail] IS NOT NULL THEN [E-mail]
    ELSE ''
  END + CASE
    WHEN [Соціальний стан] IS NOT NULL
    AND [E-mail] IS NOT NULL THEN ', Соц. стан: ' + [Соціальний стан]
    WHEN a.[Соціальний стан] IS NOT NULL
    AND a.[E-mail] IS NULL THEN 'Соц. стан: ' + [Соціальний стан]
    ELSE ''
  END + CASE
    WHEN a.Категорія IS NOT NULL
    AND [Соціальний стан] IS NOT NULL THEN (', ' + 'Категорія: ' + Категорія)
    WHEN Категорія IS NOT NULL
    AND [Соціальний стан] IS NULL THEN ('Категорія: ' + Категорія)
    ELSE ''
  END + CASE
    WHEN [Дата народження] IS NOT NULL
    AND Категорія IS NOT NULL THEN ', ' + cast([Дата народження] AS varchar)
    WHEN [Дата народження] IS NOT NULL
    AND a.Категорія IS NULL THEN cast([Дата народження] AS varchar)
    ELSE ''
  END AS ApplicantUGL,
  a.Id AS uglId,
  appeal.registration_number AS appealNum,
  Адреса AS applicantAddress
FROM
  dbo.[Звернення УГЛ] a
  JOIN Appeals appeal ON appeal.Id = a.Appeals_id
WHERE
  Appeals_id = @Id