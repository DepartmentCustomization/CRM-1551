  --declare @user_id nvarchar(128)=N'Вася';

  select [FiltersForControler].Id, [organization_id], [Organizations].short_name name
  from [CRM_1551_Analitics].[dbo].[FiltersForControler]
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [FiltersForControler].organization_id=[Organizations].Id
  where [FiltersForControler].organization_id is not null and [FiltersForControler].user_id=@user_id