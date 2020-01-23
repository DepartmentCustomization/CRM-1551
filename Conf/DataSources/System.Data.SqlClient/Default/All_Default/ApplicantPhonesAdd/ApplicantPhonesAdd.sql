-- declare @Phone nvarchar(100) = N'(089)988-99-80'
-- declare @IsMain int = 0
-- declare @Applicant_id int = 1490249
-- declare @TypePhone int = 1

if len(isnull(rtrim(replace(replace(REPLACE(@Phone, N'(', ''), N')', N''), N'-', N'')),N'')) > 0 
begin
   
	if (
	    select count(1) from [dbo].[ApplicantPhones] where applicant_id = @Applicant_id 
	    and phone_number = isnull(rtrim(replace(replace(REPLACE(@Phone, N'(', ''), N')', N''), N'-', N'')),N'') 
	   ) = 0
	begin
	        if @IsMain = 1
            begin
               update [dbo].[ApplicantPhones] set IsMain = 0 where applicant_id = @Applicant_id
	          -- select N'Update isMain' as [Result]
            end


		insert into [dbo].[ApplicantPhones]  (applicant_id, phone_type_id, phone_number, IsMain, CreatedAt)
		values (@Applicant_id, isnull(@TypePhone,1), replace(replace(REPLACE(@Phone, N'(', ''), N')', N''), N'-', N''), @IsMain, getutcdate())
		
		select 'OK' as [Result]
    end
	else
	begin
		select 'ERROR' as [Result]
	end

end
else
begin
    select 'ERROR' as [Result]
end

