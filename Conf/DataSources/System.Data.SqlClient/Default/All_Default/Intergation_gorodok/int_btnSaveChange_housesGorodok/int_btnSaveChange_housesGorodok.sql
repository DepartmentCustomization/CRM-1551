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
		update [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_houses_old]
		set  district_id = new.district_id
			,street_id = new.street_id
			,number = new.number
			,letter = new.letter
			,[name] =  new.[name] 
			from [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_houses_new] as new 
			--where new.id = @values_id 
		--where [Gorodok_houses_old].id = @values_id and new.id = @values_id
		where [Gorodok_houses_old].id = new.id and [Gorodok_houses_old].id = @values_id

		update [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses]
		set [1551_houses_id] = @id_1551
		where id = @cat_id
	end

	if @values_id is not null and @delete_id is null
	begin
	--	SET IDENTITY_INSERT [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_houses_old] ON;

		insert into [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_houses_old] 
		select * from [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_houses_new] where id = @values_id

	--	SET IDENTITY_INSERT [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_houses_old] OFF;

		if not exists (select * from [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] where [gorodok_houses_id] = @values_id and [1551_houses_id] = @id_1551_new)
		begin
			insert into [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] ([gorodok_houses_id], [1551_houses_id])
			values (@values_id, @id_1551_new)
		end

	 end
	if @values_id is null and @delete_id is not null
	begin
		delete from [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] where id = @cat_id

		delete from [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_houses_old] where id = @delete_id
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