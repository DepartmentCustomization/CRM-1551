


  /*0 2020-05-01 2020-06-01 46 сек
  declare @districts nvarchar(max)=N'0';
  declare @date_from datetime='2020-06-01 00:01'; 
  declare @date_to datetime='2020-08-01 23:59';
  declare @user_id nvarchar(128)=N'8cbd0469-56f1-474b-8ea6-904d783a0941';
  */
  --для количества действий начало

  if OBJECT_ID('tempdb..#temp_position_sector') is not null drop table #temp_position_sector

  select t.Id sector_id, p.name position_name, p.programuser_id
  into #temp_position_sector
  from [dbo].[Positions] p
  inner join [dbo].[PersonExecutorChoose] pec on p.Id=pec.position_id
  inner join [dbo].[PersonExecutorChooseObjects] peco on pec.Id=peco.person_executor_choose_id
  inner join [dbo].[Territories] t on peco.object_id=t.object_id
  where p.role_id=8

  --количество действий каждого юзера


  /*
  сектор_ид / инспектор_ид / количество действий по каждому сектору
  */

  if OBJECT_ID('tempdb..#temp_sector_act') is not null drop table #temp_sector_act

  select qin.territory_id, ps.position_name, ps.programuser_id, count(ah.Id) count_act
  into #temp_sector_act
  from [dbo].[QuestionsInTerritory] qin
  inner join [dbo].[Assignment_History] ah on qin.question_id=ah.question_id
  inner join #temp_position_sector ps on qin.territory_id=ps.sector_id and ah.Log_User=ps.programuser_id
  where ah.Log_Date between @date_from and @date_to
  group by qin.territory_id, ps.position_name, ps.programuser_id

  --для количества действий конец
  
  DECLARE @district_table TABLE (Id int);
  
  if OBJECT_ID('tempdb..#temp_district') is not null drop table #temp_district

  create table #temp_district(district_id int, name nvarchar(100) collate Ukrainian_CI_AS)

  if charindex(N'0',@districts, 1)=1
   or charindex(N',0,',@districts, 1)>0
   or charindex(N',0',@districts, 1)>0
  
	    begin
			insert into @district_table (Id)
			select Id from [dbo].[Districts]   

			insert into #temp_district (district_id, name)
			select distinct [Districts].Id, [Districts].name
			 from [dbo].[Territories] 
			inner join [dbo].[Objects] on [Territories].object_id=[Objects].Id
			inner join [dbo].[Districts] on [Objects].district_id=[Districts].Id
	    end

  else
		begin
			insert into @district_table (Id)

			select value*1 n
			from string_split((select @districts n), N',')

			insert into #temp_district (district_id, name)
			select distinct [Districts].Id, [Districts].name
			 from [dbo].[Territories] 
			inner join [dbo].[Objects] on [Territories].object_id=[Objects].Id
			inner join [dbo].[Districts] on [Objects].district_id=[Districts].Id
			inner join @district_table dt on [Districts].Id=dt.Id
		end

-- норм select * from @district_table

if OBJECT_ID('tempdb..#temp_ass_nevkom_886') is not null drop table #temp_ass_nevkom_886

  select [Assignment_History].question_id, count(distinct [Assignment_History].assignment_id) count_ass
  into #temp_ass_nevkom_886
  from [dbo].[QuestionsInTerritory]
  left join [dbo].[Assignment_History] on [Assignment_History].question_id=[QuestionsInTerritory].question_id
  where [Log_Date] between @date_from and @date_to
  and [Assignment_History].assignment_state_id=1/*Зареєстровано*/ and [Assignment_History].AssignmentResultsId=6 /*Повернуто виконавцю*/
  group by [Assignment_History].question_id


  if OBJECT_ID('tempdb..#temp_que_state3') is not null drop table #temp_que_state3 

  select [Question_History].[question_id], MIN([Question_History].[Log_Date]) [Log_Date]
  into #temp_que_state3
  from [dbo].[QuestionsInTerritory] with (nolock)
  inner join [dbo].[Question_History] with (nolock) on [QuestionsInTerritory].question_id=[Question_History].question_id
  where [Question_History].[question_state_id]=3
  and [Question_History].[registration_date] between @date_from and @date_to
  group by [Question_History].[question_id]

  CREATE INDEX i1 ON #temp_que_state3 ([question_id]);

  --перехід в стан "в роботі" по ходу - не нужно
  if OBJECT_ID('tempdb..#temp_que_state2') is not null drop table #temp_que_state2

  select [Question_History].[question_id], MIN([Question_History].[Log_Date]) [Log_Date]
  into #temp_que_state2
  from [dbo].[QuestionsInTerritory] with (nolock)
  inner join [dbo].[Question_History] with (nolock) on [QuestionsInTerritory].question_id=[Question_History].question_id
  where [question_state_id]=2 --в роботі
  and [registration_date] between @date_from and @date_to
  group by [Question_History].[question_id]

  CREATE INDEX i1 ON #temp_que_state2 ([question_id]);

--в "не в компетенції"
if OBJECT_ID('tempdb..#temp_ass_nevkom') is not null drop table #temp_ass_nevkom

select [assignment_id], min([Log_Date]) [Log_Date]
into #temp_ass_nevkom
  from [dbo].[QuestionsInTerritory] with (nolock)
  inner join [dbo].[Assignment_History] with (nolock) on [QuestionsInTerritory].question_id=[Assignment_History].question_id
  where [Assignment_History].[registration_date] between @date_from and @date_to
  and [assignment_state_id]=3 and /*На перевірці*/ [AssignmentResultsId]=3 /*Не в компетенції*/
  group by [assignment_id]

  CREATE INDEX i1 ON #temp_ass_nevkom ([assignment_id]);

  --для районов начало

  if OBJECT_ID('tempdb..#temp_count_que_down') is not null drop table #temp_count_que_down

  select [Questions].Id, [Objects].district_id, [Territories].Id territories_id, --[Territories].name,
  1 count_all,
  case when [Questions].question_state_id=1 --зареєстровано
  then 1 else 0 end count_registered,
  case when [Questions].question_state_id=2 --в роботі
  then 1 else 0 end count_in_work,
  case when [Questions].question_state_id=3 --на перевірці
  then 1 else 0 end count_on_inspection,
  case when [Assignments].assignment_state_id=5 and [Assignments].AssignmentResultsId=4 --Закрито Виконано
  then 1 else 0 end count_closed_performed,
  case when [Assignments].assignment_state_id=5 and [Assignments].AssignmentResultsId=7 --Закрито роз*яснено
  then 1 else 0 end count_closed_clear,
  case when [Questions].question_state_id=4 --на доопрацювання
  then 1 else 0 end count_for_completion,
  case when [Questions].question_state_id in (1,2) and [Questions].control_date<getutcdate() --Простроено 
  then 1 else 0 end count_built,
  case when [Questions].question_state_id =3 and temp_que_state3.Log_Date>[Questions].control_date--Не вчасно опрацьовано 
  then 1 else 0 end count_not_processed_in_time,

  --[Questions].registration_date,
  --temp_que_state2.[Log_Date] que_state2_log_date,

  --temp_ass_nevkom.[Log_Date] ass_nevkom_log_date,

  case 
		when temp_que_state2.[Log_Date] is not null and temp_ass_nevkom.[Log_Date] is null then DATEDIFF(mi, [Questions].registration_date, temp_que_state2.[Log_Date])
		when temp_que_state2.[Log_Date] is null and temp_ass_nevkom.[Log_Date] is not null then DATEDIFF(mi, [Questions].registration_date, temp_ass_nevkom.[Log_Date])
		when temp_que_state2.[Log_Date] is not null and temp_ass_nevkom.[Log_Date] is not null and temp_que_state2.[Log_Date]>=temp_ass_nevkom.[Log_Date]
			then DATEDIFF(mi, [Questions].registration_date, temp_que_state2.[Log_Date])
				else DATEDIFF(mi, [Questions].registration_date, temp_ass_nevkom.[Log_Date]) end count_days_speed,

  --case when [Questions].question_state_id=5 --закрито
  --then 1 else 0 end count_close
  temp_ass_nevkom_886.count_ass nevkom_886_count_ass
  into #temp_count_que_down
  from 
  --[dbo].[Positions]
  --inner join [dbo].[PersonExecutorChoose] on [PersonExecutorChoose].position_id=[Positions].id
  --inner join [dbo].[PersonExecutorChooseObjects] on [PersonExecutorChooseObjects].person_executor_choose_id=[PersonExecutorChoose].Id
  --inner join 
  [dbo].[Territories] --on [PersonExecutorChooseObjects].object_id=[Territories].object_id
  inner join [dbo].[Objects] with (nolock) on [Territories].object_id=[Objects].Id
  inner join @district_table d on [Objects].district_id=d.Id
  inner join [dbo].[QuestionsInTerritory] with (nolock) on [Territories].Id=[QuestionsInTerritory].territory_id
  inner join [dbo].[Questions] with (nolock) ON [QuestionsInTerritory].question_id=[Questions].Id
  left join [dbo].[Assignments] with (nolock) on [Assignments].Id=[Questions].last_assignment_for_execution_id--[Questions].Id=question_id and [Assignments].main_executor='true'
  --left join #temp_ass_nevkom temp_ass_nevkom on 
  left join #temp_que_state3 temp_que_state3 on [Questions].Id=temp_que_state3.question_id
  left join #temp_que_state2 temp_que_state2 on [Questions].Id=temp_que_state2.question_id
  left join #temp_ass_nevkom temp_ass_nevkom on [Assignments].Id=temp_ass_nevkom.assignment_id
  left join #temp_ass_nevkom_886 temp_ass_nevkom_886 on [Questions].Id=temp_ass_nevkom_886.question_id
  where [Questions].[registration_date] between @date_from and @date_to
  --для районов конец

  --select * from #temp_count_que_down

  if OBJECT_ID('tempdb..#temp_count_que') is not null drop table #temp_count_que

  select territories_id, --1
  SUM(count_all) count_all, --2
  SUM(count_registered) count_registered, --3
  SUM(count_in_work) count_in_work, --4
  SUM(count_on_inspection) count_on_inspection,
  SUM(count_closed_performed) count_closed_performed,
  SUM(count_closed_clear) count_closed_clear,
  SUM(count_for_completion) count_for_completion,
  SUM(count_built) count_built,
  SUM(count_not_processed_in_time) count_not_processed_in_time,
  --SUM(count_close) count_close,
  --SUM(DATEDIFF(day, registration_date, que_state2_log_date)) count_days_speed1, --11
  --SUM(DATEDIFF(DAY, registration_date, ass_nevkom_log_date)) count_days_speed2 --11

  --count_days_speed если 1 случая нету, то второй, если второго нету, то 1, если есть оба, то, что раньше
  --делить на то, что попало в данный расчет
  AVG(count_days_speed) count_days_speed,
  SUM(nevkom_886_count_ass) count_nevkom_886_ass

  into #temp_count_que
  from #temp_count_que_down t
  group by territories_id

  --тут стоп
  if OBJECT_ID('tempdb..#temp_count_all') is not null drop table #temp_count_all

  select s.district_id, s.Id, s.name territories_name,
  count_all,
  count_registered,
  count_in_work,
  count_on_inspection,
  count_closed_performed,
  count_closed_clear,
  count_for_completion,
  count_built,
  count_not_processed_in_time,
  convert(numeric(8,2),count_days_speed/60.00) speed_of_employment,
  --count_days_speed1, count_days_speed2,

  --начало
  --case when count_registered=0 then null 
  --else convert(numeric(8,2),convert(float, (case 
  ----when count_days_speed1 is not null and count_days_speed2 is not null then count_days_speed1+count_days_speed2

  --when count_days_speed1 is null then count_days_speed2 --count_days_speed1+count_days_speed2
  --when count_days_speed2 is null then count_days_speed1 end

  --))/convert(float,count_registered)) end speed_of_employment, --11
  ---КОНЕЦ

  case when count_on_inspection+count_closed_performed+count_closed_clear+count_for_completion=0 then null
  else convert(numeric(8,2),(1.00-(convert(float,count_not_processed_in_time)/convert(float,(count_on_inspection+count_closed_performed+count_closed_clear+count_for_completion))))*100.00) end timely_processed, --12

  case when count_closed_performed+count_closed_clear+count_for_completion=0 then null 
  else convert(numeric(8,2),(convert(float,count_closed_performed)/convert(float,(count_closed_performed+count_closed_clear+count_for_completion)))*100.00) end implementation, --13

  case when count_closed_performed+count_closed_clear+count_for_completion=0 then null
  else convert(numeric(8,2),(1.00-(convert(float,count_for_completion)/convert(float,(count_closed_performed+count_closed_clear+count_for_completion))))*100.00) end reliability --14
  ,count_nevkom_886_ass count_not_competence
  --, case when count_all>1 then 'true' else 'false' end in_color
  into #temp_count_all
  from 
  (select [Objects].district_id, [Territories].Id, [Territories].name+ISNULL(N' ('+[Positions].name+N')',N'') name
  from [dbo].[Territories] with (nolock)
  inner join [dbo].[Objects] with (nolock) on [Territories].object_id=[Objects].Id
  inner join @district_table d on [Objects].district_id=d.Id
  left join [dbo].[PersonExecutorChooseObjects] with (nolock) ON [PersonExecutorChooseObjects].object_id=[Territories].object_id
  left join [dbo].[PersonExecutorChoose] with (nolock) ON [PersonExecutorChooseObjects].person_executor_choose_id=[PersonExecutorChoose].Id
  left join [dbo].[Positions] with (nolock) ON [PersonExecutorChoose].position_id=[Positions].id) s
  left join #temp_count_que temp_count_que ON s.id=temp_count_que.territories_id

  if OBJECT_ID('tempdb..#temp_count_all_all') is not null drop table #temp_count_all_all

  select district_id, Id, territories_name,
  count_all,
  count_registered,
  count_in_work,
  count_on_inspection,
  count_closed_performed,
  count_closed_clear,
  count_for_completion,
  count_built,
  count_not_processed_in_time,
  speed_of_employment,
  timely_processed, --12
  implementation, --13
  reliability, --14
  count_not_competence,
  0 in_color
  into #temp_count_all_all
  from #temp_count_all

  union all

  select #temp_district.district_id, #temp_district.district_id*(-1) Id, #temp_district.name,
  SUM(count_all) count_all, --2
  SUM(count_registered) count_registered, --3
  SUM(count_in_work) count_in_work, --4
  SUM(count_on_inspection) count_on_inspection,
  SUM(count_closed_performed) count_closed_performed,
  SUM(count_closed_clear) count_closed_clear,
  SUM(count_for_completion) count_for_completion,
  SUM(count_built) count_built,
  SUM(count_not_processed_in_time) count_not_processed_in_time,
  --SUM(count_close) count_close,
  --SUM(DATEDIFF(day, registration_date, que_state2_log_date)) count_days_speed1, --11
  --SUM(DATEDIFF(DAY, registration_date, ass_nevkom_log_date)) count_days_speed2 --11

  --count_days_speed если 1 случая нету, то второй, если второго нету, то 1, если есть оба, то, что раньше
  --делить на то, что попало в данный расчет
  --AVG(count_days_speed) count_days_speed,
  --
  --convert(numeric(8,2),count_days_speed/60.00) speed_of_employment,
  convert(numeric(8,2),AVG(count_days_speed)/60.00) speed_of_employment,
  case when sum(count_on_inspection)+sum(count_closed_performed)+sum(count_closed_clear)+sum(count_for_completion)=0 then null
  else convert(numeric(8,2),(1.00-(convert(float,sum(count_not_processed_in_time))/convert(float,(sum(count_on_inspection)+sum(count_closed_performed)+sum(count_closed_clear)+sum(count_for_completion)))))*100.00) 
  end timely_processed, --12

  case when sum(count_closed_performed)+sum(count_closed_clear)+sum(count_for_completion)=0 then null 
  else convert(numeric(8,2),(convert(float,sum(count_closed_performed))/convert(float,(sum(count_closed_performed)+sum(count_closed_clear)+sum(count_for_completion))))*100.00) 
  end implementation, --13

  case when sum(count_closed_performed)+sum(count_closed_clear)+sum(count_for_completion)=0 then null
  else convert(numeric(8,2),(1.00-(convert(float,sum(count_for_completion))/convert(float,(sum(count_closed_performed)+sum(count_closed_clear)+sum(count_for_completion)))))*100.00) 
  end reliability, --14
  SUM(nevkom_886_count_ass) count_not_competence,
  1 in_color
  from 
  #temp_district left join
  #temp_count_que_down on #temp_district.district_id=#temp_count_que_down.district_id
  --inner join [dbo].[Districts] on #temp_count_que_down.district_id=[Districts].Id
  group by #temp_district.district_id, #temp_district.name

  --select * from #temp_count_que_down

  select --district_id, 
  Id, territories_name,
  isnull(count_all, 0) count_all,
  isnull(count_registered, 0) count_registered,
  isnull(count_in_work, 0) count_in_work,
  isnull(count_on_inspection, 0) count_on_inspection,
  isnull(count_closed_performed, 0) count_closed_performed, 
  isnull(count_closed_clear, 0) count_closed_clear,
  isnull(count_for_completion, 0) count_for_completion,
  isnull(count_built, 0) count_built,
  isnull(count_not_processed_in_time, 0) count_not_processed_in_time,
  speed_of_employment,
  timely_processed, --12
  implementation, --13
  reliability, --14
  isnull(count_not_competence,0) count_not_competence,
  in_color,
  --Id count_act
  sa.count_act
  from #temp_count_all_all tc
  left join #temp_sector_act sa on tc.id=sa.territory_id
  order by district_id, Id

  --select * from #temp_count_all_all