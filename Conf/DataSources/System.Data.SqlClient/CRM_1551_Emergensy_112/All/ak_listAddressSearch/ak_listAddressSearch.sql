  --DECLARE @search NVARCHAR(100)=N'Ломоносова';

  

-- наша входная строка с айдишниками
DECLARE @input_str NVARCHAR(MAX) = @search+N' ';
-- создаем таблицу в которую будем
-- записывать наши айдишники
DECLARE @table TABLE (id NVARCHAR(200));
-- создаем переменную, хранящую разделитель
DECLARE @delimeter NVARCHAR(1) = ' ';
-- определяем позицию первого разделителя
DECLARE @pos INT = charindex(@delimeter,@input_str);
-- создаем переменную для хранения
-- одного айдишника
DECLARE @id NVARCHAR(200);
WHILE (@pos != 0)
BEGIN
    -- получаем айдишник
    SET @id = SUBSTRING(@input_str, 1, @pos-1);
    -- записываем в таблицу
    INSERT INTO @table (id) VALUES(@id);
    -- сокращаем исходную строку на
    -- размер полученного айдишника
    -- и разделителя
    SET @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str));
    -- определяем позицию след. разделителя
    SET @pos = CHARINDEX(@delimeter,@input_str);
END

DECLARE @ex_parameter NVARCHAR(MAX)=

CASE 
WHEN @search IS NULL OR @search=N' ' OR @search=N','
THEN N'1=2'
ELSE
(SELECT STUFF(
(SELECT N' AND AddressSearch LIKE''%'+Id+N'%''' 
FROM @table
FOR XML PATH('')), 1, 4, N'')) END;


  DECLARE @exec NVARCHAR(MAX)=

  N'SELECT Id, geolocation_lat, geolocation_lon, AddressSearch
  FROM
  (SELECT b.Id, o.geolocation_lat, o.geolocation_lon, 
  ISNULL(s.name+N'' '',N'''')+ISNULL(LTRIM(b.number),N'''')+ISNULL(b.letter,N'''') AddressSearch
  FROM [CRM_1551_Analitics].[dbo].[Buildings] b 
  INNER JOIN [CRM_1551_Analitics].[dbo].[Objects] o ON o.builbing_id=b.Id
  INNER JOIN [CRM_1551_Analitics].[dbo].Streets s ON b.street_id=s.Id
  WHERE o.geolocation_lat IS NOT NULL AND o.geolocation_lon IS NOT NULL
  ) t
  WHERE '+@ex_parameter;
  
  EXEC(@exec);