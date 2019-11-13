 select 
		Id
-- 		,IIF (len([head_name]) > 5,  concat([head_name] , ' ( ' , [short_name] , ')'),  [short_name]) as full_name
		,case when len([head_name]) > 5 then [head_name] + ' ( ' + [short_name] + ')'
					else [short_name] end as full_name
  from [dbo].[Organizations]
    -- where Organizations.Id @OrgFilter
    where programworker = 1
    and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only