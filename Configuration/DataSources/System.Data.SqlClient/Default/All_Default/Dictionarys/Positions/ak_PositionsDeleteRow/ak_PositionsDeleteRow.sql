/*
delete 
	  from [CRM_1551_Analitics].[dbo].[Positions]
	  where Id=@Id
*/

update [dbo].[Positions] set [active] = 0 where Id=@Id
delete from [dbo].[OrganizationInResponsibilityRights] where [position_id] = @Id

/*НАЧАЛО - пересчитать права его помичникив*/
    DECLARE @helper_position_id INT
	DECLARE @CURSOR CURSOR
	SET @CURSOR  = CURSOR SCROLL
	FOR
	    SELECT [helper_position_id]
		FROM [CRM_1551_Analitics].[dbo].[PositionsHelpers]
		where [main_position_id] = @Id
	OPEN @CURSOR
	FETCH NEXT FROM @CURSOR INTO  @helper_position_id
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @helper_position_id, @user_id	
	FETCH NEXT FROM @CURSOR INTO @helper_position_id
	END
	CLOSE @CURSOR
/*КОНЕЦ - пересчитать права его помичникив*/



delete 
  from [dbo].[Workers]
  where [position_id]=@Id
