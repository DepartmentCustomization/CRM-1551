declare @values_id int
declare @delete_id int

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
		update [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_old]
		set  [name] =  (select [name] from [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_new] where id = @values_id ) 
		where id = @values_id
	end

	if @values_id is not null and @delete_id is null
	begin
		SET IDENTITY_INSERT [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_old] ON;

		insert into [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_old] (Id, [name])
		select id, [name] from [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_new] where id = @values_id

		SET IDENTITY_INSERT [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_old] OFF;

	 end
	if @values_id is null and @delete_id is not null
	begin
		delete from [CRM_1551_GORODOK_Integrartion].[dbo].[Global_claims_types_old] where id = @delete_id
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