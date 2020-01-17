
--declare @dat nvarchar(200)=N'2018-01';
declare @year int =left(@dat,4);
declare @month int =right(@dat,2);
--select @year, @month
declare @date date =(select DATEFROMPARTS(@year, @month, 1));

declare @date_old date =(select dateadd(mm, -1, @date))
--select @date_old


declare @date_start date= @date;
declare @date_start_old date= @date_old;
declare @date_end date= eomonth(@date);
declare @date_end_old date= eomonth(@date_old);

  with
    Organizations as
  (
  select	193 Id	, N'Районні у м. Києві адміністрації:' Name union all
select	194	, N'Голосіївська РДА' union all
select	195	, N'Дарницька РДА' union all
select	196	, N'Деснянська РДА' union all
select	197	, N'Дніпровська РДА' union all
select	198	, N'Оболонська РДА' union all
select	199	, N'Печерська РДА' union all
select	200	, N'Подільська  РДА' union all
select	201	, N'Святошинська РДА' union all
select	202	, N'Солом`янська РДА' union all
select	203	, N'Шевченківська РДА' union all
select	900	, N'Служби та підрозділи м. Києва:' union all
select	9564	, N'Центральна диспетчерська служба' union all
select	923	, N'ПАТ "Водоканал"' union all
select	5143	, N'Ліфтові організації м. Києва' union all
select	9443	, N'Радник керівника апарату КМР (КМДА)' union all
select	1020	, N'ПАТ "Київенерго"' union all
select	9103	, N'ДП "ГДІП"' union all
select	10263	, N'КП "Київтеплоенерго"' union all
select	9203	, N'ТОВ «Євро-Реконструкція»' union all
select	1523	, N'ПАТ "Київгаз"' union all
select	10043	, N'Громадська організація "ЛАКФАІНД"' union all
select	10003	, N'АТ «Ощадбанк»' 
  ),

  main as
  (
  select [Assignments].Id, [Assignments].registration_date, [Organizations].Id OrganizationId, [Organizations].name, 
  case when [Assignments].executor_organization_id is not null and convert(date, [Assignments].registration_date) between @date_start and @date_end then 1 else 0 end Nadiyshlo,
  case when [Assignments].registration_date<@date_start and [AssignmentStates].name=N'В роботі' then 1 else 0 end Bylo,

  case when ([AssignmentStates].name=N'Закрито' or [AssignmentStates].name=N'На перевірці') and [AssignmentResults].name=N'Виконано'
  and [Assignments].close_date<=dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and [Assignments].execution_date<=dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and convert(date, [Assignments].registration_date) between @date_start and @date_end then 1 else 0 end VykonVchasno,

    case when ([AssignmentStates].name=N'Закрито' or [AssignmentStates].name=N'На перевірці') and [AssignmentResults].name=N'Виконано'
  and [Assignments].close_date>dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and [Assignments].execution_date>dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and convert(date, [Assignments].registration_date) between @date_start and @date_end then 1 else 0 end VykonNeVchasno,

  case when ([AssignmentStates].name=N'Закрито' or [AssignmentStates].name=N'На перевірці') and [AssignmentResults].name=N'Роз`яснено'
  and [Assignments].close_date<=dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and [Assignments].execution_date<=dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and convert(date, [Assignments].registration_date) between @date_start and @date_end then 1 else 0 end RozyasnenoVchasno,

  case when ([AssignmentStates].name=N'Закрито' or [AssignmentStates].name=N'На перевірці') and [AssignmentResults].name=N'Роз`яснено'
  and [Assignments].close_date>dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and [Assignments].execution_date>dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and convert(date, [Assignments].registration_date) between @date_start and @date_end then 1 else 0 end RozyasnenoNeVchasno

  from [Organizations] left join -- left если нужны все
   [CRM_1551_Analitics].[dbo].[Assignments] on [Organizations].Id=[Assignments].executor_organization_id
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].AssignmentResultsId=[AssignmentResults].Id
  --where convert(date, [Assignments].registration_date) between @date_start and @date_end
  ),

  main_old as
  (
  select [Assignments].Id, [Assignments].registration_date, [Organizations].Id OrganizationId, [Organizations].name, 
  case when [Assignments].executor_organization_id is not null and convert(date, [Assignments].registration_date) between @date_start_old and @date_end_old then 1 else 0 end Nadiyshlo,
  case when [Assignments].registration_date<@date_start_old and [AssignmentStates].name=N'В роботі' then 1 else 0 end Bylo,

  case when ([AssignmentStates].name=N'Закрито' or [AssignmentStates].name=N'На перевірці') and [AssignmentResults].name=N'Виконано'
  and [Assignments].close_date<=dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and [Assignments].execution_date<=dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and convert(date, [Assignments].registration_date) between @date_start_old and @date_end_old then 1 else 0 end VykonVchasno,

    case when ([AssignmentStates].name=N'Закрито' or [AssignmentStates].name=N'На перевірці') and [AssignmentResults].name=N'Виконано'
  and [Assignments].close_date>dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and [Assignments].execution_date>dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and convert(date, [Assignments].registration_date) between @date_start_old and @date_end_old then 1 else 0 end VykonNeVchasno,

  case when ([AssignmentStates].name=N'Закрито' or [AssignmentStates].name=N'На перевірці') and [AssignmentResults].name=N'Роз`яснено'
  and [Assignments].close_date<=dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and [Assignments].execution_date<=dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and convert(date, [Assignments].registration_date) between @date_start_old and @date_end_old then 1 else 0 end RozyasnenoVchasno,

  case when ([AssignmentStates].name=N'Закрито' or [AssignmentStates].name=N'На перевірці') and [AssignmentResults].name=N'Роз`яснено'
  and [Assignments].close_date>dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and [Assignments].execution_date>dateadd(DD, QuestionTypes.execution_term, [Assignments].[registration_date])
  and convert(date, [Assignments].registration_date) between @date_start_old and @date_end_old then 1 else 0 end RozyasnenoNeVchasno

  from [Organizations] left join -- left если нужны все
   [CRM_1551_Analitics].[dbo].[Assignments] on [Organizations].Id=[Assignments].executor_organization_id
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].AssignmentResultsId=[AssignmentResults].Id
  --where convert(date, [Assignments].registration_date) between @date_start_old and @date_end_old
  ),

  secon as
  (select OrganizationId, name OrganizationName, sum(Bylo) Bylo, sum(Nadiyshlo) Nadiyshlo, sum(Bylo)+sum(Nadiyshlo) VRoboti,
  sum(VykonVchasno) VykonVchasno, sum(VykonNeVchasno) VykonNeVchasno, sum(RozyasnenoVchasno) RozyasnenoVchasno,
  sum(RozyasnenoNeVchasno) RozyasnenoNeVchasno, 
  case when sum(Bylo)=0 and sum(Nadiyshlo)=0 then 0
  else
  convert(numeric(8,2), convert(numeric(8,2),sum(VykonVchasno)+sum(VykonNeVchasno))/convert(numeric(8,2),(sum(Bylo)+sum(Nadiyshlo)))*100) end VidsVykon,
  100.00 VidsZad, 
  case when sum(Bylo)=0 and sum(Nadiyshlo)=0 then 0
  else convert(numeric(8,2), convert(numeric(8,2),sum(RozyasnenoVchasno)+sum(RozyasnenoNeVchasno))/convert(numeric(8,2),(sum(Bylo)+sum(Nadiyshlo)))*100) end VidsRozyasn

  from main
  --where OrganizationId=@city_id
  group by OrganizationId, name),

  secon_old as
  (select OrganizationId, name OrganizationName, sum(Bylo) Bylo, sum(Nadiyshlo) Nadiyshlo, sum(Bylo)+sum(Nadiyshlo) VRoboti,
  sum(VykonVchasno) VykonVchasno, sum(VykonNeVchasno) VykonNeVchasno, sum(RozyasnenoVchasno) RozyasnenoVchasno,
  sum(RozyasnenoNeVchasno) RozyasnenoNeVchasno, 
  case when sum(Bylo)=0 and sum(Nadiyshlo)=0 then 0
  else
  convert(numeric(8,2), convert(numeric(8,2),sum(VykonVchasno)+sum(VykonNeVchasno))/convert(numeric(8,2),(sum(Bylo)+sum(Nadiyshlo)))*100) end VidsVykon,
  100.00 VidsZad, 
  case when sum(Bylo)=0 and sum(Nadiyshlo)=0 then 0
  else convert(numeric(8,2), convert(numeric(8,2),sum(RozyasnenoVchasno)+sum(RozyasnenoNeVchasno))/convert(numeric(8,2),(sum(Bylo)+sum(Nadiyshlo)))*100) end VidsRozyasn

  from main_old
  --where OrganizationId=@city_id
  group by OrganizationId, name)

  select secon.OrganizationId, secon.OrganizationName, secon.VidsVykon, secon.VidsZad, secon.VidsRozyasn, convert(numeric(8,2),secon.VidsVykon*secon.VidsZad*secon.VidsRozyasn/1000000) ReitCoef,
  RANK() over (order by secon.VidsVykon) PlaceReitNew, RANK() over (order by secon_old.VidsVykon) PlaceReitOld
  from secon inner join secon_old on secon.OrganizationId=secon_old.OrganizationId