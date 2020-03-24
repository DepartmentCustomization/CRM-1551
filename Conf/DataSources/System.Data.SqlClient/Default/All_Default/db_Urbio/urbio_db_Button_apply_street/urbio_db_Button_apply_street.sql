 --declare @Urbio_Id nvarchar(300)=N'3226ad98-370f-11e7-95e9-000c29ff5864';
 --  declare @Analitics_Id int=1000;
 --  declare @Operation nvarchar(200)=N'Редагування';
 --  declare @comment nvarchar(100);--=N'коммент';
 --  declare @user_id nvarchar(128)=N'test';

--SET @Urbio_Id=CONVERT(NVARCHAR(128), @Urbio_Id);

IF @Operation=N'Видалення'
  BEGIN
		UPDATE [CRM_1551_Analitics].[dbo].[Streets]
	  SET [is_active]='false'
	  FROM [CRM_1551_Analitics].[dbo].[Streets] ans
	  WHERE ans.Id=@Analitics_Id--urbio_id IN (select value from #Ids)

	  UPDATE [CRM_1551_URBIO_Integrartion].[dbo].[streets]
	  SET is_done='true'
	  , done_date=getutcdate()
	  , [comment]=@comment
	  , [user_id]=@user_id
	  WHERE convert(nvarchar(128),Id)=@Urbio_Id --in (select value from #Ids)

  END
  
  IF @Operation=N'Додавання'
  BEGIN
		INSERT INTO [CRM_1551_Analitics].[dbo].[Streets]
	  (
	  [district_id]
		  ,[street_type_id]
		  ,[name]
		  ,[street_name_new_id]
		  ,[urbio_id]
		  ,[is_active]
		  ,[is_urbio_new]
	  )
	  
	  select d.Id [district_id] --в довідники Analitics.Districts  додати поле urbio_id?
		  ,ast.Id --в довідник  Analitics.Street_types додати name_shortToponym?
		  ,ISNULL(name_fullName+N' ', N'')+ISNULL(uniqueMarker_fullText+N' ',N'')+
		   ISNULL(history_fullName+N' ', N'')+ISNULL(history_shortToponym+N' ',N'') [name]
		  ,null [street_name_new_id]
		  ,convert(nvarchar(128),s.Id) [urbio_id]
		  ,'true' [is_active]
		  ,'true' [is_urbio_new]
	  FROM [CRM_1551_URBIO_Integrartion].[dbo].[streets] s
	  left join [CRM_1551_Analitics].[dbo].[StreetTypes] ast on s.[name_shortToponym]=ast.name_shortToponym
	  left join [CRM_1551_Analitics].[dbo].[Districts] d ON convert(nvarchar(128),s.ofDistrict_id)=d.urbio_id
	  where convert(nvarchar(128),s.Id)=@Urbio_Id 
	  --inner join #Ids i ON [streets].Id=i.value

	  UPDATE [CRM_1551_URBIO_Integrartion].[dbo].[streets]
	  SET is_done='true'
	  , done_date=getutcdate()
	  , [comment]=@comment
	  , [user_id]=@user_id
	  WHERE convert(nvarchar(128),Id)=@Urbio_Id--Id in (select value from #Ids)	

  END

  IF @Operation=N'Редагування'
  BEGIN
			UPDATE [CRM_1551_Analitics].[dbo].[Streets]
	  SET [district_id]=d.Id
		  ,[street_type_id]=ast.Id
		  ,[name]=ISNULL(us.name_fullName+N' ', N'')+ISNULL(us.uniqueMarker_fullText+N' ',N'')+
			ISNULL(us.history_fullName+N' ', N'')+ISNULL(us.history_shortToponym+N' ',N'')
		  --,[street_name_new_id]
		  --,[urbio_id]
		  ,[is_active]='true'
		  --,[is_urbio_new]
	  FROM [CRM_1551_Analitics].[dbo].[Streets] ans
	  INNER JOIN [CRM_1551_URBIO_Integrartion].[dbo].[streets] us ON ans.urbio_id=convert(nvarchar(128),us.Id)
	  left join [CRM_1551_Analitics].[dbo].[StreetTypes] ast on us.[name_shortToponym]=ast.name_shortToponym
	  left join [CRM_1551_Analitics].[dbo].[Districts] d ON convert(nvarchar(128),us.ofDistrict_id)=d.urbio_id
	  WHERE ans.Id=@Analitics_Id;--urbio_id IN (select value from #Ids)

	   UPDATE [CRM_1551_URBIO_Integrartion].[dbo].[streets]
	  SET is_done='true'
	  , done_date=getutcdate()
	  , [comment]=@comment
	  , [user_id]=@user_id
	  WHERE convert(nvarchar(128),Id)=@Urbio_Id --in (select value from #Ids)

  END

  DECLARE @table NVARCHAR(200)= N'streets'; 
  --declare @user_id nvarchar(123)=N'Вася';
  --DECLARE @urbio_id NVARCHAR(128)=@Urbio_Id;
  --declare @id_1551 int=13;
  --declare @comment nvarchar(123)=N'sdgss';
  --declare @operation_code nvarchar(23)=N'add'
  DECLARE @operation_code NVARCHAR(50)=CASE 
      WHEN @Operation=N'Додавання' THEN N'add'
      WHEN @Operation=N'Редагування' THEN N'change'
      WHEN @Operation=N'Видалення' THEN N'del'
      END;

USE [CRM_1551_URBIO_Integrartion]

EXEC [dbo].[add_Urbio_Objects_History] @table, @user_id, @Urbio_Id, @Analitics_Id, @comment, @operation_code;
