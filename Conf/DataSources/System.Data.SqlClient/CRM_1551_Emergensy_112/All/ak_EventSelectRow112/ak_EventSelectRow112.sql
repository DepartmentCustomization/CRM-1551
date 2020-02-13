
  --DECLARE @event_id INT =1;

  SELECT DISTINCT e.Id
      ,e.[id] [event_id]
      ,e.[receipt_date] [event_receipt_date]
      ,e.[work_line_id] [event_work_line_id]
      ,e.[work_line_value] [event_work_line_value]
      ,e.[category_id] [event_category_id]
	  ,c.name [event_category_name]
      ,e.[event_date] [event_event_date]
      --,e.[applicant_id] [event_applicant_id]
      --,e.[patient_id] [event_patient_id]
      ,e.[applicant_type_id] [event_applicant_type_id]
      ,e.[building_id] [event_building_id]
	  ,ISNULL(ste.shortname, N'')+ISNULL(se.name+N' ', N'')+ISNULL(be.name, N'') [event_address]
      ,e.[entrance] [event_entrance]
      ,e.[entercode] [event_entercode]
      ,e.[storeysnumber] [event_storeysnumber]
      ,e.[floor] [event_floor]
      ,e.[flat/office] [event_flat/office]
      ,e.[exit] [event_exit]
      ,e.[moreinformation] [event_moreinformation]
      ,e.[longitude] [event_longitude]
      ,e.[latitude] [event_latitude]
      ,e.[content] [event_content]
      ,e.[sipcallid] [event_sipcallid]


	  ,app.id [applicant_id]
	  ,app.[last_name] [applicant_last_name]
      ,app.[first_name] [applicant_first_name]
      ,app.[middle_name] [applicant_middle_name]
      ,app.[person_phone] [applicant_person_phone]
      ,app.[sex] [applicant_sex]
      ,app.[birth_date] [applicant_birth_date]
      ,app.[building_id] [applicant_building_id]
	  ,ISNULL(stapp.shortname, N'')+ISNULL(sapp.name+N' ', N'')+ISNULL(bapp.name, N'') [applicant_address]
      ,app.[entrance] [applicant_entrance]
      ,app.[entercode] [applicant_entercode]
      ,app.[storeysnumber] [applicant_storeysnumber]
      ,app.[floor] [applicant_floor]
      ,app.[flat] [applicant_flat]
      ,app.[exit] [applicant_exit]
      ,app.[moreinformation] [applicant_moreinformation]
      ,app.[longitude] [applicant_longitude]
      ,app.[latitude] [applicant_latitude]


	  ,p.[id] [pacient_id]
	  ,p.[last_name] [pacient_last_name]
      ,p.[first_name] [pacient_first_name]
      ,p.[middle_name] [pacient_middle_name]
      ,p.[person_phone] [pacient_person_phone]
      ,p.[sex] [pacient_sex]
      ,p.[birth_date] [pacient_birth_date]
      ,p.[building_id] [pacient_building_id]
	  ,ISNULL(stp.shortname, N'')+ISNULL(sp.name+N' ', N'')+ISNULL(bp.name, N'') [pacient_address]
      ,p.[entrance] [pacient_entrance]
      ,p.[entercode] [pacient_entercode]
      ,p.[storeysnumber] [pacient_storeysnumber]
      ,p.[floor] [pacient_floor]
      ,p.[flat] [pacient_flat]
      ,p.[exit] [pacient_exit]
      ,p.[moreinformation] [pacient_moreinformation]
      ,p.[longitude] [pacient_longitude]
      ,p.[latitude] [pacient_latitude]

	--   ,(SELECT STUFF((
  -- SELECT N', '+LTRIM([service_id])
  -- FROM [dbo].[EventExecutors]
  -- WHERE [EventExecutors].event_id=e.id
  -- FOR XML PATH('')), 1, 2, N'')) service_ids

  , ISNULL((SELECT TOP 1 CONVERT(BIT, 'true') FROM [dbo].[EventExecutors] WHERE [service_id]=1 AND [event_id]=e.id),'false') event_fire

  , ISNULL((SELECT TOP 1 CONVERT(BIT, 'true') FROM [dbo].[EventExecutors] WHERE [service_id]=2 AND [event_id]=e.id), 'false') event_police
  
  , ISNULL((SELECT TOP 1 CONVERT(BIT, 'true') FROM [dbo].[EventExecutors] WHERE [service_id]=3 AND [event_id]=e.id), 'false') event_medical

  , ISNULL((SELECT TOP 1 CONVERT(BIT, 'true') FROM [dbo].[EventExecutors] WHERE [service_id]=4 AND [event_id]=e.id), 'false') event_gas


  ,(SELECT STUFF((SELECT N', '+LTRIM(c.id)
  FROM [dbo].[PersonClasses] pc
  INNER JOIN [dbo].[Classes] c ON pc.class_id=c.id
  WHERE pc.person_id=app.id
  FOR XML PATH('')), 1, 2, N'')) applicant_classes_ids

  ,(SELECT STUFF((SELECT N', '+LTRIM(c.id)
  FROM [dbo].[PersonClasses] pc
  INNER JOIN [dbo].[Classes] c ON pc.class_id=c.id
  WHERE pc.person_id=p.id
  FOR XML PATH('')), 1, 2, N'')) pacient_classes_ids
  

  FROM [dbo].[Events] e
  LEFT JOIN [dbo].[Persons] app ON e.applicant_id=app.Id
  LEFT JOIN [dbo].[Persons] p ON e.patient_id=p.id
  LEFT JOIN [dbo].[Categories] c ON e.category_id=c.id

  LEFT JOIN [CRM_1551_Analitics].[dbo].[Buildings] be ON e.building_id=be.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Objects] oe ON oe.builbing_id=be.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].Streets se ON be.street_id=se.id
  LEFT JOIN [CRM_1551_Analitics].[dbo].StreetTypes ste ON se.street_type_id=ste.id

  LEFT JOIN [CRM_1551_Analitics].[dbo].[Buildings] bapp ON e.building_id=bapp.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Objects] oapp ON oapp.builbing_id=bapp.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].Streets sapp ON bapp.street_id=sapp.id
  LEFT JOIN [CRM_1551_Analitics].[dbo].StreetTypes stapp ON sapp.street_type_id=stapp.id

  LEFT JOIN [CRM_1551_Analitics].[dbo].[Buildings] bp ON e.building_id=bp.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].[Objects] op ON op.builbing_id=bp.Id
  LEFT JOIN [CRM_1551_Analitics].[dbo].Streets sp ON bp.street_id=sp.id
  LEFT JOIN [CRM_1551_Analitics].[dbo].StreetTypes stp ON sp.street_type_id=sp.Id


  WHERE e.id=@event_id;