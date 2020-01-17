-- declare @user_id nvarchar(128)=N'Вася'
 
  SELECT 
      [Organizations].short_name+N'-'+
	  case when [FiltersForControler].[questiondirection_id]=0 then N'Усі' else [QuestionTypes].name end--+N'-'+ 
	  filter_name

	  ,[FiltersForControler].[Id]
      ,[FiltersForControler].[district_id]
      ,[FiltersForControler].[questiondirection_id]
      ,[Organizations].short_name [district_name]
	  ,case when [FiltersForControler].[questiondirection_id]=0 then N'Усі' else [QuestionTypes].name end [questiondirection_name]
  FROM [CRM_1551_Analitics].[dbo].[FiltersForControler]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [FiltersForControler].district_id=[Organizations].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [FiltersForControler].questiondirection_id=[QuestionTypes].Id
  where [district_id] is not null and [questiondirection_id] is not null and [FiltersForControler].[user_id]=@user_id
  
  /*
SELECT 
      case when [FiltersForControler].[district_id]=0 then N'Усі' else [Districts].name end+N'-'+
	  case when [FiltersForControler].[questiondirection_id]=0 then N'Усі' else [QuestionTypes].name end--+N'-'+ 
	  --case when [FiltersForControler].[organization_id]=0 then N'Усі' else [Organizations].short_name end 
	  filter_name

	  ,[FiltersForControler].[Id]
      ,[FiltersForControler].[district_id]
      ,[FiltersForControler].[questiondirection_id]
	  --,[FiltersForControler].[organization_id] [department_id]
      ,case when [FiltersForControler].[district_id]=0 then N'Усі' else [Districts].name end [district_name]
	  ,case when [FiltersForControler].[questiondirection_id]=0 then N'Усі' else [QuestionTypes].name end [questiondirection_name]
     -- ,case when [FiltersForControler].[organization_id]=0 then N'Усі' else [Organizations].short_name end [department_name]
  FROM [CRM_1551_Analitics].[dbo].[FiltersForControler]
  left join [CRM_1551_Analitics].[dbo].[Districts] on [FiltersForControler].district_id=[Districts].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [FiltersForControler].questiondirection_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [FiltersForControler].organization_id=[Organizations].Id
  where [district_id] is not null and [questiondirection_id] is not null and [FiltersForControler].[user_id]=@user_id
   */