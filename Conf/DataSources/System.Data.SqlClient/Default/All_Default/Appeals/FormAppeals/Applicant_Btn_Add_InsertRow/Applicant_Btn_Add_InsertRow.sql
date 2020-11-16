 DECLARE @output TABLE (Id INT);
 DECLARE @app_id INT;
 DECLARE @interval NUMERIC(8,2)= 0.2;
 DECLARE @valid_date_birth DATETIME;
    SET  @valid_date_birth = IIF( @Application_BirthDate IS NOT NULL, @Application_BirthDate + @interval, NULL );

  IF len(isnull(rtrim(@Applicant_Id),N'')) > 0
  BEGIN
		
	UPDATE [dbo].[Applicants]  SET  [full_name] = @Applicant_PIB
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
								  
		WHERE Id = @Applicant_Id;
		

		DELETE FROM [dbo].[LiveAddress] WHERE applicant_id = @Applicant_Id;
		INSERT INTO [dbo].[LiveAddress] ([applicant_id], 
										 [building_id], 
										 [house_block], 
										 [entrance], 
										 [flat], 
										 [main], 
										 [active],
										 [create_date],
										 [user_id],
										 [edit_date],
										 [user_edit_id])
		VALUES (@Applicant_Id, 
				@Applicant_Building, 
				@Applicant_HouseBlock, 
				@Applicant_Entrance, 
				@Applicant_Flat, 
				1, 
				1,
				GETUTCDATE(),
				@CreatedUser,
				GETUTCDATE(),
				@CreatedUser);

		 UPDATE [dbo].[Appeals] SET  [applicant_id] = @Applicant_Id
		 WHERE [Id] = @AppealId;

	    SELECT @Applicant_Id ApplicantId;  
	END
	ELSE 
	BEGIN
	
			INSERT INTO [dbo].[Applicants] (    [category_type_id]
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
			OUTPUT [inserted].[Id] INTO @output (Id)	
			VALUES  (@Applicant_CategoryType
			        ,@Applicant_PIB
			        ,getutcdate()
				   ,@Applicant_SocialStates
				   ,@Applicant_Sex
				   ,@valid_date_birth
				   ,YEAR(@Application_BirthDate)
				   ,@Applicant_Comment
				   ,@CreatedUser
				   ,getutcdate()
				   ,@CreatedUser
				   ,@Applicant_Privilege
				   ,@Applicant_Email
				   ,@Applicant_Type
				   );
				   
			
			SET @app_id = (SELECT TOP 1 Id FROM @output);

			
			INSERT INTO [dbo].[ApplicantPhones]  ([applicant_id], 
												  [phone_type_id], 
												  [phone_number], 
												  [IsMain], 
												  [CreatedAt],
												  [user_id],
												  [edit_date],
												  [user_edit_id])
			VALUES (@app_id, 
					isnull(@Applicant_TypePhone,1), 
					replace(replace(REPLACE(@Applicant_Phone, N'(', ''), N')', N''), N'-', N''), 
					1, 
					getutcdate(),
					@CreatedUser,
					getutcdate(),
					@CreatedUser);


			INSERT INTO [dbo].[LiveAddress] 
										([applicant_id], 
										 [building_id], 
										 [house_block], 
										 [entrance], 
										 [flat], 
										 [main], 
										 [active],
										 [create_date],
										 [user_id],
										 [edit_date],
										 [user_edit_id])
			VALUES (@app_id, 
					@Applicant_Building, 
					@Applicant_HouseBlock, 
					@Applicant_Entrance, 
					@Applicant_Flat, 
					1, 
					1,
					GETUTCDATE(),
					@CreatedUser,
					GETUTCDATE(),
					@CreatedUser);
			
			  UPDATE [dbo].[Appeals] 
			  SET  [applicant_id] = @app_id
			  ,[edit_date]=getutcdate()
			  WHERE [Id] = @AppealId;
			  
			SELECT @app_id ApplicantId;  
	
  END;
  
  --арт
  UPDATE   [dbo].[Applicants]
  SET  [ApplicantAdress]=(SELECT DISTINCT
  isnull([Districts].[name]+N' р-н., ', N'')+
  isnull([StreetTypes].shortname+N' ',N'')+
  isnull([Streets].name+N' ',N'')+
  isnull([Buildings].name+N', ',N'')+
  isnull(N'п. '+ltrim([LiveAddress].[entrance])+N', ', N'')+
  isnull(N'кв. '+ltrim([LiveAddress].flat)+N', ', N'')+
  N'телефони: '+isnull(stuff((SELECT N', '+lower(SUBSTRING([PhoneTypes].name, 1, 3))+N'.: '+[ApplicantPhones].phone_number
  FROM   [dbo].[ApplicantPhones]
  LEFT JOIN   [dbo].[PhoneTypes] ON [ApplicantPhones].phone_type_id=[PhoneTypes].Id
  WHERE [ApplicantPhones].applicant_id=[LiveAddress].applicant_id
  FOR XML path('')), 1, 2,N''), N'') phone
  FROM   [dbo].[LiveAddress] LiveAddress
  LEFT JOIN   [dbo].[Buildings] Buildings 
  ON [LiveAddress].building_id=[Buildings].Id
  LEFT JOIN   [dbo].[Streets] Streets
  ON [Buildings].street_id=[Streets].Id
  LEFT JOIN   [dbo].[StreetTypes] StreetTypes
  ON [Streets].street_type_id=[StreetTypes].Id
  LEFT JOIN   [dbo].[Districts] Districts 
  ON [Buildings].district_id=[Districts].Id
  WHERE applicant_id=@app_id)
  WHERE Id=@app_id;
  --арт
  