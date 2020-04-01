
 --declare @Urbio_Id nvarchar(300)=N'53F7BCE4-371B-11E7-8000-000C29FF5864';
 --  declare @Analitics_Id int=1;
 --  declare @Operation nvarchar(200)=N'Видалення';
 --  declare @comment nvarchar(100)=N'коммент';
 --  declare @user_id nvarchar(128)=N'Вася';

  --удаление
  IF @Operation=N'Видалення'
  BEGIN
		update [CRM_1551_Analitics].[dbo].[Buildings]
	  set is_active='false'
	  where Id=@Analitics_Id--[urbio_id] in (select [value] from #Ids)

	  update [CRM_1551_URBIO_Integrartion].[dbo].[addressObject]
	  SET is_done='true'
	  , done_date=getutcdate()
	  , [comment]=@comment
	  , [user_id]=@user_id
	  where convert(nvarchar(128),Id)=@Urbio_Id --in (SELECT value FROM #Ids)

	  update [CRM_1551_Analitics].[dbo].[Objects]
	  set is_active='false'
	  where builbing_id=@Analitics_Id--[urbio_id] in (select [value] from #Ids)

  END

  --добавление
  IF @Operation=N'Додавання'
  BEGIN
	declare @output table (builbing_id int, [urdio_id] nvarchar(128))

   
  INSERT INTO [CRM_1551_Analitics].[dbo].[Buildings]
  (
  [district_id]
      ,[street_id]
      ,[number]
      ,[letter]
      ,[bsecondname]
      ,[name]
      ,[index]
      ,[urbio_id]
      ,[is_active]
      ,[is_urbio_new]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
  )

  output inserted.Id, inserted.[urbio_id] into @output

  select  d.Id [district_id]
      ,s.Id [street_id]
      ,case when patindex('%[^0-9]%', [name_ofFirstLevel_fullName])>0
	  then substring([name_ofFirstLevel_fullName],0,patindex('%[^0-9]%', [name_ofFirstLevel_fullName])) 
	  else [name_ofFirstLevel_fullName] end [number]

      ,
	  case when patindex('%[^0-9]%', [name_ofFirstLevel_fullName])>0
	  then replace(substring([name_ofFirstLevel_fullName], patindex('%[^0-9]%', [name_ofFirstLevel_fullName]), len([name_ofFirstLevel_fullName])-patindex('%[^0-9]%', [name_ofFirstLevel_fullName])+1),'-',N'') 
	  end [letter]
	  ,[name_ofSecondLevel_fullToponym]+ISNULL(N' '+[name_ofSecondLevel_fullName],N'') [bsecondname]
      ,[name_ofFirstLevel_fullName] [name]
      ,[zip] [index]
      ,convert(nvarchar(128),ao.[Id]) [urbio_id]
      ,'true' [is_active]
      ,'true' [is_urbio_new]
      ,@user_id [user_id]
      ,getutcdate() [edit_date]
      ,@user_id [user_edit_id]
  from [CRM_1551_URBIO_Integrartion].[dbo].[addressObject] ao
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Districts] d ON convert(nvarchar(128),ao.ofDistrict_id)=d.urbio_id 
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Streets] s ON convert(nvarchar(128),ao.ofStreet_id)=s.urbio_id
  where convert(nvarchar(128),ao.Id)=@Urbio_Id--INNER JOIN #Ids i ON [addressObject].id=i.[value]

  INSERT INTO [CRM_1551_Analitics].[dbo].[Objects]
  (
  [object_type_id]
      ,[name]
      ,[builbing_id]
      ,[district_id]
      ,[urbio_id]
      ,[is_active]
      ,[is_urbio_new]
      ,[geolocation_lat]
      ,[geolocation_lon]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
  )
  
  select
  aot.Id [object_type_id]
      --,ao.[name_ofFirstLevel_fullName] [name] -- хз, по ходу
      ,ISNULL(ao.[ofStreet_name_shortToponym]+N' ', N'')+ISNULL(ao.[ofStreet_name_shortName]+N', ',N'')+ISNULL(ao.[name_ofFirstLevel_fullName],N'') [name]
      ,o.[builbing_id]
      ,d.Id [district_id]
      ,convert(nvarchar(128),ao.Id) [urbio_id]
      ,'true' [is_active]
      ,'true' [is_urbio_new]
      ,ao.[geolocation_lat]
      ,ao.[geolocation_lon]
      ,@user_id [user_id]
      ,getutcdate() [edit_date]
      ,@user_id [user_edit_id]
  FROM [CRM_1551_URBIO_Integrartion].[dbo].[addressObject] ao
  --INNER JOIN #Ids i ON ao.id=i.[value]
  INNER JOIN @output o ON convert(nvarchar(128),ao.id)=o.[urdio_id]
  -- LEFT JOIN [CRM_1551_Analitics].[dbo].[EventTypes_UrbioTypes] ut on ao.TypeId_1551=ut.urbio_type_id
   LEFT JOIN [CRM_1551_Analitics].[dbo].[Districts] d ON convert(nvarchar(128),ao.ofDistrict_id)=d.urbio_id
  -- LEFT JOIN [CRM_1551_Analitics].[dbo].[ObjectTypes] aot ON ao.[name_ofFirstLevel_fullToponym]=aot.[name]
  LEFT JOIN (select uaot.name, aot.Id
  from [CRM_1551_Analitics].[dbo].[EventTypes_UrbioTypes] aetut
  inner join [CRM_1551_Analitics].[dbo].[ObjectTypes] aot on aetut.object_type_id=aot.id
  inner join[CRM_1551_Analitics].[dbo].[ObjectTypes] uaot on aetut.urbio_type_id=uaot.id) aot on ao.[name_ofFirstLevel_fullToponym]=aot.[name]
  END


  update [CRM_1551_URBIO_Integrartion].[dbo].[addressObject]
	  SET is_done='true'
	  , done_date=getutcdate()
	  , [comment]=@comment
	  , [user_id]=@user_id
  where convert(nvarchar(128),Id)=@Urbio_Id --in (SELECT value FROM #Ids)

  -- обновление
  IF @Operation=N'Редагування'

  BEGIN

	  update [CRM_1551_Analitics].[dbo].[Buildings]
	  set [district_id]= d.Id
		  ,[street_id]= s.Id
		  ,[number]= case when patindex('%[^0-9]%', ao.[name_ofFirstLevel_fullName])>0
		  then substring(ao.[name_ofFirstLevel_fullName],0,patindex('%[^0-9]%', ao.[name_ofFirstLevel_fullName])) 
		  else ao.[name_ofFirstLevel_fullName] end 
		  ,[letter]= case when patindex('%[^0-9]%', ao.[name_ofFirstLevel_fullName])>0
		  then replace(substring(ao.[name_ofFirstLevel_fullName], patindex('%[^0-9]%', ao.[name_ofFirstLevel_fullName]), len(ao.[name_ofFirstLevel_fullName])-patindex('%[^0-9]%', ao.[name_ofFirstLevel_fullName])+1),'-',N'') 
		  end 
		  ,[bsecondname]= ao.[name_ofSecondLevel_fullToponym]+ISNULL(N' '+ao.[name_ofSecondLevel_fullName],N'') 
		  ,[name]=ao.[name_ofFirstLevel_fullName] 
		  ,[index]=ao.[zip] 
		  ,[urbio_id]=convert(nvarchar(128),ao.[Id]) 
		  ,[is_active]='true'
		  ,[is_urbio_new]='true'
		  ,[user_id]= @user_id --[user_id]
		  ,[edit_date]=getutcdate()
		  ,[user_edit_id]=@user_id 
	  from [CRM_1551_Analitics].[dbo].[Buildings] b
	  inner join [CRM_1551_URBIO_Integrartion].[dbo].[addressObject] ao on b.urbio_id=convert(nvarchar(128),ao.id)
	  LEFT JOIN [CRM_1551_Analitics].[dbo].[Districts] d ON convert(nvarchar(128),ao.ofDistrict_id)=d.urbio_id 
	  LEFT JOIN [CRM_1551_Analitics].[dbo].[Streets] s ON convert(nvarchar(128),ao.ofStreet_id)=s.urbio_id
	  WHERE b.Id=@Analitics_Id--urbio_id IN (select value from #Ids)


	  UPDATE [CRM_1551_Analitics].[dbo].[Objects]
	  set [object_type_id]=aot.Id
		  --,[name]=ao.[name_ofFirstLevel_fullName]
      ,[name]=ISNULL(ao.[ofStreet_name_shortToponym]+N' ', N'')+ISNULL(ao.[ofStreet_name_shortName]+N', ',N'')+ISNULL(ao.[name_ofFirstLevel_fullName],N'')
		  ,[builbing_id]=o.[builbing_id]
		  ,[district_id]=d.Id--ao.ofDistrict_id
		  ,[urbio_id]=convert(nvarchar(128),ao.Id)
		  ,[is_active]='true'
		  ,[is_urbio_new]='true'
		  ,[geolocation_lat]=ao.[geolocation_lat]
		  ,[geolocation_lon]=ao.[geolocation_lon]
		  ,[user_id]=@user_id
		  ,[edit_date]=getutcdate()
		  ,[user_edit_id]=@user_id

	  FROM [CRM_1551_Analitics].[dbo].[Objects] o
	  INNER JOIN [CRM_1551_Analitics].[dbo].[Buildings] b ON b.Id=o.builbing_id
	  INNER JOIN [CRM_1551_URBIO_Integrartion].[dbo].[addressObject] ao ON b.urbio_id=convert(nvarchar(128),ao.id)
	  --LEFT JOIN [CRM_1551_Analitics].[dbo].[EventTypes_UrbioTypes] ut on ao.TypeId_1551=ut.urbio_type_id
	  LEFT JOIN [CRM_1551_Analitics].[dbo].[Districts] d ON convert(nvarchar(128),ao.ofDistrict_id)=d.urbio_id
    --LEFT JOIN [CRM_1551_Analitics].[dbo].[ObjectTypes] aot ON ao.[name_ofFirstLevel_fullToponym]=aot.[name]
    LEFT JOIN (select uaot.name, aot.Id
    from [CRM_1551_Analitics].[dbo].[EventTypes_UrbioTypes] aetut
    inner join [CRM_1551_Analitics].[dbo].[ObjectTypes] aot on aetut.object_type_id=aot.id
    inner join[CRM_1551_Analitics].[dbo].[ObjectTypes] uaot on aetut.urbio_type_id=uaot.id) aot on ao.[name_ofFirstLevel_fullToponym]=aot.[name]
    WHERE b.Id=@Analitics_Id

    update [CRM_1551_URBIO_Integrartion].[dbo].[addressObject]
	  SET is_done='true'
	  , done_date=getutcdate()
	  , [comment]=@comment
	  , [user_id]=@user_id
    where convert(nvarchar(128),Id)=@Urbio_Id

  END

  DECLARE @table NVARCHAR(200)= N'addressObject'; 

  DECLARE @operation_code NVARCHAR(50)=CASE 
      WHEN @Operation=N'Додавання' THEN N'add'
      WHEN @Operation=N'Редагування' THEN N'change'
      WHEN @Operation=N'Видалення' THEN N'del'
      END;

  --declare @user_id nvarchar(123)=N'Вася';
  --DECLARE @urbio_id NVARCHAR(128)=@Urbio_Id;
  --declare @id_1551 int=13;
  --declare @comment nvarchar(123)=N'sdgss';
  --declare @operation_code nvarchar(23)=N'add'

USE [CRM_1551_URBIO_Integrartion]

EXEC [dbo].[add_Urbio_Objects_History] @table, @user_id, @Urbio_Id, @Analitics_Id, @comment, @operation_code

