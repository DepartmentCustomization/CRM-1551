SELECT 
         done.id as Id
    	,operation
    	,old.name as become
    	,new.name as it_was
    -- 	,st.name as  name_1551
    -- 	,st.Id as id_1551
    	,done.is_done
    	,done.comment
    -- 	,cat.Id as cat_id
	from [CRM_1551_GORODOK_Integrartion].[dbo].[Done_values_in_directories] as done
    	left join [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_streets_old] as old on old.id = done.delete_id
    	left join [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_streets_new] as new on new.id = done.values_id
    -- 	left join [CRM_1551_GORODOK_Integrartion].[dbo].[Programs_1551_catalog] as cat on cat.integration_tables_id = old.id or cat.integration_tables_id = new.id
    -- 	left join dbo.Streets as st on st.Id = cat.[1551_id]
where done.is_done = 0
    and done.integration_tables_code = 'claims_type' and done.program = 'gorodok'
-- #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only