--declare @Id int =4;

SELECT [Positions].[Id]
      ,[Positions].[parent_id]
      ,[Positions].[position_code]
      ,[Positions].[position]
      ,[Positions].[phone_number]
      ,[Positions].[address]
      ,[Positions].[name]
      ,[Positions].[active]
      ,[Positions].[user_id]
      ,[Positions].[edit_date]
      ,[Positions].[user_edit_id]
	  ,[Workers].name [user_name]
	  ,[Positions2].position [position_parent]
	  ,[Positions].[organizations_id] [organization_id]
	  ,[Organizations].short_name
      ,[Positions].[role_id]
	  ,[Roles].name [role_name]
      ,[Positions].[programuser_id]
	  ,[User].UserName 
	  --,[User2].UserName [programuser_name]
	  ,isnull([User2].LastName, N'')+N' '+isnull([User2].[FirstName], N'')+N' '+isnull([User2].[Patronymic], N'') [programuser_name]
      ,[Positions].[is_main]
      ,[Positions].[Id] [position_id]
  FROM [CRM_1551_Analitics].[dbo].[Positions]
  left join [CRM_1551_Analitics].[dbo].[Workers] on [Positions].user_edit_id=[Workers].worker_user_id
  left join [CRM_1551_Analitics].[dbo].[Positions] [Positions2] on [Positions].parent_id=[Positions2].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Positions].[organizations_id]=[Organizations].Id
  left join [CRM_1551_Analitics].[dbo].[Roles] on [Positions].[role_id]=[Roles].Id
  left join [CRM_1551_System].[dbo].[User] on [Positions].[user_edit_id]=[User].UserId
  left join [CRM_1551_System].[dbo].[User] [User2] on [Positions].[programuser_id]=[User2].UserId
  where [Positions].Id=@Id