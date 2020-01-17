    declare   @querytosql nvarchar(max)
declare   @OPENQUERY nvarchar(max)
declare   @send_query nvarchar(max)
set @querytosql='
select Id, Name from service_types where id in (1,2,3,4) limit 10
' 

SET @OPENQUERY = 'SELECT * FROM OPENQUERY([GORODOK],'''
set @send_query =@OPENQUERY+@querytosql+''')'


exec sp_executesql @send_query