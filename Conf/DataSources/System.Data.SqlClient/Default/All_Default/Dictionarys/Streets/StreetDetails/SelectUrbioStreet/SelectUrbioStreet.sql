select distinct ud.name_fullName as district,
us.name_fullToponym as streetType, 
us.name_fullName as streetName
from Streets s 
join [CRM_1551_URBIO_Integrartion].[dbo].[streets] us on us.id = s.urbio_id
join [CRM_1551_URBIO_Integrartion].[dbo].[districts] ud on us.ofDistrict_id = ud.id
where s.Id = @Id
and
#filter_columns#
#sort_columns#
  --  offset @pageOffsetRows rows fetch next @pageLimitRows rows only