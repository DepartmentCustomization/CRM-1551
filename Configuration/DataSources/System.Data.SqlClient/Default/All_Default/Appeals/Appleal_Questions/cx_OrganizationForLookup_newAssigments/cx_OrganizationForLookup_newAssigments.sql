SELECT  [Id]
      ,[short_name]
	  ,head_name
  FROM [dbo].[Organizations]
  where programworker = 1
  and Id @Global_Org
  and  #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only