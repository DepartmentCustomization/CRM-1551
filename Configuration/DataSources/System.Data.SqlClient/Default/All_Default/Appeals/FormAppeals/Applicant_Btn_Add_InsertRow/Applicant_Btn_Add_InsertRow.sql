 declare @output table (Id int);
  declare @app_id int;
  DECLARE @interval float= 0.2;
    declare @valid_date_birth datetime;
    set  @valid_date_birth = IIF( @Application_BirthDate is not null, @Application_BirthDate + @interval, null )

  if len(isnull(rtrim(@Applicant_Id),N'')) > 0
  begin
		
	update [dbo].[Applicants]  set [full_name] = @Applicant_PIB
								  ,[applicant_privilage_id] = @Applicant_Privilege
								  ,[social_state_id] = @Applicant_SocialStates
								  ,[category_type_id] = @Applicant_CategoryType
								  ,[sex] = @Applicant_Sex
								  ,[birth_date] = @valid_date_birth
								  ,[birth_year] = YEAR(@Application_BirthDate) -- DATEDIFF(YEAR,@Application_BirthDate, getdate()) /*@Applicant_Age*/
								  ,[comment] = @Applicant_Comment
								  ,[mail] = @Applicant_Email
                                   ,[applicant_type_id] = @Applicant_Type
                                   ,[user_id] = @CreatedUser
                                   ,[edit_date] = getutcdate()
                                   ,[user_edit_id] = @CreatedUser
								  
		where Id = @Applicant_Id
		

		delete from [dbo].[LiveAddress] where applicant_id = @Applicant_Id
		insert into [dbo].[LiveAddress] (applicant_id, building_id, house_block, entrance, flat, main, active)
		values (@Applicant_Id, @Applicant_Building, @Applicant_HouseBlock, @Applicant_Entrance, @Applicant_Flat, 1, 1)

		 update [dbo].[Appeals] set [applicant_id] = @Applicant_Id
		 where [Id] = @AppealId

		/*
		if (select count(1) from [dbo].[ApplicantPhones] where applicant_id = @Applicant_Id and phone_number = @Applicant_Phone and IsMain = 1) = 0
		begin
			insert into [dbo].[ApplicantPhones]  (applicant_id, phone_type_id, phone_number, IsMain, CreatedAt)
			values (@Applicant_Id, isnull(@Applicant_TypePhone,1), replace(replace(REPLACE(@Applicant_Phone, N'(', ''), N')', N''), N'-', N''), 1, getutcdate())
		end
		else
		begin
		    update [dbo].[ApplicantPhones] set CreatedAt = getutcdate(), 
		                                        phone_number = replace(replace(REPLACE(@Applicant_Phone, N'(', ''), N')', N''), N'-', N''), 
		                                        phone_type_id = isnull(@Applicant_TypePhone,1)
		      where applicant_id = @Applicant_Id and IsMain = 1
		end
		*/





	    select @Applicant_Id as ApplicantId  
	end
	else 
	begin
	
			insert into [dbo].[Applicants] (    [category_type_id]
			                                    ,[full_name]
			                                    ,[registration_date]
												,[social_state_id]
												,[sex]
												,[birth_date]
												,[birth_year]
												,[comment]
												,[user_id]
												,[edit_date]
												,[user_edit_id]
												,[applicant_privilage_id]
												,[mail]
												,[applicant_type_id])
			output [inserted].[Id] into @output (Id)	
			values  (@Applicant_CategoryType
			        ,@Applicant_PIB
			        ,getutcdate()
				   ,@Applicant_SocialStates
				   ,@Applicant_Sex
				   ,@valid_date_birth
				   ,YEAR(@Application_BirthDate) /*@Applicant_Age -- DATEDIFF(YEAR,@Application_BirthDate, getdate()) @Applicant_Age*/
				   ,@Applicant_Comment
				   ,@CreatedUser
				   ,getutcdate()
				   ,@CreatedUser
				   ,@Applicant_Privilege
				   ,@Applicant_Email
				   ,@Applicant_Type
				   )
				   
			
			set @app_id = (select top 1 Id from @output)

			
			insert into [dbo].[ApplicantPhones]  (applicant_id, phone_type_id, phone_number, IsMain, CreatedAt)
			values (@app_id, isnull(@Applicant_TypePhone,1), replace(replace(REPLACE(@Applicant_Phone, N'(', ''), N')', N''), N'-', N''), 1, getutcdate())
			


			insert into [dbo].[LiveAddress] (applicant_id, building_id, house_block, entrance, flat, main, active)
			values (@app_id, @Applicant_Building, @Applicant_HouseBlock, @Applicant_Entrance, @Applicant_Flat, 1, 1)
			
			  update [dbo].[Appeals] 
			  set [applicant_id] = @app_id
			  ,[edit_date]=getutcdate()
			  where [Id] = @AppealId
			  
			select @app_id as ApplicantId  
	
  end
  
  --арт
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
  where applicant_id=@app_id)
  where Id=@app_id
  --арт
  