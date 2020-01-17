select  Districts.Id
	  ,Districts.name
	from Districts
-- 	left join Buildings on Buildings.district_id = Districts.Id
	where Districts.Id in (select distinct district_id from Buildings where street_id = @district)
	and Id != 11
    -- and 	#filter_columns#
    --         #sort_columns#
    --     offset @pageOffsetRows rows fetch next @pageLimitRows rows only