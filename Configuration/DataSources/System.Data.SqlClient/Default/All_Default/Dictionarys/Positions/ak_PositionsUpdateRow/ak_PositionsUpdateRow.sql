update [CRM_1551_Analitics].[dbo].[Positions]
	  set [parent_id]=@parent_id
      ,[position_code]=@position_code
      ,[position]=@position
      ,[phone_number]=@phone_number
      ,[address]=@address
      ,[name]=@name
      ,[active]=@active
      ,[user_id]=@user_id
      ,[edit_date]=GETUTCDATE()
      ,[user_edit_id]=@user_id
	  ,[organizations_id]=@organization_id
      ,[role_id]=@role_id
      ,[programuser_id]=@programuser_id
      ,[is_main] = @is_main
      
	  where Id=@Id

exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @Id, @user_id

if  @active = 0
begin
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
end



update [CRM_1551_Analitics].[dbo].[Workers]
set [organization_id]=@organization_id
      ,[roles_id]=@role_id
      ,[name]=@name
      ,[phone_number]=@phone_number
      ,[position]=@position
      ,[active]=@active
      ,[worker_user_id]=@programuser_id
      ,[edit_date]=GETUTCDATE()
      ,[user_edit_id]=@user_id
where [position_id]=@Id


-- логика для сотрудников связанных с КБУ, если чел из КБУ то просто добавляем его в таблицу OrganizationInResponsibilityRights
-- без пересчета прав другим пользователям
-- удаление данного чел происходит в процедуре Calc_OrganizationInResponsibilityRights_byPosition
 declare  @Org_id_URL table (Id int) 
 insert into  @Org_id_URL  
 SELECT Id  FROM [dbo].Organizations  where parent_organization_id = 1761 or id = 1761

if  exists ( select Id from @Org_id_URL where Id in (@organization_id) )
begin
	insert into OrganizationInResponsibilityRights 
	(
       [position_id]
      ,[organization_id]
      ,[onform]
      ,[editable]
      ,[edit_date]
      ,[user_id])
  values 
  (@Id, @organization_id, 0 ,1, GETUTCDATE(), @user_id)
end
