-- declare @Phone nvarchar(100) = N'(089)988-99-80'
-- declare @IsMain int = 0
-- declare @Applicant_id int = 1490249
-- declare @IdPhone int = 123
-- declare @TypePhone int = 1


if len(isnull(rtrim(replace(replace(REPLACE(@Phone, N'(', ''), N')', N''), N'-', N'')),N'')) > 0 
begin
    if @IsMain = 1
    begin
      update [dbo].[ApplicantPhones] set IsMain = 0 where applicant_id = @Applicant_id
	   select N'Update isMain' as [Result]
    end

	update [dbo].[ApplicantPhones] set IsMain = @IsMain, 
	                                   phone_number = isnull(rtrim(replace(replace(REPLACE(@Phone, N'(', ''), N')', N''), N'-', N'')),N''), 
	                                   phone_type_id = @TypePhone
	where Id = @IdPhone

	select N'OK' as [Result]

end
else
begin
    select 'ERROR' as [Result]
end




