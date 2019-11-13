

  --declare @Id int =5392181;

  select top 1 [Appeals].Id AppealsId, 
  --[ReceiptSources].name [ReceiptSources],
  --група полів Загальна Інформація
  3 [ReceiptSources_id],
  N'УГЛ' [ReceiptSources],
  [Звернення УГЛ].[№ звернення] [IncomeNumber],
  [Appeals].enter_number [AppealNumber],
  --[Звернення УГЛ].[Телефон] [PhoneNumber], -- только вотображать первый (доделать)

  case when CHARINDEX(N',', [Звернення УГЛ].[Телефон], 1)>1 
  then left([Звернення УГЛ].[Телефон], CHARINDEX(N',', [Звернення УГЛ].[Телефон], 1)-1) 
  else [Звернення УГЛ].[Телефон] end [PhoneNumber],
  [Звернення УГЛ].[Дата завантаження] [ReceiptsDate],--дата та час надходження
  --група полів Заявник
  --скрыта колонка номер 1
  --скрыта колонка номер 2
  --скрыта колонка номер 3
  /*может что-то и нужно, может в детали запрос выводится, согласно описанию*/
  [Звернення УГЛ].[Заявник] Applicant_PIB,-- [FIO],
  [Звернення УГЛ].Адреса [Address],
  stuff(isnull(N', E-mail: '+[Звернення УГЛ].[E-mail], N'')+
  isnull(N', Соціальний стан: '+[Звернення УГЛ].[Соціальний стан], N'')+ 
  isnull(N', Категорія: '+[Звернення УГЛ].[Категорія], N'')+
  isnull(N', Дата народження: '+convert(nvarchar(20), [Звернення УГЛ].[Дата народження]), N''),1,2,N'') 
  [Info],
  --група полів реєстрація питання
  [Звернення УГЛ].[Зміст] [Content],
  isnull([StreetTypes].shortname,N'')+N' '+isnull([Streets].name,N'')+N' '+isnull([Buildings].name,N'') [Object_qustion],

  (SELECT [name]
  FROM [dbo].[AnswerTypes]
  where Id =5 /*(case 
	when @Id = 1 then 2
	when @Id = 2 then 4
	when @Id = 3 then 5
	when @Id = 4 then 3
	when @Id = 5 then 4
	else 1 end*/
  ) [Answer] 
  /*
  [Appeals].[phone_number], [Appeals].registration_number,
  [Appeals].enter_number, [Appeals].registration_date, [Applicants].full_name Applicants_full_name, [ApplicantPhones].phone_number,
  isnull([StreetTypes].shortname, N'')+N' '+isnull([Streets].name, N'')+isnull(N','+[Buildings].name, N'') Building, 
  [LiveAddress].entrance, [LiveAddress].flat, [Districts].name District
  ,[Звернення УГЛ].Адреса addressUGL, 
   stuff((isnull(N', Соціальний стан- '+[Соціальний стан], N'')+
  isnull(N', Категорія- '+[Категорія],N'')+isnull(N', Дата народження- '+convert(nvarchar(20), [Дата народження]), N'')
  +isnull(N', E-mail-'+[E-mail], N'')),1,2,N'') Soc_and_td,
  [Звернення УГЛ].Зміст, [QuestionTypes].name QuestionType, [Objects].name [Object],
  [Organizations2].short_name Organization, [Questions].control_date,
  [Organizations_ex].short_name [Organizations_ex]
  */
  from [Appeals]
  left join [Звернення УГЛ] on [Appeals].[Id]=[Звернення УГЛ].[Appeals_id]
  left join [Questions] on [Appeals].Id=[Questions].appeal_id
  left join [ExecutorInRoleForObject] on [Questions].object_id=[ExecutorInRoleForObject].object_id
  left join [Buildings] on [ExecutorInRoleForObject].building_id=[Buildings].Id
  left join [dbo].[Streets] on [Streets].Id = [Buildings].street_id
  left join [dbo].[StreetTypes] on [StreetTypes].Id = [Streets].street_type_id
  /*
  left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
  left join [Applicants] on [Appeals].applicant_id=[Applicants].Id
  left join [ApplicantPhones] on [Applicants].Id=[ApplicantPhones].applicant_id
  left join [LiveAddress] on [Applicants].Id=[LiveAddress].applicant_id
  left join [Buildings] on [LiveAddress].building_id=[Buildings].Id
  left join [Streets] on [Buildings].street_id=[Streets].Id
  left join [StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  left join [Districts] on [Buildings].district_id=[Districts].Id
  left join [ExecutorInRoleForObject] on [Buildings].Id=[ExecutorInRoleForObject].building_id
  left join [Organizations] on [ExecutorInRoleForObject].executor_id=[Organizations].Id and [ExecutorInRoleForObject].executor_role_id=1
  left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [Objects] on [Questions].object_id=[Objects].Id
  left join [Organizations] [Organizations2] on [Questions].organization_id=[Organizations2].Id
  left join [Assignments] on [Questions].Id=[Assignments].question_id
  left join [Organizations] [Organizations_ex] on [Assignments].executor_organization_id=[Organizations_ex].Id
  */
  where [Appeals].Id=@Id
  --order by isnull([ApplicantPhones].phone_number,0)