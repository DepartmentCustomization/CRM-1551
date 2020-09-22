
--declare @user_test nvarchar(128)=N'22a49077-6c39-40c2-9954-43bf859c2b05'--N'7bcdd0f7-3ed1-4570-b01b-dbd0daf70c1c';
--#system_database_name# CRM_1551_System
/* 
declare @date_from datetime='2020-07-31 21:00:00.000'
   ,@date_to datetime='2020-08-04 08:48:00.999'
   ,@organizations_Id nvarchar(200)=N'1762';
*/
--тут

IF OBJECT_ID('tempdb..#temp_positions_table') IS NOT NULL DROP TABLE #temp_positions_table;

   create table #temp_positions_table (Id int, organizations_id int, programuser_id nvarchar(128) COLLATE Ukrainian_CI_AS, PhoneNumber nvarchar(50) COLLATE Ukrainian_CI_AS)


   IF OBJECT_ID('tempdb..#temp_organizations_table') IS NOT NULL DROP TABLE #temp_organizations_table;

   IF @organizations_Id IS NULL
   BEGIN
    insert into #temp_positions_table (Id, [organizations_id], programuser_id, PhoneNumber )
	select Id, [organizations_id], programuser_id COLLATE Ukrainian_CI_AS, [User].PhoneNumber 
	from [dbo].[Positions] with (nolock)
	inner join [#system_database_name#].[dbo].[User] with (nolock) on [Positions].programuser_id=[User].UserId
   END

   ELSE
   BEGIN
	select value Id
	into #temp_organizations_table
	from string_split((select replace(@organizations_Id, N' ', N'')), N',')

	insert into #temp_positions_table (Id, [organizations_id], programuser_id, PhoneNumber)
	select [Positions].Id, [Positions].[organizations_id], [Positions].[programuser_id] COLLATE Ukrainian_CI_AS, [User].PhoneNumber
	from [dbo].[Positions] with (nolock)
	inner join #temp_organizations_table on [Positions].organizations_id=#temp_organizations_table.Id
	inner join [#system_database_name#].[dbo].[User] with (nolock) on [Positions].programuser_id=[User].UserId
   END

--select * from #temp_positions_table
--select * from #temp_organizations_table



declare @date_from_t nvarchar(max)=

CONVERT(datetime, SWITCHOFFSET(@date_from, DATEPART(TZOFFSET,@date_from AT TIME ZONE 'E. Europe Standard Time')))

declare @date_to_t nvarchar(max)=

CONVERT(datetime, SWITCHOFFSET(@date_to, DATEPART(TZOFFSET,@date_to AT TIME ZONE 'E. Europe Standard Time')))

IF OBJECT_ID('tempdb..#temp_CallStatistic') IS NOT NULL DROP TABLE #temp_CallStatistic;

create table #temp_CallStatistic (CallStatistic_Id int, OperatorCrm_Phone nvarchar(50) COLLATE Ukrainian_CI_AS, [TalkTime] int,
SipCallId nvarchar(100) COLLATE Ukrainian_CI_AS, CallSipChannel_Id int, DirectionId int, StatusId int)

declare @oqcall_s nvarchar(max)=N'select * from openquery([10.192.200.16], '''+N'
select [CallStatistic].Id CallStatistic_Id, [OperatorCrm].Phone COLLATE Ukrainian_CI_AS
, [CallOperator].[TalkTime], [CallSipChannel].SipCallId COLLATE Ukrainian_CI_AS SipCallId, [CallSipChannel].Id CallSipChannel_Id,
DirectionId, [CallOperator].StatusId
from [CallStatistic] with (nolock)
inner join [CallOperator] with (nolock) on [CallStatistic].Id=[CallOperator].CallStatisticId
inner join [OperatorCrm] with (nolock) on [CallOperator].OperatorId=[OperatorCrm].Id
left join [CallSipChannel] with (nolock) on [CallSipChannel].CallStatisticId=[CallStatistic].Id
where  
[CallStatistic].StartDate between '''''+@date_from_t+N''''' and '''''+@date_to_t+N''''''')'

--DirectionId=1 AND [CallOperator].StatusId=4 
--select @oqcall_s

insert into #temp_CallStatistic (CallStatistic_Id, OperatorCrm_Phone, [TalkTime], SipCallId, CallSipChannel_Id, DirectionId, StatusId)
exec (@oqcall_s)

--select * from #temp_CallStatistic

delete 
from #temp_CallStatistic
where #temp_CallStatistic.OperatorCrm_Phone not in (select PhoneNumber from #temp_positions_table)

--select * from #temp_CallStatistic

   IF OBJECT_ID('tempdb..#temp_Appeals') IS NOT NULL DROP TABLE #temp_Appeals;


  SELECT [Appeals].*
  into #temp_Appeals
FROM 
(
select
row_number() over (partition by [Appeals].[sipcallid]  
order by case when [Questions].appeal_id is null then 0 else 1 end+case when [Consultations].[appeal_id] is null then 0 else 1 end desc, [Appeals].Id) n
,[Appeals].Id
,[Questions].appeal_id Questions_appeal_id
,[Consultations].[appeal_id] Consultations_appeal_id
  from [dbo].[Appeals] with (nolock)
  left join (select distinct [appeal_id] from [dbo].[Questions] with (nolock)) [Questions] on [Appeals].Id=[Questions].appeal_id
  left join (select distinct [appeal_id] from  [dbo].[Consultations] with (nolock)) [Consultations] on [Appeals].Id=[Consultations].[appeal_id]
  where --([Questions].Id is not null or [Consultations].[appeal_id] is not null) and
  [Appeals].[receipt_source_id] in (1,8) and ISNULL([Appeals].sipcallid,N'0') NOT IN (N'0', N'{sipCallId}', N'', N'{ID}') and [Appeals].[registration_date] between @date_from and @date_to
  ) t 
  INNER JOIN [dbo].[Appeals] with (nolock)
  on [Appeals].Id=t.Id
  where n=1 or (Questions_appeal_id is not null or Consultations_appeal_id is not null)
  
  create index ind on #temp_Appeals(Id)


   IF OBJECT_ID('tempdb..#temp_call') IS NOT NULL DROP TABLE #temp_call;

   select [User].UserId user_id, ISNULL([User].[LastName]+N' ', N'')+ISNULL([User].[FirstName], N'') user_name, 
  count(distinct [CallStatistic].CallStatistic_Id) count_call
  into #temp_call
  from #temp_CallStatistic [CallStatistic]
  inner join [#system_database_name#].[dbo].[User] on [CallStatistic].OperatorCrm_Phone=[User].PhoneNumber
  where DirectionId=1 AND StatusId=4 
  group by [User].UserId, ISNULL([User].[LastName]+N' ', N'')+ISNULL([User].[FirstName], N'') 


  IF OBJECT_ID('tempdb..#temp_call10sec') IS NOT NULL DROP TABLE #temp_call10sec;

  --select * from #temp_call

   select [User].UserId user_id, count(distinct [CallStatistic].CallStatistic_Id) temp_call10sec
  into #temp_call10sec
  from #temp_CallStatistic [CallStatistic]
  inner join [#system_database_name#].[dbo].[User] on [CallStatistic].OperatorCrm_Phone=[User].PhoneNumber
  where [CallStatistic].DirectionId=1 AND [CallStatistic].StatusId=4 
  and [CallStatistic].TalkTime<=10
  group by [User].UserId


     IF OBJECT_ID('tempdb..#temp_count_appeals_questions') IS NOT NULL DROP TABLE #temp_count_appeals_questions;

  select [Appeals].[user_id], [Appeals].Id Appeals_Id, [Appeals].sipcallid, [Questions].Id Questions_Id, [Positions].PhoneNumber
  into #temp_count_appeals_questions
  from #temp_Appeals [Appeals]
  inner join #temp_positions_table [Positions] on [Appeals].[user_id]=[Positions].programuser_id
  --inner join #temp_CallStatistic tcs on [Appeals].sipcallid=tcs.SipCallId and [Positions].PhoneNumber=tcs.OperatorCrm_Phone --лишнеее все
  left join [dbo].[Questions] with (nolock) on [Appeals].Id=[Questions].appeal_id
  --where [Appeals].[receipt_source_id] in (1,8) and ISNULL([Appeals].sipcallid,N'0') NOT IN (N'0', N'{sipCallId}', N'', N'{ID}') and [Appeals].[registration_date] between @date_from and @date_to
  

  IF OBJECT_ID('tempdb..#temp_count_appeals_questions_res') IS NOT NULL DROP TABLE #temp_count_appeals_questions_res;

  select [user_id], count(distinct Appeals_Id) count_appeals, count(distinct Questions_Id) count_questions
  into #temp_count_appeals_questions_res
  from #temp_count_appeals_questions
  group by [user_id]

  IF OBJECT_ID('tempdb..#temp_count_consultations') IS NOT NULL DROP TABLE #temp_count_consultations;

 select distinct aq.user_id, [Consultations].Id Consultations_Id, [Consultations].consultation_type_id, tcs.TalkTime, aq.Questions_Id, aq.Appeals_Id--, aq.sipcallid
 into #temp_count_consultations
 from [dbo].[Consultations] with (nolock)
 inner join #temp_count_appeals_questions aq on [Consultations].appeal_id=aq.Appeals_Id
 inner join #temp_CallStatistic tcs on aq.sipcallid=tcs.SipCallId-- and aq.PhoneNumber=tcs.OperatorCrm_Phone -- связь по номеру под вопросом, но это правильно

 --select * from  #temp_count_consultations where user_id=N'41733a48-501a-4416-a53c-65409e87dfc0'

 IF OBJECT_ID('tempdb..#temp_count_cons_type') IS NOT NULL DROP TABLE #temp_count_cons_type;

 select user_id, [3] consult3, [2] consult2, [1] consult1, [4] consult4
 into #temp_count_cons_type
 from (select distinct user_id, Consultations_Id, consultation_type_id  from #temp_count_consultations) t
 pivot (count(Consultations_Id)
 for consultation_type_id in ([1], [2], [3], [4])
 ) s

 IF OBJECT_ID('tempdb..#temp_avg_time_cons') IS NOT NULL DROP TABLE #temp_avg_time_cons;

 select user_id, 
 case when len(avg(TalkTime)/60)=1 then N'0'+ltrim(avg(TalkTime)/60) else ltrim(avg(TalkTime)/60) end+N':'+
  case when len(avg(TalkTime)-(avg(TalkTime)/60)*60)=1 then N'0'+ltrim(avg(TalkTime)-(avg(TalkTime)/60)*60) else ltrim(avg(TalkTime)-(avg(TalkTime)/60)*60) end avg_cons_sec
 into #temp_avg_time_cons
 from #temp_count_consultations
 where Questions_Id is null
 group by user_id

 IF OBJECT_ID('tempdb..#temp_count_appeals') IS NOT NULL DROP TABLE #temp_count_appeals;

  select tcaq.user_id, count(distinct tcaq.Appeals_Id) count_appeal_call
  into #temp_count_appeals
  from #temp_count_appeals_questions tcaq
  inner join #temp_CallStatistic tcs on tcaq.sipcallid=tcs.SipCallId-- and tcaq.PhoneNumber=tcs.OperatorCrm_Phone убрать
  left join [dbo].[Consultations] c with (nolock) on tcaq.Appeals_Id=c.appeal_id
  where tcaq.Questions_Id is null and c.Id is null and tcs.TalkTime>10
  group by tcaq.user_id

  select tc.user_id Id, tc.user_name, tc.count_call, isnull(tc10.temp_call10sec, 0) count_10sec,
  isnull(taq.count_appeals, 0) count_appeals, isnull(taq.count_questions,0) count_questions,
  isnull(tcct.consult3,0) consult3, isnull(tcct.consult2,0) consult2, isnull(tcct.consult1,0) consult1, isnull(tcct.consult4,0) consult4,
  tatc.avg_cons_sec, isnull(tca.count_appeal_call,0) count_appeal_call, 
  convert(numeric(8,4),convert(float, tca.count_appeal_call)/convert(float, taq.count_appeals)) pro_appeal_call
  from #temp_call tc
  left join #temp_call10sec tc10 on tc.user_id=tc10.user_id
  left join #temp_count_appeals_questions_res taq on tc.user_id=taq.user_id
  left join #temp_count_cons_type tcct on tc.user_id=tcct.user_id
  left join #temp_avg_time_cons tatc on tc.user_id=tatc.user_id
  left join #temp_count_appeals tca on tc.user_id=tca.user_id

  --select * from #temp_count_appeals
  --- проверка
  --declare @date_from datetime='2020-06-30 21:00:00.000'
  -- ,@date_to datetime='2020-07-06 08:43:00.999'
  -- ,@organizations_Id nvarchar(200)--=N'1761, 1760';

 -- select * from #temp_count_consultations
 -- order by Appeals_Id

 -- declare @user_test nvarchar(128)=N'22a49077-6c39-40c2-9954-43bf859c2b05'--N'7bcdd0f7-3ed1-4570-b01b-dbd0daf70c1c';

 -- declare @phone_test nvarchar(100)=(select PhoneNumber from [#system_database_name#].[dbo].[User] where UserId=@user_test)

 -- select @user_test, @phone_test

 --select distinct aq.user_id, [Consultations].Id Consultations_Id, [Consultations].consultation_type_id, tcs.TalkTime, aq.Questions_Id, aq.Appeals_Id, aq.sipcallid
 ----into #temp_count_consultations
 --from [dbo].[Consultations]
 --inner join #temp_count_appeals_questions aq on [Consultations].appeal_id=aq.Appeals_Id
 --inner join #temp_CallStatistic tcs on aq.sipcallid=tcs.SipCallId-- and aq.PhoneNumber=tcs.OperatorCrm_Phone -- связь по номеру под вопросом, но это правильно
 --order by Appeals_Id
  --- все обращения юзера тестового по номеру
--707305792c60a99666a3c33c5113890a

--select * from #temp_CallStatistic where SipCallId=N'707305792c60a99666a3c33c5113890a'

  --select a.id, a.sipcallid, row_number() over (partition by a.sipcallid order by a.id) n --count(a.id), count(distinct a.id), count(a.sipcallid), count(distinct a.sipcallid)
  --from #temp_Appeals a
  --inner join [#system_database_name#].[dbo].[User] u on a.user_id=u.UserId
  --where u.PhoneNumber=@phone_test 
  --order by a.sipcallid
  --and 
  --(a.[receipt_source_id] in (1,8) and ISNULL(a.sipcallid,N'0') NOT IN (N'0', N'{sipCallId}', N'', N'{ID}') and convert(date, dateadd(hh, 0, a.[registration_date])) between @date_from and @date_to)

  -- все уникальные звонки даного юзера по номеру

  --select distinct c.CallStatistic_Id
  --from #temp_CallStatistic c
  --where c.OperatorCrm_Phone=@phone_test

  -- все по звонкам по даному изеру по номеру

  --select *
  --from #temp_CallStatistic c
  --where c.OperatorCrm_Phone=@phone_test

  --- обращения по даным


  --select a.id, a.sipcallid, a.user_id, p.PhoneNumber, tcs.CallStatistic_Id
  --from [dbo].[Appeals] a
  --inner join #temp_positions_table p on a.user_id=p.programuser_id
  --inner join #temp_CallStatistic tcs on p.PhoneNumber=tcs.OperatorCrm_Phone--a.sipcallid=tcs.SipCallId and aq.PhoneNumber=tcs.OperatorCrm_Phone
  --where a.user_id=@user_test and
  --(a.[receipt_source_id] in (1,8) and ISNULL(a.sipcallid,N'0') NOT IN (N'0', N'{sipCallId}', N'', N'{ID}') and convert(date, dateadd(hh, 0, a.[registration_date])) between @date_from and @date_to)


  


  --select *, N'одинаковый звонок, одинаковый sip, одинаковый номер, но разное время'
  --from #temp_CallStatistic
  --where CallStatistic_Id in (
  --select CallStatistic_Id
  --from #temp_CallStatistic
  --group by CallStatistic_Id, OperatorCrm_Phone
  --having count(distinct TalkTime)>1
  --)
  --order by CallStatistic_Id, SipCallId, OperatorCrm_Phone