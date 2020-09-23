select [id] as Id,
[name] as [Name]

from [dbo].[KnowledgeBaseStates]
  WHERE 
	#filter_columns#
    --  #sort_columns#
    order by [parent_id], [child_position]
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only