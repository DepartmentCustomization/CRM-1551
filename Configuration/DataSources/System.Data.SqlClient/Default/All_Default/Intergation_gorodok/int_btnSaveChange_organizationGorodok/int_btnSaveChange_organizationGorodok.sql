declare @values_id int
declare @delete_id int
-- declare @cat_id int --= 1025
-- declare @key int = 26
-- declare @id_1551 int --= 1346
-- declare @is_done bit = 0
-- declare @comment nvarchar(250) = N'test test test'
select @values_id = values_id, @delete_id = delete_id 
from [CRM_1551_GORODOK_Integrartion].[dbo].[Done_values_in_directories] where Id = @key

IF @is_done = 'true'
BEGIN
	update [CRM_1551_GORODOK_Integrartion].[dbo].[Done_values_in_directories]
		set [is_done] = 1
			,done_date = getutcdate()
			,user_id = @user_id
			,comment = @comment
		where Id = @key

	if @values_id is not null and @delete_id is not null
	begin
		update [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_organization_executors_old]
		set  [name] =  (select [name] from [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_organization_executors_new] where id = @values_id ) 
		where id = @values_id

		update [CRM_1551_GORODOK_Integrartion].[dbo].[Programs_1551_catalog] 
		set [1551_id] = @id_1551
		where id = @cat_id
	end

	if @values_id is not null and @delete_id is null
	begin
		SET IDENTITY_INSERT [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_organization_executors_old] ON;

		insert into [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_organization_executors_old] (Id, [name])
		select id, [name] from [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_organization_executors_new] where id = @values_id

		SET IDENTITY_INSERT [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_organization_executors_old] OFF;

		if not exists (select * from [CRM_1551_GORODOK_Integrartion].[dbo].[Programs_1551_catalog] where code = 'organizations' and integration_tables_id = @values_id and [1551_id] = @id_1551_new)
		begin
			insert into [CRM_1551_GORODOK_Integrartion].[dbo].[Programs_1551_catalog] (program, code, integration_tables_id, [1551_id])
			values ('gorodok', 'organizations', @values_id, @id_1551_new)
		end

	 end
	if @values_id is null and @delete_id is not null
	begin
		delete from [CRM_1551_GORODOK_Integrartion].[dbo].[Programs_1551_catalog] where id = @cat_id

		delete from [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_organization_executors_old] where id = @delete_id
	end
END
	else
BEGIN
	update [CRM_1551_GORODOK_Integrartion].[dbo].[Done_values_in_directories]
		set done_date = getutcdate()
			,user_id = @user_id
			,comment = @comment
		where Id = @key
END