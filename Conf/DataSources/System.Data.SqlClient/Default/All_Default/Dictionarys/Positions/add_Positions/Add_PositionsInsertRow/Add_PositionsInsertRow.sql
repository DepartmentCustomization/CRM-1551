DECLARE @output TABLE (Id INT);
  DECLARE @position_new INT;

  INSERT INTO [dbo].[Positions]
  (
  [parent_id]
      ,[position_code]
      ,[position]
      ,[phone_number]
      ,[address]
      ,[name]
      ,[active]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
      ,[organizations_id]
      ,[role_id]
      ,[programuser_id]
      --,[is_main]
      ,[main_position_id]
  )

  OUTPUT [inserted].[Id] INTO @output (Id)


  SELECT [parent_id]
,[position_code]
,[position]
,[phone_number]
,[address]
,[name]
,'true'--[active] = 1
,@user_id [user_id] 
,GETUTCDATE() [edit_date]
,@user_id [user_edit_id]
,@organization_id
,[role_id] --(як і в головної)
,[programuser_id] --(як і в головної)
,@position_id main_position_id
  FROM [dbo].Positions
  WHERE Id=@position_id;

  SET @position_new = (SELECT TOP 1 Id FROM @output);

  INSERT INTO [dbo].[OrganizationInResponsibilityRights]
  (
  [position_id]
      ,[organization_id]
      ,[onform]
      ,[editable]
      ,[edit_date]
      ,[user_id]
  )

  SELECT @position_new
      ,@organization_id [organization_id]
      ,'false' [onform]
      ,'true' [editable]
      ,GETUTCDATE() [edit_date]
      ,@user_id [user_id]


	  INSERT INTO [dbo].[PersonExecutorChoose]
  ([name]
      ,[organization_id]
      ,[position_id]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date])

	SELECT [name]
	,[organizations_id]
	,Id
	,@user_id [user_id]
	,GETUTCDATE() [create_date]
	,@user_id [user_edit_id]
	,GETUTCDATE() [edit_date]
	FROM [dbo].[Positions]
	WHERE Id=@position_new

  SELECT @position_new AS Id;
  RETURN;