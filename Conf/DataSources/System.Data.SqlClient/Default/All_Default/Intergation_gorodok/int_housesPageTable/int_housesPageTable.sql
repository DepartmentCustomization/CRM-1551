
SELECT 
         done.id as Id
    	,operation
		,(select name from Districts where id = old.district_id) as become_district_name
    	,old.district_id as become_district
    	,old.name as become
		,(select name from Districts where id = new.district_id) as it_was_district_name
    	,new.district_id as it_was_district
    	,new.name as it_was
    	,strs.name + ' ' + sty.shortname +' буд.'+ st.name as  name_1551
    	,st.Id as id_1551
    	,done.is_done
    	,done.comment
    	,cat.Id as cat_id
    	,st.district_id
	from [CRM_1551_GORODOK_Integrartion].[dbo].[Done_values_in_directories] as done
    	left join [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_houses_old] as old on old.id = done.delete_id
    	left join [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_houses_new] as new on new.id = done.values_id
    	left join [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] as cat on cat.gorodok_houses_id = old.id or cat.gorodok_houses_id = new.id
    	left join [dbo].[Buildings] as st on st.Id = cat.[1551_houses_id]
		left join [dbo].Streets as strs on strs.Id = st.street_id
		left join StreetTypes as sty on sty.Id = strs.street_type_id
	where done.is_done = 0
	and done.program = 'gorodok' and done.integration_tables_code = 'houses'
-- and #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only