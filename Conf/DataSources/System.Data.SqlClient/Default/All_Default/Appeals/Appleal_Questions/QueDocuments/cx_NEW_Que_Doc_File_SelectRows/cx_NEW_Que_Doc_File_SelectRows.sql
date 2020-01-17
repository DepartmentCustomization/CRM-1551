

 SELECT 
  Id,	
  create_date,		
  [name] as [Name],	
  [File]
  FROM [dbo].[QuestionDocFiles]
  where question_id =@Id
  and [File] is not null
  and #filter_columns#
	--	#sort_columns#
	order by 1
	offset @pageOffsetRows rows fetch next @pageLimitRows rows only