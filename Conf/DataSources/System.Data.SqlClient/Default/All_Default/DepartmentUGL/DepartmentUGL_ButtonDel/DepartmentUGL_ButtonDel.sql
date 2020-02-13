--DECLARE @Ids NVARCHAR(MAX)=N'17003,17004,17005,17006';

-- наша входная строка с айдишниками
DECLARE @input_str NVARCHAR(MAX) = @Ids + N',';
-- создаем таблицу в которую будем
-- записывать наши айдишники
DECLARE @table TABLE (
	id INT
);
-- создаем переменную, хранящую разделитель
DECLARE @delimeter NVARCHAR(1) = ',';
-- определяем позицию первого разделителя
DECLARE @pos INT = CHARINDEX(@delimeter, @input_str);
-- создаем переменную для хранения
-- одного айдишника
DECLARE @id NVARCHAR(10);
WHILE (@pos != 0)
BEGIN
-- получаем айдишник
SET @id = SUBSTRING(@input_str, 1, @pos - 1);
-- записываем в таблицу
INSERT INTO @table (id)
	VALUES (CAST(@id AS INT));
-- сокращаем исходную строку на
-- размер полученного айдишника
-- и разделителя
SET @input_str = SUBSTRING(@input_str, @pos + 1, LEN(@input_str));
-- определяем позицию след. разделителя
SET @pos = CHARINDEX(@delimeter, @input_str);
END
--SELECT *
--FROM @table;


DELETE FROM [dbo].[Звернення УГЛ]
WHERE [Опрацьовано] = 'false'
	AND id IN (SELECT
			id
		FROM @table);