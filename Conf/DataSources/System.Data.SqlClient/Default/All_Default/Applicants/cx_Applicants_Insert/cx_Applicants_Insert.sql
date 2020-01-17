
declare @output table (Id int);
  DECLARE @interval float= 0.2;
  declare @valid_date_birth datetime;
  declare @birth_date2 datetime;
  --set  @valid_date_birth = IIF( @birth_date is not null, @birth_date + @interval, null )

set @birth_date2=(select 
  case 
  when @day_month is not null and @birth_year is not null and RIGHT(@day_month,2)*1<=12 and LEFT(@day_month,2)*1<=31 and substring(@day_month,3,1)=N'-'
  then convert(date,LTRIM(@birth_year)+N'-'+RIGHT(@day_month,2)+N'-'+LEFT(@day_month,2))
  else null end)

  set  @valid_date_birth = IIF( @birth_date2 is not null, @birth_date2 + @interval, null )

  insert into [dbo].[Applicants]
  (
  [registration_date]
      ,[full_name]
      ,[applicant_type_id]
      ,[category_type_id]
      ,[social_state_id]
      ,[mail]
      ,[sex]
      ,[birth_date]
      --,[age]
      ,[comment]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
      ,[applicant_privilage_id]
	  ,[birth_year]
  )

  output [inserted].[Id] into @output (Id)
  values
  (
       getutcdate()
      ,@full_name
      ,@applicant_type_id
      ,@category_type_id
      ,@social_state_id
      ,@mail
      ,@sex
      ,@valid_date_birth 
      --,@age
      ,@comment
      ,@user_id
      ,getutcdate()
      ,@user_id
      ,@applicant_privilage_id
	  ,@birth_year
  )
  
  declare @applicant_id int;
  set @applicant_id =(select top 1 id from @output)

  insert into [dbo].[ApplicantPhones]
  (
  [applicant_id]
      ,[phone_type_id]
      ,[phone_number]
	  ,[IsMain]
      ,[CreatedAt]
  )

  values
  (
  @applicant_id
      ,@phone_type_id
      ,replace(replace(REPLACE(@phone_number, N'(', ''), N')', N''), N'-', N'')
	  ,N'true'
	  ,getdate()
  )

  if @phone_type_id2 is not null or @phone_number2 is not null
  begin
  insert into [dbo].[ApplicantPhones]
  (
  [applicant_id]
      ,[phone_type_id]
      ,[phone_number]
	  ,[IsMain]
      ,[CreatedAt]
  )

  values
  (
  @applicant_id
      ,@phone_type_id2
      ,replace(replace(REPLACE(@phone_number2, N'(', ''), N')', N''), N'-', N'')
	  ,N'false'
	  ,getdate()
  )
  end



  insert into [dbo].[LiveAddress]
  (
       [applicant_id]
      ,[building_id]
      ,[house_block]
      ,[entrance]
      ,[flat]
      ,[main]
      ,[active]
  )
  values
  (
       @applicant_id
      ,@building_id
      ,@house_block
      ,@entrance
      ,@flat
      ,N'true'
      ,N'true'
  )
  
    update [CRM_1551_Analitics].[dbo].[Applicants]
  set [ApplicantAdress]=(select distinct
  isnull([Districts].name+N' р-н., ', N'')+
  isnull([StreetTypes].shortname+N' ',N'')+
  isnull([Streets].name+N' ',N'')+
  isnull([Buildings].name+N', ',N'')+
  isnull(N'п. '+ltrim([LiveAddress].[entrance])+N', ', N'')+
  isnull(N'кв. '+ltrim([LiveAddress].flat)+N', ', N'')+
  N'телефони: '+isnull(stuff((select N', '+lower(SUBSTRING([PhoneTypes].name, 1, 3))+N'.: '+[ApplicantPhones].phone_number
  from [CRM_1551_Analitics].[dbo].[ApplicantPhones]
  left join [CRM_1551_Analitics].[dbo].[PhoneTypes] on [ApplicantPhones].phone_type_id=[PhoneTypes].Id
  where [ApplicantPhones].applicant_id=[LiveAddress].applicant_id
  for xml path('')), 1, 2,N''), N'') phone
  from [CRM_1551_Analitics].[dbo].[LiveAddress] 
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [LiveAddress].building_id=[Buildings].Id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Districts] on [Buildings].district_id=[Districts].Id
  where applicant_id=@applicant_id)
  where Id=@applicant_id
  
  select @applicant_id	as [Id]
  return;

/*declare @output table (Id int)

INSERT INTO [dbo].[Applicants]
           (
		    [registration_date]
           ,[full_name]
           ,[applicant_type_id]
           ,[applicant_category_id]
           ,[social_state_id]
           ,[mail]
           ,[sex]
           ,[birth_date]
           ,[age]
           ,[comment]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id]
		   )
output [inserted].[Id] into @output (Id)
     VALUES
           (
		    GETUTCDATE()
           ,@full_name
           ,@types_id
           ,@category_id
           ,@states_id
           ,@mail
           ,@sex
           ,@birth_date
           ,isnull(@age, DATEDIFF(year,isnull(@birth_date, null),getutcdate()) )
           ,@comment
           ,@user_id
           ,GETUTCDATE()
           ,@user_edit_id
		   )
declare @app_id int;
set @app_id = (select top 1 Id from @output )

insert into [dbo].[ApplicantPhones]
			([applicant_id]
           ,[phone_type_id]
           ,[phone_number])
	output [inserted].[Id]
     VALUES
           (@app_id
           ,@phone_type_id
           ,@phone_number 
		   )

INSERT INTO [dbo].[LiveAddress]
           ([applicant_id]
           ,[building_id]
           ,[house_block]
           ,[entrance]
           ,[flat]
           ,[main]
           ,[active])
     VALUES
           (@app_id
           ,@building_id
           ,@house_block
           ,@entrance
           ,@flat
           ,@main
           ,@active
		   )

select @app_id	as [Id]
return;*/