select ao.ofDistrict_name_fullName + ' ' + [ofDistrict_name_shortToponym] + ', '
+ [ofStreet_name_shortToponym] + ' ' +ao.ofStreet_name_fullName
+ ', ' + ao.name_ofFirstLevel_fullName as bName,
ao.category_fullText as bType, ao.name_ofFirstLevel_fullToponym as inhabitable
from CRM_1551_Analitics.dbo.Buildings b 
join CRM_1551_URBIO_Integrartion.dbo.[addressObject] ao on b.urbio_id = ao.id
where b.Id = @Id
and #filter_columns#
    #sort_columns#
-- offset @pageOffsetRows rows fetch next @pageLimitRows rows only