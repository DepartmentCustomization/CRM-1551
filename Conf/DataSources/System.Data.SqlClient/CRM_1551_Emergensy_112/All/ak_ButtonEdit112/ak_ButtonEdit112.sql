


UPDATE [dbo].[Persons]
	   SET [last_name]=@applicant_last_name
      ,[first_name]=@applicant_first_name
      ,[middle_name]=@applicant_middle_name
      ,[person_phone]=@applicant_person_phone
      ,[sex]=@applicant_sex
      ,[birth_date]=@applicant_birth_date
      ,[building_id]=@applicant_building_id
      ,[entrance]=@applicant_entrance
      ,[entercode]=@applicant_entercode
      ,[storeysnumber]=@applicant_storeysnumber
      ,[floor]=@applicant_floor
      ,[flat]=@applicant_flat
      ,[exit]=@applicant_exit
      ,[moreinformation]=@applicant_moreinformation
      ,[longitude]=@applicant_longitude
      ,[latitude]=@applicant_latitude
      ,[user_id]=@applicant_user_id
      --,[create_date
      ,[user_edit_id]=@user_id
      ,[edit_date]=GETUTCDATE()
  WHERE id=@applicant_id;

  ---

  UPDATE [dbo].[Persons]
	   SET [last_name]=@pacient_last_name
      ,[first_name]=@pacient_first_name
      ,[middle_name]=@pacient_middle_name
      ,[person_phone]=@pacient_person_phone
      ,[sex]=@pacient_sex
      ,[birth_date]=@pacient_birth_date
      ,[building_id]=@pacient_building_id
      ,[entrance]=@pacient_entrance
      ,[entercode]=@pacient_entercode
      ,[storeysnumber]=@pacient_storeysnumber
      ,[floor]=@pacient_floor
      ,[flat]=@pacient_flat
      ,[exit]=@pacient_exit
      ,[moreinformation]=@pacient_moreinformation
      ,[longitude]=@pacient_longitude
      ,[latitude]=@pacient_latitude
      ,[user_id]=@pacient_user_id
      --,[create_date
      ,[user_edit_id]=@user_id
      ,[edit_date]=GETUTCDATE()
  WHERE id=@pacient_id;

  ----

  UPDATE [dbo].[Events]
  SET [receipt_date]=@event_receipt_date
      ,[work_line_id]=@event_work_line_id
      ,[work_line_value]=@event_work_line_value
      ,[category_id]=@event_category_id
      ,[event_date]=@event_event_date
      ,[applicant_id]=@applicant_id
      ,[patient_id]=@pacient_id
      ,[applicant_type_id]=@event_applicant_type_id
      ,[building_id]=@event_building_id
      ,[entrance]=@event_entrance
      ,[entercode]=@event_entercode
      ,[storeysnumber]=@event_storeysnumber
      ,[floor]=@event_floor
      ,[flat/office]=@event_flat_office
      ,[exit]=@event_exit
      ,[moreinformation]=@event_moreinformation
      ,[longitude]=@event_longitude
      ,[latitude]=@event_latitude
      ,[content]=@event_content
      ,[sipcallid]=@event_sipcallid
      ,[user_id]=@user_id
      ,[edit_date]= GETUTCDATE()
      ,[user_edit_id]=@user_id
  WHERE id=@event_id;

  ----
  DELETE [dbo].[EventExecutors]
  WHERE event_id=@event_id;


--   DECLARE @Services_EX NVARCHAR(MAX)=

--   N'SELECT '+LTRIM(@event_id)+N' event_id, 
--   s.id, N'''+@user_id+N''', GETUTCDATE() [edit_date]
--   FROM [dbo].[Services] s
--   WHERE s.id IN ('+ISNULL(@service_ids, N'0')+N')';

	  INSERT INTO [dbo].[EventExecutors]
  (
  [event_id]
  ,[service_id]
  ,[user_id]
  ,[create_date]
  )

  SELECT (SELECT TOP 1 LTRIM(id) FROM @output_event) event_id
  ,[service_id]
  ,@user_id [user_id]
  ,GETUTCDATE() [create_date]
  FROM
  (SELECT CASE WHEN @fire='true' THEN N'1' END service_id WHERE @fire='true' UNION
    SELECT CASE WHEN @police='true' THEN N'2' END service_id WHERE @police='true' UNION
    SELECT CASE WHEN @medical='true' THEN N'3' END service_id WHERE @medical='true' UNION
    SELECT CASE WHEN @gas='true' THEN N'4' END service_id WHERE @gas='true') t;

 -- EXEC(@Services_EX);
  ----

  DELETE [dbo].[PersonClasses]
  WHERE [person_id]=@applicant_id OR [person_id]=@pacient_id;

  DECLARE @PersonClasses_EX NVARCHAR(max)=
  N'
  SELECT 
	   'LTRIM(@applicant_id)+N' [person_id]
      ,id [class_id]
      ,N'''+@user_id+N''' [user_id]
      ,GETUTCDATE() [create_date]
      ,N'''+@user_id+N''' [user_edit_id]
      ,GETUTCDATE() [edit_date]
  FROM [dbo].[Classes]
  WHERE id IN ('+ISNULL(@applicant_classes_ids,N'0')+N')
  
  UNION 

  SELECT 
	   '+LTRIM(@pacient_id)+N' [person_id]
      ,id [class_id]
      ,N'''+@user_id+N''' [user_id]
      ,GETUTCDATE() [create_date]
      ,N'''+@user_id+N''' [user_edit_id]
      ,GETUTCDATE() [edit_date]
  FROM [dbo].[Classes]
  WHERE id IN ('+ISNULL(@pacient_classes_ids,N'0')+N')';

  INSERT INTO [dbo].[PersonClasses]
  (
  [person_id]
      ,[class_id]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date]
  )
  
  EXEC(@PersonClasses_EX);
  
