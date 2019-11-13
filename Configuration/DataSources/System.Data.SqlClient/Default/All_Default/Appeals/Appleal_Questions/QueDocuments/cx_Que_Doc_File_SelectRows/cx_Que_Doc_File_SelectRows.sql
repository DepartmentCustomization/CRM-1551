/*
SELECT [Id]
      ,[create_date]
      ,[name] as [Name]
      ,[File]
  FROM [dbo].[QuestionDocFiles]
  where question_doc_id = @Id
  and [File] is not null
  and #filter_columns#
		#sort_columns#
	offset @pageOffsetRows rows fetch next @pageLimitRows rows only
	
	*/
 SELECT 
  Id,
  question_doc_id,	
  link,	
  create_date,	
  [user_id],	
  edit_date,	
  edit_user_id,	
  [name] as [Name],	
  [File]
  FROM [dbo].[QuestionDocFiles]
  where question_doc_id = @Id
  and [File] is not null
  and #filter_columns#
	--	#sort_columns#
	order by 1
	offset @pageOffsetRows rows fetch next @pageLimitRows rows only