  /*DECLARE @fire BIT='false';
  DECLARE @police BIT='true';
  DECLARE @medical BIT='false';
  DECLARE @gas BIT='true';
*/

IF @fire='true' OR @police='true' OR @medical='true' OR @gas='true'
  BEGIN

  DECLARE @exec NVARCHAR(MAX)=N'

  WITH
  fire AS 
  (SELECT cis.category_id FROM [dbo].[CategoryInServices] cis WHERE cis.service_id=1),
  police AS 
  (SELECT cis.category_id FROM [dbo].[CategoryInServices] cis WHERE cis.service_id=2),
  medical AS 
  (SELECT cis.category_id FROM [dbo].[CategoryInServices] cis WHERE cis.service_id=3),
  gas AS 
  (SELECT cis.category_id FROM [dbo].[CategoryInServices] cis WHERE cis.service_id=4)

  SELECT c.id, c.name
  FROM [dbo].Categories c
  '+CASE WHEN @fire='true' THEN N'' ELSE N'--' END+N'INNER JOIN fire ON c.id=fire.category_id
  '+CASE WHEN @police='true' THEN N'' ELSE N'--' END+N'INNER JOIN police ON c.id=police.category_id
  '+CASE WHEN @medical='true' THEN N'' ELSE N'--' END+N'INNER JOIN medical ON c.id=medical.category_id
  '+CASE WHEN @gas='true' THEN N'' ELSE N'--' END+N'INNER JOIN gas ON c.id=gas.category_id
  '

  EXEC(@exec)

  END

/*
  SELECT id, t.Name
  FROM (
  SELECT DISTINCT c.Id, c.Name
  FROM [dbo].[CategoryInServices] cis
  INNER JOIN [dbo].Categories c ON cis.category_id=c.id
  WHERE cis.service_id IN
  (SELECT CASE WHEN @fire='true' THEN 1 ELSE 0 END id
  UNION
  SELECT CASE WHEN @police='true' THEN 2 ELSE 0 END id
  UNION
  SELECT CASE WHEN @medical='true' THEN 3 ELSE 0 END id
  UNION
  SELECT CASE WHEN @gas='true' THEN 4 ELSE 0 END Id)) t
  WHERE  #filter_columns#
  --#sort_columns#
  ORDER BY 1
 offset @pageOffsetRows ROWS FETCH NEXT @pageLimitRows ROWS only*/