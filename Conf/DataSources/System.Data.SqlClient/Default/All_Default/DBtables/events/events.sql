/* 
 declare @organization_id int=250833;-- =2508;
 declare @user_id nvarchar(300)=N'42613f8b-e5fc-4365-83d6-a11126dfc820';--N'02ece542-2d75-479d-adad-fd333d09604d';
 */

 if OBJECT_ID('tempdb..#temp_orgs') is not null drop table #temp_orgs

--declare @Organization table(Id int);

if OBJECT_ID('tempdb..#temp_ob_in_org') is not null drop table #temp_ob_in_org
--DECLARE @ObjectInOrg TABLE ([object_id] INT)

if OBJECT_ID('tempdb..#temp_orgs_and_help') is not null drop table #temp_orgs_and_help

create table #temp_orgs_and_help (organization_id int)

--if @organization_id is not null
--	begin
--		  insert into #temp_orgs_and_help (organization_id)
--		  select organizations_id
--		  from [dbo].[Positions]
--		  where organizations_id=@organization_id
--		  --and programuser_id=@user_id
--		  union
--		  select [Positions2].organizations_id
--		  from [dbo].[Positions]
--		  inner join [dbo].[PositionsHelpers] on [Positions].Id=[PositionsHelpers].helper_position_id
--		  inner join [dbo].[Positions] [Positions2] on [PositionsHelpers].main_position_id=[Positions2].Id
--		  where [Positions].organizations_id=@organization_id --and [Positions].programuser_id=@user_id
--	end
--else
	--begin
			declare @organization_id_temp int=
		  (select organizations_id from [dbo].[Positions] where programuser_id=@user_id)

		  insert into #temp_orgs_and_help (organization_id)
		  select organizations_id
		  from [dbo].[Positions]
		  where organizations_id=@organization_id_temp
		  and programuser_id=@user_id
		  union
		  select [Positions2].organizations_id
		  from [dbo].[Positions]
		  inner join [dbo].[PositionsHelpers] on [Positions].Id=[PositionsHelpers].helper_position_id
		  inner join [dbo].[Positions] [Positions2] on [PositionsHelpers].main_position_id=[Positions2].Id
		  where [Positions].organizations_id=@organization_id_temp and [Positions].programuser_id=@user_id
	--end

--убрать начало
--declare @OrganizationId int = 
--case 
--when @organization_id is not null
--then @organization_id
--else (select organization_id
--  from [dbo].[Workers] with (nolock)
--  --inner join [dbo].[Organizations] with (nolock) ON [Organizations].Id=[Workers].organization_id
--  where worker_user_id=@user_id)
-- end;

 --убрать конец

 --select @OrganizationId;

--declare @IdT table (Id int);

		;with
		it as --дети @id
		(select Id, [parent_organization_id] ParentId, name
		from [dbo].[Organizations] t with (nolock)
		inner join #temp_orgs_and_help on t.Id=#temp_orgs_and_help.organization_id
		--where id=@OrganizationId
		union all
		select t.Id, t.[parent_organization_id] ParentId, t.name
		from [dbo].[Organizations] t with (nolock)
		inner join it on t.[parent_organization_id]=it.Id)
--,pit as -- родители @id
--(
--select Id, [parent_organization_id] ParentId, name
--from [dbo].[Organizations] t
--where Id=@OrganizationId
--union all
--select t.Id, t.[parent_organization_id] ParentId, t.name
--from [dbo].[Organizations] t inner join pit on t.Id=pit.ParentId
--)

select Id 
into #temp_orgs
from it-- pit it

CREATE INDEX in_id ON #temp_orgs (Id); -- создание индекса


--select * from #temp_orgs t-- order by id


-- тут

-- for global Gorodok
--insert into @ObjectInOrg (object_id)
select distinct
	eo.object_id 
into #temp_ob_in_org
from #temp_orgs org
inner join ExecutorInRoleForObject as eo with (nolock) on eo.executor_id = org.Id
where eo.object_id is not null

CREATE INDEX in_object_id ON #temp_ob_in_org (object_id); -- создание индекса

--select * from #temp_ob_in_org
--тут



if OBJECT_ID('tempdb..#temp_Events_1') is not null drop table #temp_Events_1


  select Id, 
    active, 
    [plan_end_date], 
    gorodok_id 
    --event_type_id, 
    --start_date, 
    --EventName
	into #temp_Events_1
   from (
  select 
    [Events].Id, 
    [Events].active, 
    [Events].[plan_end_date], 
    [Events].gorodok_id 
    --[Events].event_type_id, 
    --[Events].start_date, 
    --[Event_Class].name EventName
  from   [dbo].[Events] with (nolock)
    inner join   [dbo].[EventOrganizers] with (nolock) on [Events].Id=[EventOrganizers].event_id
	inner join #temp_orgs orgs ON [EventOrganizers].organization_id=orgs.Id
    --left join [Event_Class] with (nolock) on [Events].event_class_id=[Event_Class].id
  --where [EventOrganizers].organization_id in (select id from #temp_orgs)
  
  union
  
  select 
    [Events].Id, 
    [Events].active, 
    [Events].[plan_end_date], 
    [Events].gorodok_id 
    --[Events].event_type_id, 
    --[Events].start_date, 
    --[Event_Class].name EventName
  from   [dbo].[Events] with (nolock)
    inner join   [dbo].[EventObjects] with (nolock) on [Events].Id=[EventObjects].event_id
    inner join   [dbo].[Objects] with (nolock) on [EventObjects].object_id=[Objects].Id
    inner join   [dbo].[Buildings] with (nolock) on [Buildings].Id=[Objects].builbing_id
    inner join   [dbo].[ExecutorInRoleForObject] with (nolock) on [ExecutorInRoleForObject].object_id=[Buildings].Id
	inner join #temp_orgs orgs ON [ExecutorInRoleForObject].executor_id=orgs.Id
    --left join [Event_Class] with (nolock) on [Events].event_class_id=[Event_Class].id
  where [ExecutorInRoleForObject].[executor_role_id] in (1, 68) /*балансоутримувач, генпідрядник*/
  --and [ExecutorInRoleForObject].executor_id in (select id from #temp_orgs)
  ) t;

  CREATE INDEX in_id ON #temp_Events_1 (Id); -- создание индекса

  if OBJECT_ID('tempdb..#temp_questions') is not null drop table #temp_questions

select  
q.Id
,q.event_id
into #temp_questions
FROM [Questions] as q with (nolock)
inner join #temp_Events_1 as e on q.event_id = e.Id


if OBJECT_ID('tempdb..#temp_Events_gorodok') is not null drop table #temp_Events_gorodok


    SELECT 
	     gl.[id] as Id
      ,case when gl.fact_finish_date is null then 1
		    else 0 end as active 
      ,gl.[plan_finish_date] as plan_end_date
      ,1 as [gorodok_id]
	    --,null as event_type_id
	    --,gl.[registration_date] as [start_date]
      --,gl.claims_type as EventName
	  into #temp_Events_gorodok
  FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_global] AS gl with (nolock)
      INNER JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] AS oc with (nolock) ON oc.claims_number_id = gl.claim_number
	  INNER JOIN [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses] gh with (nolock) ON gh.gorodok_houses_id = oc.object_id
	  INNER JOIN #temp_ob_in_org temp_ob_in_org ON gh.[1551_houses_id]=temp_ob_in_org.object_id
      --WHERE gh.[1551_houses_id] IN (SELECT [object_id] FROM #temp_ob_in_org t)
  --  JOIN (select * from [CRM_1551_GORODOK_Integrartion].[dbo].[AllObjectInClaim] where object_id in (select object_id from @ObjectInOrg)) AS oc ON oc.claims_number_id = gl.claim_number
 

 CREATE INDEX in_id ON #temp_Events_gorodok (Id); -- создание индекса

  if OBJECT_ID('tempdb..#temp_main') is not null drop table #temp_main


  select event_Id, 
    --event_type_id, 
    --EventType, 
    question_Id, 
    --start_date, 
    --plan_end_date, 
    --EventName,
    TypeEvent,
    OtKuda
  into #temp_main
  from
  (
  select 
    [Events_1].Id event_Id, 
    --[Events_1].event_type_id, 
    --[EventTypes].name EventType, 
    Questions.Id question_Id, 
    --[Events_1].start_date, 
    --[Events_1].plan_end_date, 
    --[Events_1].EventName,
    case when [Events_1].active =1 and [Events_1].[plan_end_date]>getutcdate() then N'В роботі'
        when [Events_1].active =1 and [Events_1].[plan_end_date]<=getutcdate() then N'Прострочені'
        when [Events_1].active =0 then N'Не активні' 
    end TypeEvent,
    case when [Events_1].gorodok_id=1 then N'Городок' else N'Система' 
    end OtKuda
  from #temp_Events_1 [Events_1]
  --left join Questions ON [Events_1].Id=Questions.Id
    --left join EventQuestionsTypes with (nolock) on EventQuestionsTypes.event_id = [Events_1].Id 
    --left join [EventObjects] with (nolock) on [EventObjects].event_id = [Events_1].Id
    --left join Questions on Questions.question_type_id = EventQuestionsTypes.question_type_id and [Questions].[object_id] = [EventObjects].[object_id]
	left join #temp_questions as Questions on Questions.event_id =[Events_1].Id 
    --left join [EventTypes] on [Events_1].event_type_id=[EventTypes].Id

    UNION   
	
    select 
    [Events_gorodok].Id event_Id, 
    --[Events_gorodok].event_type_id, 
    --null as EventType, 
    null as question_Id, 
    --[Events_gorodok].start_date, 
    --[Events_gorodok].plan_end_date, 
    --[Events_gorodok].EventName,
    case when [Events_gorodok].active =1 and [Events_gorodok].[plan_end_date]>getutcdate() then N'В роботі'
        when [Events_gorodok].active =1 and [Events_gorodok].[plan_end_date]<=getutcdate() then N'Прострочені'
        when [Events_gorodok].active =0 then N'Не активні' 
    end TypeEvent,
    case when [Events_gorodok].gorodok_id=1 then N'Городок' else N'Система' 
    end OtKuda
  from #temp_Events_gorodok [Events_gorodok]
  ) t

  CREATE INDEX in_id ON #temp_main (event_Id); -- создание индекса

  --select * from #temp_main


-- select * from main
  if OBJECT_ID('tempdb..#temp_typ') is not null drop table #temp_typ
  select * 
  into #temp_typ
  from 
  (
    select 
      1 Id, 
      N'Городок' name 
      union all 
      select 
        2 Id, 
        N'Система') t

 /* select typ.Id, typ.name typ, main.TypeEvent, count(main.question_Id) count_questions
  from typ left join main on typ.name=main.OtKuda
  group by typ.Id, typ.name, main.TypeEvent

 */ 
 -- количество вопросов в типе
   if OBJECT_ID('tempdb..#temp_count_questions') is not null drop table #temp_count_questions

  select 
    Id, 
    typ, 
    isnull([Прострочені], 0) [Прострочені], 
    isnull([Не активні], 0) [Не активні], 
    isnull([В роботі],0) [В роботі]
	into #temp_count_questions
  from
  (select typ.Id, typ.name typ, main.TypeEvent, count(main.question_Id) count_questions
  from #temp_typ typ left join #temp_main main on typ.name=main.OtKuda
  group by typ.Id, typ.name, main.TypeEvent) t
  pivot 
  (
  sum(count_questions) for TypeEvent in ([Прострочені], [Не активні], [В роботі])
  ) pvt
  
-- select * from count_questions
   if OBJECT_ID('tempdb..#temp_count_events') is not null drop table #temp_count_events


  select 
    Id, 
    typ, 
    isnull([Прострочені], 0) [Прострочені], 
    isnull([Не активні], 0) [Не активні], 
    isnull([В роботі],0) [В роботі]
	into #temp_count_events
  from
  (select typ.Id, typ.name typ, main.TypeEvent, count(distinct main.event_Id) count_events
  from #temp_typ typ left join #temp_main main on typ.name=main.OtKuda
  group by typ.Id, typ.name, main.TypeEvent) t
  pivot 
  (
  sum(count_events) for TypeEvent in ([Прострочені], [Не активні], [В роботі])
  ) pvt
 

 select 
  count_questions.Id, 
  count_questions.typ [type], 
  ltrim(count_events.Прострочені)+N' ('+ltrim(count_questions.Прострочені)+N')' [Прострочені],
  ltrim(count_events.[Не активні])+N' ('+ltrim(count_questions.[Не активні])+N')' [Не активні],
  ltrim(count_events.[В роботі])+N' ('+ltrim(count_questions.[В роботі])+N')' [В роботі]
 from #temp_count_questions count_questions 
 inner join #temp_count_events count_events on count_questions.Id=count_events.Id


 --select * from #temp_Events_1 where plan_end_date<=getutcdate() and active=1

-- select * from #temp_main