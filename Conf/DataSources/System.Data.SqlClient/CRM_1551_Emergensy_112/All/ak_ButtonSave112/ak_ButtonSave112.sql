
DECLARE @output_pacient TABLE (Id INT);
DECLARE @output_applicant TABLE (Id INT);
DECLARE @output_event TABLE (Id INT);

IF @for_yourself103='false' OR @for_yourself103 IS NULL
BEGIN

INSERT INTO [dbo].[Persons]
  (
  [last_name]
      ,[first_name]
      ,[middle_name]
      ,[person_phone]
      ,[sex]
      ,[birth_date]
      ,[building_id]
      ,[entrance]
      ,[entercode]
      ,[storeysnumber]
      ,[floor]
      ,[flat]
      ,[exit]
      ,[moreinformation]
      ,[longitude]
      ,[latitude]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date]
  )

  OUTPUT [inserted].[Id] INTO @output_applicant (Id)

  SELECT @applicant_last_name [last_name]
      ,@applicant_first_name [first_name]
      ,@applicant_middle_name [middle_name]
      ,@applicant_person_phone [person_phone]
      ,@applicant_sex [sex]
      ,@applicant_birth_date [birth_date]
      ,@applicant_building_id [building_id]
      ,@applicant_entrance [entrance]
      ,@applicant_entercode [entercode]
      ,@applicant_storeysnumber [storeysnumber]
      ,@applicant_floor [floor]
      ,@applicant_flat [flat]
      ,@applicant_exit [exit]
      ,@applicant_moreinformation [moreinformation]
      ,@applicant_longitude [longitude]
      ,@applicant_latitude [latitude]
      ,@user_id [user_id]
      ,GETUTCDATE() [create_date]
      ,@user_id [user_edit_id]
      ,GETUTCDATE() [edit_date];

END

	  INSERT INTO [dbo].[Persons]
  (
  [last_name]
      ,[first_name]
      ,[middle_name]
      ,[person_phone]
      ,[sex]
      ,[birth_date]
      ,[building_id]
      ,[entrance]
      ,[entercode]
      ,[storeysnumber]
      ,[floor]
      ,[flat]
      ,[exit]
      ,[moreinformation]
      ,[longitude]
      ,[latitude]
      ,[user_id]
      ,[create_date]
      ,[user_edit_id]
      ,[edit_date]
  )

  OUTPUT [inserted].[Id] INTO @output_pacient (Id)

  SELECT @pacient_last_name [last_name]
      ,@pacient_first_name [first_name]
      ,@pacient_middle_name [middle_name]
      ,@pacient_person_phone [person_phone]
      ,@pacient_sex [sex]
      ,@pacient_birth_date [birth_date]
      ,@pacient_building_id [building_id]
      ,@pacient_entrance [entrance]
      ,@pacient_entercode [entercode]
      ,@pacient_storeysnumber [storeysnumber]
      ,@pacient_floor [floor]
      ,@pacient_flat [flat]
      ,@pacient_exit [exit]
      ,@pacient_moreinformation [moreinformation]
      ,@pacient_longitude [longitude]
      ,@pacient_latitude [latitude]
      ,@user_id [user_id]
      ,GETUTCDATE() [create_date]
      ,@user_id [user_edit_id]
      ,GETUTCDATE() [edit_date];


	  ----------табличка события

	  INSERT INTO [dbo].[Events]
  (
  [receipt_date]
      ,[work_line_id]
      ,[work_line_value]
      ,[category_id]
      ,[event_date]
      ,[applicant_id]
      ,[patient_id]
      ,[applicant_type_id]
      ,[building_id]
      ,[entrance]
      ,[entercode]
      ,[storeysnumber]
      ,[floor]
      ,[flat/office]
      ,[exit]
      ,[moreinformation]
      ,[longitude]
      ,[latitude]
      ,[content]
      ,[sipcallid]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
  )

  OUTPUT [inserted].[Id] INTO @output_event (Id)

  SELECT @event_receipt_date [receipt_date]
      ,@event_work_line_id [work_line_id]
      ,@event_work_line_value [work_line_value]
      ,@event_category_id [category_id]
      ,@event_event_date [event_date]
      ,CASE WHEN @for_yourself103='true'
      THEN (SELECT TOP 1 Id FROM @output_pacient)
      ELSE (SELECT TOP 1 Id FROM @output_applicant) END [applicant_id]
      ,(SELECT TOP 1 Id FROM @output_pacient) [patient_id]
      ,@event_applicant_type_id [applicant_type_id]
      --,@event_building_id [building_id]
      ,CASE WHEN @event_building_id IS NULL AND @pacient_building_id IS NOT NULL THEN @pacient_building_id
            WHEN @event_building_id IS NULL AND @pacient_building_id IS NULL THEN @applicant_building_id
            ELSE @event_building_id END
      --,@event_entrance [entrance]
      ,CASE WHEN @event_entrance IS NULL AND @pacient_entrance IS NOT NULL THEN @pacient_entrance
            WHEN @event_entrance IS NULL AND @pacient_entrance IS NULL THEN @applicant_entrance
            ELSE @event_entrance END
      --,@event_entercode [entercode]
      ,CASE WHEN @event_entercode IS NULL AND @pacient_entercode IS NOT NULL THEN @pacient_entercode
            WHEN @event_entercode IS NULL AND @pacient_entercode IS NULL THEN @applicant_entercode
            ELSE @event_entercode END
      --,@event_storeysnumber [storeysnumber]
      ,CASE WHEN @event_storeysnumber IS NULL AND @pacient_storeysnumber IS NOT NULL THEN @pacient_storeysnumber
            WHEN @event_storeysnumber IS NULL AND @pacient_storeysnumber IS NULL THEN @applicant_storeysnumber
            ELSE @event_storeysnumber END
      --,@event_floor [floor]
      ,CASE WHEN @event_floor IS NULL AND @pacient_floor IS NOT NULL THEN @pacient_floor
            WHEN @event_floor IS NULL AND @pacient_floor IS NULL THEN @applicant_floor
            ELSE @event_floor END
      --,@event_flat_office [flat/office]
      ,CASE WHEN @event_flat_office IS NULL AND @pacient_flat IS NOT NULL THEN @pacient_flat
            WHEN @event_flat_office IS NULL AND @pacient_flat IS NULL THEN @applicant_flat
            ELSE @event_flat_office END
      --,@event_exit [exit]
      ,CASE WHEN @event_exit IS NULL AND @pacient_exit IS NOT NULL THEN @pacient_exit
            WHEN @event_exit IS NULL AND @pacient_exit IS NULL THEN @applicant_exit
            ELSE @event_exit END
      --,@event_moreinformation [moreinformation]
      ,CASE WHEN @event_moreinformation IS NULL AND @pacient_moreinformation IS NOT NULL THEN @pacient_moreinformation
            WHEN @event_moreinformation IS NULL AND @pacient_moreinformation IS NULL THEN @applicant_moreinformation
            ELSE @event_moreinformation END
      --,@event_longitude [longitude]
      ,CASE WHEN @event_longitude IS NULL AND @pacient_longitude IS NOT NULL THEN @pacient_longitude
            WHEN @event_longitude IS NULL AND @pacient_longitude IS NULL THEN @applicant_longitude
            ELSE @event_longitude END

      ,CASE WHEN @event_latitude IS NULL AND @pacient_latitude IS NOT NULL THEN @pacient_latitude
            WHEN @event_latitude IS NULL AND @pacient_latitude IS NULL THEN @applicant_latitude
            ELSE @event_latitude END
      --,@event_latitude [latitude]
      ,@event_content [content]
      ,@event_sipcallid [sipcallid]
      ,@user_id [user_id]
      ,GETUTCDATE() [edit_date]
      ,@user_id [user_edit_id];



-- 	DECLARE @Services_EX NVARCHAR(MAX)=

--   N'SELECT '+(SELECT TOP 1 LTRIM(id) FROM @output_event)+N' event_id, 
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
  --EXEC(@Services_EX);


  --- заполнение [PersonClasses]
  DECLARE @PersonClasses_EX NVARCHAR(max)=
  N'
  SELECT 
	   '+(SELECT TOP 1 LTRIM(id) FROM @output_applicant)+N' [person_id]
      ,id [class_id]
      ,N'''+@user_id+N''' [user_id]
      ,GETUTCDATE() [create_date]
      ,N'''+@user_id+N''' [user_edit_id]
      ,GETUTCDATE() [edit_date]
  FROM [dbo].[Classes]
  WHERE id IN ('+CASE WHEN @pacient_classes_ids IS NULL OR @pacient_classes_ids=N'' THEN N'0' ELSE @pacient_classes_ids END+N')
  
  UNION 

  SELECT 
	   '+(SELECT TOP 1 LTRIM(id) FROM @output_pacient)+N' [person_id]
      ,id [class_id]
      ,N'''+@user_id+N''' [user_id]
      ,GETUTCDATE() [create_date]
      ,N'''+@user_id+N''' [user_edit_id]
      ,GETUTCDATE() [edit_date]
  FROM [dbo].[Classes]
  WHERE id IN ('+CASE WHEN @pacient_classes_ids IS NULL OR @pacient_classes_ids=N'' THEN N'0' ELSE @pacient_classes_ids END+N')';

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
  
