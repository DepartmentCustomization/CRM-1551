select ec.Id, ec.name, ec.global_id, gt.name as globalType, 
ec.event_type_id as eventClassTypeId,
et.name as eventClassTypeName
from Event_Class ec
join EventTypes et on et.id = ec.event_type_id
left join [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_new] 
gt on ec.global_id = gt.id 
where ec.Id = @Id;