
-- declare @organization_id int =2006;
-- declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';

declare @Organization table(Id int);
DECLARE @ObjectInOrg TABLE ([object_id] INT)

declare @OrganizationId int = 
case 
when @organization_id is not null
then @organization_id
else (select Id
  from [CRM_1551_Analitics].[dbo].[Organizations]
  where Id in (select organization_id
  from [CRM_1551_Analitics].[dbo].[Workers]
  where worker_user_id=@user_id))
 end


declare @IdT table (Id int);

-- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
insert into @IdT(Id)
select Id from [CRM_1551_Analitics].[dbo].[Organizations] 
where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

--  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)) q)!=0
begin

insert into @IdT
select Id from [CRM_1551_Analitics].[dbo].[Organizations]
where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
and Id not in (select Id from @IdT)
end 

insert into @Organization (Id)
select Id from @IdT

-- for global Gorodok
insert into @ObjectInOrg (object_id)
select 
	eo.object_id as obj_id
from @Organization org
join ExecutorInRoleForObject as eo on eo.executor_id = org.Id
where eo.object_id is not null

;with
  [Events_1] as 
  (
  select 
    [Events].Id, 
    [Events].active, 
    [Events].[plan_end_date], 
    [Events].gorodok_id, 
    [Events].event_type_id, 
    [Events].start_date, 
    [Event_Class].name EventName
  from [CRM_1551_Analitics].[dbo].[Events]
    inner join [CRM_1551_Analitics].[dbo].[EventOrganizers] on [Events].Id=[EventOrganizers].event_id
    left join [Event_Class] on [Events].event_class_id=[Event_Class].id
  where [EventOrganizers].organization_id in (select id from @Organization)
  
  union
  
  select 
    [Events].Id, 
    [Events].active, 
    [Events].[plan_end_date], 
    [Events].gorodok_id, 
    [Events].event_type_id, 
    [Events].start_date, 
    [Event_Class].name EventName
  from [CRM_1551_Analitics].[dbo].[Events] 
    inner join [CRM_1551_Analitics].[dbo].[EventObjects] on [Events].Id=[EventObjects].event_id
    left join [CRM_1551_Analitics].[dbo].[Objects] on [EventObjects].object_id=[Objects].Id
    left join [CRM_1551_Analitics].[dbo].[Buildings] on [Buildings].Id=[Objects].builbing_id
    left join [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject] on [ExecutorInRoleForObject].object_id=[Buildings].Id
    left join [Event_Class] on [Events].event_class_id=[Event_Class].id
  where [ExecutorInRoleForObject].[executor_role_id] in (1, 68) /*балансоутримувач, генпідрядник*/
  and [ExecutorInRoleForObject].executor_id in (select id from @Organization)
  
  ),

  [Events_gorodok] as 
  (
    SELECT 
	     gl.[id] as Id
      ,case when gl.fact_finish_date is null then 1
		    else 0 end as active 
      ,gl.[plan_finish_date] as plan_end_date
      ,1 as [gorodok_id]
	    ,null as event_type_id
	    ,gl.[registration_date] as [start_date]
      ,gl.claims_type as EventName
  FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] AS gl
      JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] AS oc ON oc.claims_number_id = gl.claim_number
	  JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] gh ON gh.gorodok_houses_id = oc.object_id
      WHERE gh.[1551_houses_id] IN (SELECT [object_id] FROM @ObjectInOrg)
  --  JOIN (select * from [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] where object_id in (select object_id from @ObjectInOrg)) AS oc ON oc.claims_number_id = gl.claim_number
  ),

  main as
  (
  select 
    [Events_1].Id event_Id, 
    [Events_1].event_type_id, 
    [EventTypes].name EventType, 
    Questions.Id question_Id, 
    [Events_1].start_date, 
    [Events_1].plan_end_date, 
    [Events_1].EventName,
    case when [Events_1].active =1 and [Events_1].[plan_end_date]>getutcdate() then N'В роботі'
        when [Events_1].active =1 and [Events_1].[plan_end_date]<=getutcdate() then N'Прострочені'
        when [Events_1].active =0 then N'Не активні' 
    end TypeEvent,
    case when [Events_1].gorodok_id=1 then N'Городок' else N'Система' 
    end OtKuda
  from [Events_1]
    left join EventQuestionsTypes on EventQuestionsTypes.event_id = [Events_1].Id 
    left join [EventObjects] on [EventObjects].event_id = [Events_1].Id
    --left join Questions on Questions.question_type_id = EventQuestionsTypes.question_type_id and [Questions].[object_id] = [EventObjects].[object_id]
	left join (select 
					   --count(q.Id)
					   q.Id
					   ,q.question_type_id
					   ,q.object_id
					   ,e.id as event_id
					FROM [Events] as e
    					left join EventQuestionsTypes as eqt on eqt.event_id = e.Id 
    					left join [EventObjects] as eo on eo.event_id = e.Id
    					left join Questions as q on q.question_type_id = eqt.question_type_id and q.[object_id] = eo.[object_id]
    					left join Assignments on Assignments.Id = q.last_assignment_for_execution_id
					where  q.registration_date >= e.registration_date
					and eqt.[is_hard_connection] = 1
					AND Assignments.main_executor = 1
					AND Assignments.assignment_state_id <> 5
					and q.question_state_id <> 5
				) as Questions on Questions.event_id =[Events_1].Id and  Questions.question_type_id = EventQuestionsTypes.question_type_id and [Questions].[object_id] = [EventObjects].[object_id]
    left join [EventTypes] on [Events_1].event_type_id=[EventTypes].Id

    UNION  all  

    select 
    [Events_gorodok].Id event_Id, 
    [Events_gorodok].event_type_id, 
    null as EventType, 
    null as question_Id, 
    [Events_gorodok].start_date, 
    [Events_gorodok].plan_end_date, 
    [Events_gorodok].EventName,
    case when [Events_gorodok].active =1 and [Events_gorodok].[plan_end_date]>getutcdate() then N'В роботі'
        when [Events_gorodok].active =1 and [Events_gorodok].[plan_end_date]<=getutcdate() then N'Прострочені'
        when [Events_gorodok].active =0 then N'Не активні' 
    end TypeEvent,
    case when [Events_gorodok].gorodok_id=1 then N'Городок' else N'Система' 
    end OtKuda
  from [Events_gorodok]
  ),
-- select * from main
  typ as 
  (
    select 
      1 Id, 
      N'Городок' name 
      
      union all 
      
      select 
        2 Id, 
        N'Система'
  )

 /* select typ.Id, typ.name typ, main.TypeEvent, count(main.question_Id) count_questions
  from typ left join main on typ.name=main.OtKuda
  group by typ.Id, typ.name, main.TypeEvent

 */ 
 -- количество вопросов в типе
 , count_questions as
 (
  select 
    Id, 
    typ, 
    isnull([Прострочені], 0) [Прострочені], 
    isnull([Не активні], 0) [Не активні], 
    isnull([В роботі],0) [В роботі]
  from
  (select typ.Id, typ.name typ, main.TypeEvent, count(main.question_Id) count_questions
  from typ left join main on typ.name=main.OtKuda
  group by typ.Id, typ.name, main.TypeEvent) t
  pivot 
  (
  sum(count_questions) for TypeEvent in ([Прострочені], [Не активні], [В роботі])
  ) pvt
  ),
-- select * from count_questions
  count_events as
  (
  select 
    Id, 
    typ, 
    isnull([Прострочені], 0) [Прострочені], 
    isnull([Не активні], 0) [Не активні], 
    isnull([В роботі],0) [В роботі]
  from
  (select typ.Id, typ.name typ, main.TypeEvent, count(distinct main.event_Id) count_events
  from typ left join main on typ.name=main.OtKuda
  group by typ.Id, typ.name, main.TypeEvent) t
  pivot 
  (
  sum(count_events) for TypeEvent in ([Прострочені], [Не активні], [В роботі])
  ) pvt
 )

 select 
  count_questions.Id, 
  count_questions.typ [type], 
  ltrim(count_events.Прострочені)+N' ('+ltrim(count_questions.Прострочені)+N')' [Прострочені],
  ltrim(count_events.[Не активні])+N' ('+ltrim(count_questions.[Не активні])+N')' [Не активні],
  ltrim(count_events.[В роботі])+N' ('+ltrim(count_questions.[В роботі])+N')' [В роботі]
 from count_questions inner join count_events on count_questions.Id=count_events.Id
