 	select 
	q.Id
	  ,q.registration_number
	  ,q.registration_date
	  ,Organizations.short_name as org_name
	FROM [Events] as e
	left join EventQuestionsTypes as eqt on eqt.event_id = e.Id 
	left join [EventObjects] as eo on eo.event_id = e.Id
	left join Questions as q on q.question_type_id = eqt.question_type_id and q.[object_id] = eo.[object_id]
	left join Assignments on Assignments.Id = q.last_assignment_for_execution_id
	left join Organizations on Organizations.Id = Assignments.executor_organization_id
	where e.Id = @Id
	and q.registration_date  between  DATEADD(hour, -6, e.registration_date)  and e.registration_date
  and eqt.[is_hard_connection] = 0
      and #filter_columns#
      #sort_columns#
     offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 
 
 /*
 --declare @event_Id int =7;
  --declare @object_type_id int =70;

 --declare @event_Id int =7;
  --declare @question_type_id int =52;
  declare @reg_event_date datetime= (select [registration_date] from [Events] where Id = @Id)

  select [Questions].Id, [Questions].registration_number, [QuestionTypes].name QuestionType,
  [StreetTypes].shortname+N' '+[Streets].name+N' '+isnull(ltrim([Buildings].number), N'')+isnull([Buildings].letter, N'') place,
  [Questions].registration_date--, [Events].registration_date
  from [CRM_1551_Analitics].[dbo].[Questions]
  --inner join [CRM_1551_Analitics].[dbo].[Events] on [Questions].event_id=[Events].Id
  inner join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].[object_id]=[Objects].Id
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  left join EventQuestionsTypes as eqt on eqt.[question_type_id] = Questions.question_type_id
  where 
--   [Questions].registration_date between dateadd(minute, -30, @registration_date) and @registration_date
    [Questions].registration_date between  DATEADD(hour, -6, @reg_event_date)  and @registration_date
--   and 
--   eqt.[is_hard_connection] = 0
   and
  [Questions].question_type_id=@question_type_id --and [Events].Id=47
  */
