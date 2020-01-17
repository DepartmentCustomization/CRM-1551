select Id, [name] as [Name]
from QuestionTypes
 where 
	 #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only