  /*
    declare @CreatedByUserId nvarchar(128)

    declare @Applicant_Id int
    declare @1551_ApplicantFromSite_PIB nvarchar(128)
    declare @ApplicantFromSite_Birthdate date
    declare @ApplicantFromSite_SocialState int
    declare @Applicant_Privilege int
    declare @ApplicantFromSite_Sex nvarchar(128)
    declare @ApplicantFromSite_Age int
    declare @AppealsFromSite_Id int
    declare @Question_ControlDate date
    declare @Question_Building int
    declare @Question_Organization int
    declare @Question_TypeId int
    declare @Question_Content nvarchar(128)
    declare @entrance nvarchar(128)
    declare @flat nvarchar(128)
  */



  ----------------------------
declare @output_Appeal table (Id int)
INSERT INTO [dbo].[Appeals]
           ([registration_date]
           --,[registration_number]
           ,[receipt_source_id]
           ,[phone_number]
           ,[receipt_date]
           ,[start_date]
           ,[user_id]
           ,[edit_date]
           ,[user_edit_id])
output [inserted].[Id] into @output_Appeal (Id)
     VALUES
           (getutcdate() --@registration_date
           --,@registration_number
           ,2 /*Сайт/моб. додаток*/
           ,NULL
           ,getutcdate() -- @receipt_date
           ,getutcdate() -- @start_date
           ,@CreatedByUserId
           ,getutcdate() -- @edit_date
           ,@CreatedByUserId
		   )

declare @AppealId int
set @AppealId = (select top 1 Id from @output_Appeal)
update [dbo].[Appeals] set registration_number =  concat( SUBSTRING ( rtrim(YEAR(getdate())),4,1),'-',(select count(Id) from Appeals where year(Appeals.registration_date) = year(getutcdate())) ) where Id =  @AppealId
 
update [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] set Appeal_Id = @AppealId, AppealFromSiteResultId = 3 /*Зареєстровано*/
where Id = @AppealsFromSite_Id


  declare @output_Applicant_Id table (Id int);
 if len(isnull(rtrim(@Applicant_Id),N'')) = 0
 begin
	insert into [dbo].[Applicants] ([registration_date]
      ,[full_name]
      ,[applicant_type_id]
      ,[category_type_id]
      ,[social_state_id]
      ,[mail]
      ,[sex]
      ,[birth_date]
      ,[comment]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
      ,[applicant_privilage_id]
      ,[birth_year]
      ,[ApplicantAdress]
      ,[ApplicantFromSiteId])
    output [inserted].[Id] into @output_Applicant_Id (Id)	
	select getutcdate() as [registration_date],
			@1551_ApplicantFromSite_PIB as [full_name],
			1 as [applicant_type_id],
			NULL as [category_type_id],
			@ApplicantFromSite_SocialState as [social_state_id],
			(select top 1 Mail from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] where ApplicantFromSiteId = (select top 1 ApplicantFromSiteId from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] where Id = @AppealsFromSite_Id) and Mail is not null) as [mail],
			case when @ApplicantFromSite_Sex = N'ч' then 1
				 when @ApplicantFromSite_Sex = N'ч' then 2
				 else NULL end as [sex],
			@ApplicantFromSite_Birthdate as [birth_date],
			NULL as [comment],
			@CreatedByUserId as [user_id],
			getutcdate() as [edit_date],
			@CreatedByUserId as [user_edit_id],
			@Applicant_Privilege as [applicant_privilage_id],
			@ApplicantFromSite_Age as [birth_year],
			NULL as [ApplicantAdress],
			NULL as [ApplicantFromSiteId]
	 set @Applicant_Id = (select top 1 Id from @output_Applicant_Id)
	 
	   if len(isnull(rtrim(@1551_ApplicantFromSite_Address_Building),N'')) > 0
	   begin
	        insert into [dbo].[LiveAddress] ([applicant_id]
                                                                ,[building_id]
                                                                ,[house_block]
                                                                ,[entrance]
                                                                ,[flat]
                                                                ,[main]
                                                                ,[active])
            values (@Applicant_Id,
	            @1551_ApplicantFromSite_Address_Building,
	        	NULL,
	        	@1551_ApplicantFromSite_Address_Entrance,
	        	@1551_ApplicantFromSite_Address_Flat,
	        	1,
	    	    1)
	    end	
	    	
	   
            if object_id('tempdb..#temp_OUT') is not null drop table #temp_OUT
            create table #temp_OUT(
            [ApplicantFromSiteId] int,
            [MoreContactTypeId] int,
            [PhoneNumber] nvarchar(10)
            )
            insert into #temp_OUT ([ApplicantFromSiteId], [MoreContactTypeId], [PhoneNumber])
            select distinct ApplicantFromSiteId, MoreContactTypeId, right(PhoneNumber,10) 
            from [CRM_1551_Site_Integration].[dbo].[ApplicantFromSiteMoreContacts] 
            where ApplicantFromSiteId = (select top 1 ApplicantFromSiteId from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] where Id = @AppealsFromSite_Id)
            and PhoneNumber is not null
            
            if (select count(1) from #temp_OUT) > 0
            begin
            	if (select count(1) from #temp_OUT where MoreContactTypeId = 1) > 0
            	begin
            			insert into [dbo].[ApplicantPhones] ([applicant_id]
            												 ,[phone_type_id]
            												 ,[phone_number]
            												 ,[IsMain]
            												 ,[CreatedAt])
            			select @Applicant_Id as [applicant_id]
            				   ,1 as [phone_type_id]
            				   ,PhoneNumber as [phone_number]
            				   ,1 as [IsMain]
            				   ,getutcdate() as [CreatedAt]
            			from #temp_OUT 
            			where MoreContactTypeId = 1
            	end
            	else
            	begin
            			insert into [dbo].[ApplicantPhones] ([applicant_id]
            												 ,[phone_type_id]
            												 ,[phone_number]
            												 ,[IsMain]
            												 ,[CreatedAt])
            			select @Applicant_Id as [applicant_id]
            				   ,1 as [phone_type_id]
            				   ,PhoneNumber as [phone_number]
            				   ,1 as [IsMain]
            				   ,getutcdate() as [CreatedAt]
            			from #temp_OUT 
            			where MoreContactTypeId != 1
            	end
            
            	insert into [dbo].[ApplicantPhones] ([applicant_id]
            										 ,[phone_type_id]
            										 ,[phone_number]
            										 ,[IsMain]
            										 ,[CreatedAt])
            	select @Applicant_Id as [applicant_id]
            		   ,1 as [phone_type_id]
            		   ,PhoneNumber as [phone_number]
            		   ,0 as [IsMain]
            		   ,getutcdate() as [CreatedAt]
            	from #temp_OUT where PhoneNumber not in (select [phone_number] from [dbo].[ApplicantPhones] where [applicant_id] = @Applicant_Id)
            end
 	
	 
 end 

 
 update  [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite] set ApplicantId = @Applicant_Id
 where Id = (select top 1 ApplicantFromSiteId from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] where Id = @AppealsFromSite_Id) 



declare @output table (Id int);
declare @output2 table (Id int);
declare @app_id int;
declare @assign int;
declare @getdate datetime = getutcdate();
 
 
 insert into [dbo].[Questions] ([appeal_id]
      ,[registration_number]
      ,[registration_date]
      ,[receipt_date]
      ,[question_state_id]
      ,[control_date]
      ,[object_id]
      ,[object_comment]
      ,[organization_id]
      ,[application_town_id]
      ,[event_id]
      ,[question_type_id]
      ,[question_content]
      ,[answer_form_id]
      ,[answer_phone]
      ,[answer_post]
      ,[answer_mail]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
      ,[last_assignment_for_execution_id]
	  ,[entrance] -- art
	  ,[flat]) -- art
output [inserted].[Id] into @output (Id)	
select @AppealId
      ,(concat( SUBSTRING ( rtrim(YEAR(getdate())),4,1),'-',(select count(Id) from Appeals where year(Appeals.registration_date) = year(getutcdate())) ))+N'/'+rtrim((select count(1) from [dbo].[Questions] where appeal_id = @AppealId)+1) /*[registration_number]*/
      ,getutcdate() /*[registration_date]*/
      ,getutcdate() /*[receipt_date]*/
      ,1 /*[question_state_id]*/
	  ,@Question_ControlDate				   
      ,@Question_Building /*[object_id]*/
      ,NULL /*[object_comment]*/
      ,@Question_Organization /*[organization_id]*/
      ,NULL /*[application_town_id]*/
      ,NULL /*[event_id]*/
      ,@Question_TypeId /*[question_type_id]*/
      ,@Question_Content /*[question_content]*/
      ,1 /*[answer_form_id]*/
      ,NULL /*[answer_phone]*/
      ,NULL /*[answer_post]*/
      ,NULL  /*[answer_mail]*/
      ,@CreatedByUserId /*[user_id]*/
      ,getutcdate() /*edit_date*/
      ,@CreatedByUserId /*[user_edit_id]*/
      ,NULL /*last_assignment_for_execution_id*/
	  ,@entrance -- art
	  ,@flat -- art
	set @app_id = (select top 1 Id from @output)
	
	
	
	
  update [dbo].[Appeals] set [applicant_id] = @applicant_id
			  where [Id] = @AppealId	
			  
	exec [dbo].[sp_CreateAssignment] @app_id, @Question_TypeId, @Question_Building, @Question_Organization, @CreatedByUserId, @Question_ControlDate


select 3 as AppealFromSiteResultId, 
       N'Зареєстровано' as AppealFromSiteResultName,
       @Applicant_Id as Applicant_Id,
       @AppealId as AppealId

