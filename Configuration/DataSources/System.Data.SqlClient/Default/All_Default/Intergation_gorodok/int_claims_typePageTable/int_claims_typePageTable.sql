SELECT 
         done.id as Id
    	,operation
    	,old.name as become
    	,new.name as it_was
    	,done.is_done
    	,done.comment
	from [CRM_1551_GORODOK_Integrartion].[dbo].[Done_values_in_directories] as done
    	left join [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_old] as old on old.id = done.delete_id
    	left join [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_new] as new on new.id = done.values_id
    	
	where done.is_done = 0
	and done.program = 'gorodok' and done.integration_tables_code = 'claims_type'