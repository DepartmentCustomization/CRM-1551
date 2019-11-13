SELECT [Complain].[Id]
      ,[Complain].[registration_date]
      ,ComplainTypes.name as complain_type_name
      ,[Complain].[culpritname]
      ,[Complain].[guilty]
      ,[Complain].[text]
      ,Workers.name as [user_name]
  FROM [dbo].[Complain]
	left join ComplainTypes on ComplainTypes.Id = Complain.complain_type_id
	left join Workers on Workers.worker_user_id = Complain.user_id
	where #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only