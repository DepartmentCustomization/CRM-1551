SELECT c.[Id]
      ,c.[registration_date]
      ,ct.[name] as complain_type_name
      ,ct.id as complain_type_id
      ,c.[culpritname]
      ,c.[guilty] as guilty_id
      ,c.[text]
      ,w.[name] as [user_name]
      ,w.Id as [user_id]
	  ,ISNULL([LastName], N'') + N' ' + ISNULL([FirstName],N'')
	  +N' '	 +ISNULL([Patronymic], N'') guilty_name
  FROM [dbo].[Complain] c 
	left join ComplainTypes ct on ct.Id = c.complain_type_id
	left join Workers w on w.worker_user_id = c.[user_id]
	left join CRM_1551_System.dbo.[User] u on u.UserId = c.[guilty]
where c.Id = @Id