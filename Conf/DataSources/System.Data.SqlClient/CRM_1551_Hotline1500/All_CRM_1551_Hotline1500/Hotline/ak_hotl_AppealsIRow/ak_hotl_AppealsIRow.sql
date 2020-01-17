  declare @output table (Id int);

  insert into [Appeals]
  ([registration_date]
      ,[phone_number]
      ,[applicant_name]
      ,[applicant_address]
      ,[marital_status_id]
      ,[sex]
      ,[age]
      ,[education_id]
      ,[applicant_privilage_id]
      ,[guidance_kind_id]
      ,[applicant_needs]
      ,[offender_name]
      ,[service_content]
      ,[comment]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id])

	  output [inserted].[Id] into @output (Id)

	  select getutcdate()--[registration_date]
      ,@phone_number--[phone_number]
      ,@applicant_name--[applicant_name]
      ,@applicant_address--[applicant_address]
      ,@marital_status_id--[marital_status_id]
      ,@sex_id--[sex]
      ,@age --[age]
      ,@education_id --[education_id]
      ,@applicant_privilage_id--[applicant_privilage_id]
      ,@guidance_kind_id--[guidance_kind_id]
      ,@applicant_needs--[applicant_needs]
      ,@offender_name--[offender_name]
      ,@service_content --[service_content]
      ,@comment --[comment]
      ,@user_id--[user_id]
      ,getutcdate()--[edit_date]
      ,@user_id--[user_edit_id]

	  declare @Appeals_Id int;
SET @Appeals_Id = (select top 1 Id from @output)

select @Appeals_Id as [Id]
return;