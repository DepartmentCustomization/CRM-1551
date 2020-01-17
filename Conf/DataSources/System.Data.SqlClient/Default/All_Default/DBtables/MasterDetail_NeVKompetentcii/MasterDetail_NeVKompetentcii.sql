
declare @organization_id int --=2348;
declare @user_id nvarchar(300)--=N'02ece542-2d75-479d-adad-fd333d09604d';

declare @Organization table(Id int);



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
select Id from @IdT;



  select [Assignments].Id,
case when [ReceiptSources].name=N'УГЛ' then N'УГЛ' 
when [ReceiptSources].name=N'Сайт/моб. додаток' then N'Електронні джерела надходження'
else N'Інші доручення'
end navigation,
[Questions].registration_number, [QuestionTypes].name QuestionType, [Organizations].name pidlegliy, 
[Applicants].Id zayavnikId, [Questions].Id QuestionId,
[Assignments].Id as Id2
 , [StreetTypes2].shortname+N' '+Streets2.name+N', '+[Buildings2].name zayavnyk_adress, [Questions].question_content zayavnyk_zmist,
 [AssignmentConsiderations].short_answer comment
  from [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] inner join
  (select assignment_id, max(Id) mid
  from [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  group by assignment_id) ac on [AssignmentConsiderations].Id=ac.mid
  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentConsiderations].assignment_result_id=[AssignmentResults].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentConsiderations].assignment_resolution_id=[AssignmentResolutions].Id
--   inner join [CRM_1551_Analitics].[dbo].[Assignments] on [AssignmentConsiderations].assignment_id=[Assignments].Id
  inner join [CRM_1551_Analitics].[dbo].[Assignments] on [AssignmentConsiderations].Id = Assignments.current_assignment_consideration_id
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id 
  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
  left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
  left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
  left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
  left join [CRM_1551_Analitics].[dbo].[LiveAddress] on [LiveAddress].applicant_id=[Applicants].Id
  left join [CRM_1551_Analitics].[dbo].[Buildings] [Buildings2] on [LiveAddress].building_id=[Buildings2].Id
  left join [CRM_1551_Analitics].[dbo].[Streets] [Streets2] on [Buildings2].street_id=[Streets2].Id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] [StreetTypes2] on [Streets2].street_type_id=[StreetTypes2].Id
  where 
  
  [AssignmentTypes].Id<>2 and [AssignmentStates].name<>N'Закрито' and [AssignmentResults].name=N'Не в компетенції'
  and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію')

  and [AssignmentConsiderations].turn_organization_id=@organization_id --and executor_organization_id in (select Id from @Organization)
  


-- -- declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
-- -- declare @organization_id int =289;
-- -- declare @navigation nvarchar(400)=N'Інші доручення';

-- declare @NavigationTable table(Id nvarchar(400));

-- if @navigation=N'Усі'
-- 	begin
-- 		insert into @NavigationTable (Id)
-- 		select N'Інші доручення' n union all select N'УГЛ' n union all
-- 		select N'Скарга' n union all select N'Сайт' n union all select N'Пріоритетне'
-- 	end 
-- else 
-- 	begin
-- 		insert into @NavigationTable (Id)
-- 		select @navigation
-- 	end;
-- /*
-- insert into @Organization (Id)

-- --select 8 id;

-- select Id
--   from [CRM_1551_Analitics].[dbo].[Organizations]
--   where Id in (select organization_id
--   from [CRM_1551_Analitics].[dbo].[Workers]
--   where worker_user_id=@user_id) or organization_id in (select organization_id
--   from [CRM_1551_Analitics].[dbo].[Workers]
--   where worker_user_id=@user_id);
--   */

  
-- -- declare @organization_id int =null;
-- --declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';

-- declare @Organization table(Id int);

-- --select 8 id;


-- -- ЕСЛИ НУЖНО ВЫБИРАТЬ ЮЗЕРА
-- --declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
-- -- МОЖНО ПРОСТО ИД ОРГАНИЗАЦИИ ВЛЕПИТЬ

-- --if @organization_id is null


-- declare @OrganizationId int = 
-- case 
-- when @organization_id is not null
-- then @organization_id
-- else (select Id
--   from [CRM_1551_Analitics].[dbo].[Organizations]
--   where Id in (select organization_id
--   from [CRM_1551_Analitics].[dbo].[Workers]
--   where worker_user_id=@user_id))
--  end


-- declare @IdT table (Id int);

-- -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
-- insert into @IdT(Id)
-- select Id from [CRM_1551_Analitics].[dbo].[Organizations] 
-- where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

-- --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
-- while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
-- where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT)) q)!=0
-- begin

-- insert into @IdT
-- select Id from [CRM_1551_Analitics].[dbo].[Organizations]
-- where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
-- and Id not in (select Id from @IdT)
-- end 

-- insert into @Organization (Id)
-- select Id from @IdT;
  
--  with

-- main as
-- (
-- select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
-- [Applicants].full_name zayavnyk, N'Вул.'+Streets.name+N'буд.'+[Buildings].name adress, [Questions].registration_number,
-- [QuestionTypes].name QuestionType,
-- case when [ReceiptSources].name=N'УГЛ' then N'УГЛ' 
-- when [ReceiptSources].name=N'Сайт/моб. додаток' then N'Сайт'
-- else N'Інші доручення'
-- end navigation,

-- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'Зареєстровано' then 1 else 0 end nadiyshlo,
-- --case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'Закрито' and [AssignmentResults].name=N'Не в компетенції' then 1 else 0 end neVKompetentsii,
-- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 

-- dateadd(HH, [execution_term], [Assignments].registration_date)<getdate() 

-- then 1 else 0 end prostrocheni,


-- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 

-- --case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 
-- datediff(HH, [Assignments].registration_date, getdate())>[Attention_term_hours]
-- and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term]

-- --dateadd(mi, datediff(MINUTE, [Assignments].registration_date, [AssignmentRevisions].control_date)/(-4) ,[AssignmentRevisions].control_date)>=getdate() and 
-- --[AssignmentRevisions].control_date<getdate() 

-- then 1 else 0 end uvaga,

-- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 
-- datediff(HH, [Assignments].registration_date, getdate())<=[Attention_term_hours]
-- --and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term]

-- --dateadd(mi, datediff(MINUTE, [Assignments].registration_date, [AssignmentRevisions].control_date)/(-4)*3 ,[AssignmentRevisions].control_date)<=getdate()  
--  then 1 else 0 end vroboti,

--  case when [AssignmentTypes].Id=2 then 1 else 0 end dovidima,

--  case when [AssignmentStates].name=N'Не виконано' and [AssignmentResults].name=N'На доопрацювання' then 1 else 0 end naDoopratsiyvanni,
--  case when [AssignmentStates].name=N'Не виконано' and [AssignmentResults].name=N'Не можливо виконати в даний період' then 1 else 0 end neVykonNeMozhl,
--  null NotUse,

--  [Applicants].Id zayavnikId, [Questions].Id QuestionId


-- from 
-- [CRM_1551_Analitics].[dbo].[Assignments] left join 
-- [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
-- left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
-- left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
-- left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
-- --left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
-- left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
-- left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
-- left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].[object_id]=[Objects].Id
-- left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
-- left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
-- left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
-- --left join [CRM_1551_Analitics].[dbo].[AssignmentRevisions] on [AssignmentResolutions].Id=[AssignmentRevisions].assignment_resolution_id
-- where [Assignments].[executor_organization_id]=@organization_id

-- union all


-- select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName, --[Questions].registration_number,
-- [Applicants].full_name zayavnyk, N'Вул.'+Streets.name+N'буд.'+[Buildings].name adress, [Questions].registration_number,
-- [QuestionTypes].name QuestionType,
-- case when [QuestionTypes].emergency=N'true' then N'Пріоритетне'
-- when [QuestionTypes].parent_organization_is=N'true' then N'Скарга'
-- end navigation,

-- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'Зареєстровано' then 1 else 0 end nadiyshlo,
-- --case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'Закрито' and [AssignmentResults].name=N'Не в компетенції' then 1 else 0 end neVKompetentsii,
-- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and dateadd(HH, [execution_term], [Assignments].registration_date)<getdate() then 1 else 0 end prostrocheni,
-- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 
-- datediff(HH, [Assignments].registration_date, getdate())>[Attention_term_hours]
-- and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term] then 1 else 0 end uvaga,

-- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 
-- datediff(HH, [Assignments].registration_date, getdate())<=[Attention_term_hours]  
--  then 1 else 0 end vroboti,

--  case when [AssignmentTypes].Id=2 then 1 else 0 end dovidima,

--  case when [AssignmentStates].name=N'Не виконано' and [AssignmentResults].name=N'На доопрацювання' then 1 else 0 end naDoopratsiyvanni,
--  case when [AssignmentStates].name=N'Не виконано' and [AssignmentResults].name=N'Не можливо виконати в даний період' then 1 else 0 end neVykonNeMozhl,
--  null NotUse, [Applicants].Id zayavnikId, [Questions].Id QuestionId



-- from 
-- [CRM_1551_Analitics].[dbo].[Assignments] left join 
-- [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
-- left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
-- left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
-- left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
-- --left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
-- left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
-- left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
-- --left join [CRM_1551_Analitics].[dbo].[AssignmentRevisions] on [AssignmentResolutions].Id=[AssignmentRevisions].assignment_resolution_id
-- left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
-- left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].[object_id]=[Objects].Id
-- left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
-- left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
-- left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id

-- where case when [QuestionTypes].emergency=N'true' then N'Пріоритетне'
-- when [QuestionTypes].parent_organization_is=N'true' then N'Скарга'
-- end is not null
-- and [Assignments].[executor_organization_id]=@organization_id),

-- nav as 
-- (
-- select 1 Id, N'УГЛ' name union all select 2 Id, N'Сайт' name union all select 3	Id, N'Пріоритетне' name union all select 4 Id, N'Інші доручення' name union all select 5 Id, N'Скарга' name 
-- ),

-- nevkomp as
-- (

-- select [Assignments].Id, 
-- case when [ReceiptSources].name=N'УГЛ' then N'УГЛ' 
-- when [ReceiptSources].name=N'Сайт/моб. додаток' then N'Електронні джерела надходження'
-- else N'Інші доручення'
-- end navigation

--   from [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] inner join
--   (select assignment_id, max(Id) mid
--   from [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
--   group by assignment_id) ac on [AssignmentConsiderations].Id=ac.mid
--   left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [AssignmentConsiderations].assignment_result_id=[AssignmentResults].Id
--   left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [AssignmentConsiderations].assignment_resolution_id=[AssignmentResolutions].Id
--   inner join [CRM_1551_Analitics].[dbo].[Assignments] on [AssignmentConsiderations].assignment_id=[Assignments].Id
--   left join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
--   left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
--   left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id 
--   left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
--   left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
--   where 
  
--   [AssignmentTypes].Id<>2 and [AssignmentStates].name<>N'Закрито' and [AssignmentResults].name=N'Не в компетенції'
--   and [AssignmentResolutions].name in (N'Повернуто в 1551', N'Повернуто в батьківську організацію')

--   and [AssignmentConsiderations].turn_organization_id is not null and executor_organization_id in (select Id from @Organization)

-- --select [Assignments].Id,
-- --select [Assignments].Id, 
-- --case when [ReceiptSources].name=N'УГЛ' then N'УГЛ' 
-- --when [ReceiptSources].name=N'Сайт/моб. додаток' then N'Електронні джерела надходження'
-- --else N'Інші доручення'
-- --end navigation

-- --  from [CRM_1551_Analitics].[dbo].[Assignments]
-- --  left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
-- --  left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
-- --  left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].AssignmentResultsId=[AssignmentResults].Id
-- --  left join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
-- --  left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
-- --  left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id 
-- --  where [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'Закрито' and [AssignmentResults].name=N'Не в компетенції'
-- --  and executor_organization_id in (select Id from @Organization)
-- ),

-- table2 as
-- (
-- select nav.Id, nav.name navigation, isnull(sum(nadiyshlo),0) nadiyshlo, isnull(count(nevkomp.Id),0) neVKompetentsii, isnull(sum(prostrocheni),0) prostrocheni, isnull(sum(uvaga),0) uvaga,
-- isnull(sum(vroboti),0) vroboti, isnull(sum(dovidima),0) dovidoma, isnull(sum(naDoopratsiyvanni),0) naDoopratsiyvanni, isnull(sum(neVykonNeMozhl),0) neVykonNeMozhl
-- from nav left join main on nav.name=main.navigation
-- left join nevkomp on nav.name=nevkomp.navigation
-- group by nav.Id, nav.name--, main.OrganizationsId, main.OrganizationsName
-- )

-- select main.Id, main.navigation, main.registration_number, main.QuestionType, main.OrganizationsName pidlegliy, main.zayavnikId, main.QuestionId--zayavnyk, adress, null vykonavets
--  from main inner join nevkomp on main.Id=nevkomp.Id
--   where --navigation, registration_number, from main
--  main.navigation in (select Id from @NavigationTable)
-- --select nav.name from nav left join main on nav.name=main.navigation


-- --declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
-- --declare @organization_id int =6704;
-- --declare @navigation nvarchar(400)=N'Усі';

-- -- declare @NavigationTable table(Id nvarchar(400));

-- -- if @navigation=N'Усі'
-- -- 	begin
-- -- 		insert into @NavigationTable (Id)
-- -- 		select N'Інші доручення' n union all select N'УГЛ' n union all
-- -- 		select N'Скарга' n union all select N'Сайт' n union all select N'Пріоритетне'
-- -- 	end 
-- -- else 
-- -- 	begin
-- -- 		insert into @NavigationTable (Id)
-- -- 		select @navigation
-- -- 	end;
-- -- /*
-- -- insert into @Organization (Id)

-- -- --select 8 id;

-- -- select Id
-- --   from [CRM_1551_Analitics].[dbo].[Organizations]
-- --   where Id in (select organization_id
-- --   from [CRM_1551_Analitics].[dbo].[Workers]
-- --   where worker_user_id=@user_id) or organization_id in (select organization_id
-- --   from [CRM_1551_Analitics].[dbo].[Workers]
-- --   where worker_user_id=@user_id);
-- --   */

  
-- -- -- declare @organization_id int =null;
-- -- --declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';

-- -- declare @Organization table(Id int);

-- -- --select 8 id;


-- -- -- ЕСЛИ НУЖНО ВЫБИРАТЬ ЮЗЕРА
-- -- --declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';
-- -- -- МОЖНО ПРОСТО ИД ОРГАНИЗАЦИИ ВЛЕПИТЬ

-- -- --if @organization_id is null


-- -- declare @OrganizationId int = 
-- -- case 
-- -- when @organization_id is not null
-- -- then @organization_id
-- -- else (select Id
-- --   from [CRM_1551_Analitics].[dbo].[Organizations]
-- --   where Id in (select organization_id
-- --   from [CRM_1551_Analitics].[dbo].[Workers]
-- --   where worker_user_id=@user_id))
-- --  end


-- -- declare @IdT table (Id int);

-- -- -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
-- -- insert into @IdT(Id)
-- -- select Id from [CRM_1551_Analitics].[dbo].[Organizations] 
-- -- where (Id=@OrganizationId or [parent_organization_id]=@OrganizationId) and Id not in (select Id from @IdT)

-- -- --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
-- -- while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[Organizations]
-- -- where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
-- -- and Id not in (select Id from @IdT)) q)!=0
-- -- begin

-- -- insert into @IdT
-- -- select Id from [CRM_1551_Analitics].[dbo].[Organizations]
-- -- where [parent_organization_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
-- -- and Id not in (select Id from @IdT)
-- -- end 

-- -- insert into @Organization (Id)
-- -- select Id from @IdT;
  
-- --  with

-- -- main as
-- -- (
-- -- select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName,
-- -- [Applicants].full_name zayavnyk, N'Вул.'+Streets.name+N'буд.'+[Buildings].name adress, [Questions].registration_number,
-- -- [QuestionTypes].name QuestionType,
-- -- case when [ReceiptSources].name=N'УГЛ' then N'УГЛ' 
-- -- when [ReceiptSources].name=N'Сайт/моб. додаток' then N'Сайт'
-- -- else N'Інші доручення'
-- -- end navigation,

-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'Зареєстровано' then 1 else 0 end nadiyshlo,
-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'Закрито' and [AssignmentResults].name=N'Не в компетенції' then 1 else 0 end neVKompetentsii,
-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 

-- -- dateadd(HH, [execution_term], [Assignments].registration_date)<getdate() 

-- -- then 1 else 0 end prostrocheni,


-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 

-- -- --case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 
-- -- datediff(HH, [Assignments].registration_date, getdate())>[Attention_term_hours]
-- -- and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term]

-- -- --dateadd(mi, datediff(MINUTE, [Assignments].registration_date, [AssignmentRevisions].control_date)/(-4) ,[AssignmentRevisions].control_date)>=getdate() and 
-- -- --[AssignmentRevisions].control_date<getdate() 

-- -- then 1 else 0 end uvaga,

-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 
-- -- datediff(HH, [Assignments].registration_date, getdate())<=[Attention_term_hours]
-- -- --and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term]

-- -- --dateadd(mi, datediff(MINUTE, [Assignments].registration_date, [AssignmentRevisions].control_date)/(-4)*3 ,[AssignmentRevisions].control_date)<=getdate()  
-- --  then 1 else 0 end vroboti,

-- --  case when [AssignmentTypes].Id=2 then 1 else 0 end dovidima,

-- --  case when [AssignmentStates].name=N'Не виконано' and [AssignmentResults].name=N'На доопрацювання' then 1 else 0 end naDoopratsiyvanni,
-- --  case when [AssignmentStates].name=N'Не виконано' and [AssignmentResults].name=N'Не можливо виконати в даний період' then 1 else 0 end neVykonNeMozhl,
-- --  null NotUse,

-- --  [Applicants].Id zayavnikId, [Questions].Id QuestionId


-- -- from 
-- -- [CRM_1551_Analitics].[dbo].[Assignments] left join 
-- -- [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
-- -- left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
-- -- left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
-- -- left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
-- -- left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
-- -- --left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
-- -- left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
-- -- left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].[object_id]=[Objects].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id
-- -- --left join [CRM_1551_Analitics].[dbo].[AssignmentRevisions] on [AssignmentResolutions].Id=[AssignmentRevisions].assignment_resolution_id
-- -- where [Assignments].[executor_organization_id]=@organization_id

-- -- union all


-- -- select [Assignments].Id, [Organizations].Id OrganizationsId, [Organizations].name OrganizationsName, --[Questions].registration_number,
-- -- [Applicants].full_name zayavnyk, N'Вул.'+Streets.name+N'буд.'+[Buildings].name adress, [Questions].registration_number,
-- -- [QuestionTypes].name QuestionType,
-- -- case when [QuestionTypes].emergency=N'true' then N'Пріоритетне'
-- -- when [QuestionTypes].parent_organization_is=N'true' then N'Скарга'
-- -- end navigation,

-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'Зареєстровано' then 1 else 0 end nadiyshlo,
-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'Закрито' and [AssignmentResults].name=N'Не в компетенції' then 1 else 0 end neVKompetentsii,
-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and dateadd(HH, [execution_term], [Assignments].registration_date)<getdate() then 1 else 0 end prostrocheni,
-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 
-- -- datediff(HH, [Assignments].registration_date, getdate())>[Attention_term_hours]
-- -- and datediff(HH, [Assignments].registration_date, getdate())<=[execution_term] then 1 else 0 end uvaga,

-- -- case when [AssignmentTypes].Id<>2 and [AssignmentStates].name=N'В роботі' and 
-- -- datediff(HH, [Assignments].registration_date, getdate())<=[Attention_term_hours]  
-- --  then 1 else 0 end vroboti,

-- --  case when [AssignmentTypes].Id=2 then 1 else 0 end dovidima,

-- --  case when [AssignmentStates].name=N'Не виконано' and [AssignmentResults].name=N'На доопрацювання' then 1 else 0 end naDoopratsiyvanni,
-- --  case when [AssignmentStates].name=N'Не виконано' and [AssignmentResults].name=N'Не можливо виконати в даний період' then 1 else 0 end neVykonNeMozhl,
-- --  null NotUse, [Applicants].Id zayavnikId, [Questions].Id QuestionId



-- -- from 
-- -- [CRM_1551_Analitics].[dbo].[Assignments] left join 
-- -- [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
-- -- left join [CRM_1551_Analitics].[dbo].[ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
-- -- left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
-- -- left join [CRM_1551_Analitics].[dbo].[AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
-- -- left join [CRM_1551_Analitics].[dbo].[AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
-- -- --left join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
-- -- left join [CRM_1551_Analitics].[dbo].[AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
-- -- left join [CRM_1551_Analitics].[dbo].[AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
-- -- --left join [CRM_1551_Analitics].[dbo].[AssignmentRevisions] on [AssignmentResolutions].Id=[AssignmentRevisions].assignment_resolution_id
-- -- left join [CRM_1551_Analitics].[dbo].[Organizations] on [Assignments].executor_organization_id=[Organizations].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Objects] on [Questions].[object_id]=[Objects].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Buildings] on [Objects].builbing_id=[Buildings].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
-- -- left join [CRM_1551_Analitics].[dbo].[Applicants] on [Appeals].applicant_id=[Applicants].Id

-- -- where case when [QuestionTypes].emergency=N'true' then N'Пріоритетне'
-- -- when [QuestionTypes].parent_organization_is=N'true' then N'Скарга'
-- -- end is not null
-- -- and [Assignments].[executor_organization_id]=@organization_id),

-- -- nav as 
-- -- (
-- -- select 1 Id, N'УГЛ' name union all select 2 Id, N'Сайт' name union all select 3	Id, N'Пріоритетне' name union all select 4 Id, N'Інші доручення' name union all select 5 Id, N'Скарга' name 
-- -- ),

-- -- table2 as
-- -- (
-- -- select nav.Id, nav.name navigation, sum(nadiyshlo) nadiyshlo, sum(neVKompetentsii) neVKompetentsii, sum(prostrocheni) prostrocheni, sum(uvaga) uvaga,
-- -- sum(vroboti) vroboti, sum(dovidima) dovidoma, sum(naDoopratsiyvanni) naDoopratsiyvanni, sum(neVykonNeMozhl) neVykonNeMozhl
-- -- from nav left join main on nav.name=main.navigation
-- -- group by nav.Id, nav.name
-- -- )

-- -- select Id, navigation, registration_number, QuestionType, OrganizationsName pidlegliy, zayavnikId, QuestionId--zayavnyk, adress, null vykonavets
-- --  from main where neVKompetentsii=1 --navigation, registration_number, from main
-- -- and navigation in (select Id from @NavigationTable)
-- -- --select nav.name from nav left join main on nav.name=main.navigation