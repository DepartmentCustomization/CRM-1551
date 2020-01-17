  --declare @RegistrationDateFrom date='2018-08-01';
  --declare @RegistrationDateTo date='2019-10-01';
  --declare @OrganizationExecId int;
  --declare @OrganizationExecGroupId int;
  --declare @ReceiptSourcesId int = 1;
  --declare @QuestionGroupId int;
 
if object_id('tempdb..#temp_OUT') is not null drop table #temp_OUT
create table #temp_OUT(
OrgId int
)

if @OrganizationExecId is not null 
begin
	
		;WITH  OrganizationsH (ParentId, Id, [Name], level, Label, Label2) AS
		  (
		      SELECT parent_organization_id as ParentId, Id, short_name  as [Name], 0, CAST(rtrim(Id)+ '/' AS NVARCHAR(MAX)) As Label, CAST((short_name)+ N' / ' AS NVARCHAR(MAX)) As Label2
		      FROM [dbo].[Organizations]
		      WHERE Id=@OrganizationExecId
		      UNION ALL
		    SELECT o.parent_organization_id as ParentId, o.Id, o.short_name as [Name], level + 1,  CAST(rtrim(h.Label)  + rtrim(o.Id) + '/' AS NVARCHAR(MAX)) As Label,  CAST((h.Label2)  + (o.short_name) + ' / ' AS NVARCHAR(MAX)) As Label2
		      FROM [dbo].[Organizations]  o 
		    JOIN OrganizationsH h ON o.parent_organization_id = h.Id
		  )

	insert into #temp_OUT (OrgId)
	SELECT Id
	FROM OrganizationsH
end

if @OrganizationExecGroupId is not null 
begin
	insert into #temp_OUT (OrgId)
	select organization_id from [dbo].[OGroupIncludeOrganizations] where organization_group_id = @OrganizationExecGroupId
end


if @OrganizationExecGroupId is not null and @OrganizationExecId is not null 
begin
	delete from #temp_OUT
end

if @OrganizationExecGroupId is null and @OrganizationExecId is null 
begin
	insert into #temp_OUT (OrgId)
	select Id FROM [dbo].[Organizations]
end

if object_id('tempdb..#temp_OUT_QuestionGroup') is not null drop table #temp_OUT_QuestionGroup
create table #temp_OUT_QuestionGroup(
QueTypeId int
)

if @QuestionGroupId is not null
begin
	insert into #temp_OUT_QuestionGroup (QueTypeId)
	 select type_question_id from [QGroupIncludeQTypes] where group_question_id = @QuestionGroupId
end
else 
begin
	insert into #temp_OUT_QuestionGroup (QueTypeId)
	 select Id from [QuestionTypes]
end

-- select group_question_id,type_question_id from [QGroupIncludeQTypes]
--select * from #temp_OUT
--select * from [OrganizationGroups]


  select [Que].Id as QuestionId, 
  [Que].Registration_date, 
  [Vykon].Log_Date Vykon_date,
  [Closed].Log_Date Close_date,
  
  [QuestionStates].name [QuestionState],
  1 Count_,
  case when [Vykon].Log_Date>[Que].control_date then 1 else 0 end Сount_prostr,
  
  [Organizations1].[Id] as OrgExecutId, 
  [Organizations1].[Name] as OrgExecutName, 
  [Organizations1].[Level] as LevelToOrgatization,
  [Organizations1].[OrgName_Level1] Orgatization_Level_1, 
  [Organizations1].[OrgName_Level2] Orgatization_Level_2, 
  [Organizations1].[OrgName_Level3] Orgatization_Level_3,
  [Organizations1].[OrgName_Level4] Orgatization_Level_4,
  [Organizations1].[LabelName] as OrgExecutLabelName,
  [Organizations1].[LabelName2] as OrgExecutLabelName2,


  stuff((select N','+[OrganizationGroups].[name] from [OGroupIncludeOrganizations]
		left join [OrganizationGroups] on [OGroupIncludeOrganizations].organization_group_id=[OrganizationGroups].Id
		where [OGroupIncludeOrganizations].organization_id = [Ass].executor_organization_id
					for xml path('')), 1,1,N'') as [GroupOrganisations],
  stuff((select N','+[QuestionGroups].[name] from [QGroupIncludeQTypes]
		left join [QuestionGroups] on [QGroupIncludeQTypes].[group_question_id]=[QuestionGroups].Id
		left join [QuestionTypes] as [QTypes] on [QGroupIncludeQTypes].type_question_id=[QTypes].Id
		where [QGroupIncludeQTypes].[type_question_id]=[QueTypes].Id
					for xml path('')), 1,1,N'') as [GroupQuestionTypes],
  [ReceiptSources].name [ReceiptSources],
  [QueTypes].[Id] as [QuestionTypeId],
  QueTypes.[name] as [QuestionTypeName],
  case when QuestionStates.[name] = 'Зареєстровано' then 1 else 0 end as stateRegistered,
  case when QuestionStates.[name] = 'В роботі' then 1 else 0 end as stateInWork,
  case when QuestionStates.[name] = 'На перевірці' then 1 else 0 end as stateOnCheck,
  case when QuestionStates.[name] = 'На доопрацюванні' then 1 else 0 end as stateOnRefinement,
  case when QuestionStates.[name] = 'Закрито' then 1 else 0 end as stateClose

  from [Questions] as [Que]
  left join [QuestionTypes] as [QueTypes] on [Que].question_type_id=[QueTypes].Id
  left join [QuestionStates] on [Que].question_state_id=[QuestionStates].Id
  left join [Appeals] on [Que].appeal_id=[Appeals].Id
  left join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
  left join [Assignments] as [Ass] on [Que].last_assignment_for_execution_id=[Ass].Id
  
  left join (
		select  [Id],	
				[ParentId],	
				[Name],	
				[Level],
				[LabelCode],
				[LabelName],
				[LabelName2],
				[Label_Level1],
				[Label_Level2],
				[Label_Level3],
				[Label_Level4],
				[OrgName_Level1],	
				[OrgName_Level2],	
				[OrgName_Level3],	
				[OrgName_Level4]
		from [dbo].[ReportConctructor_Organizations]
		where Id in (select OrgId from #temp_OUT)
				) [Organizations1] on [Ass].executor_organization_id=[Organizations1].Id 
  left join (
  select assignment_id, Log_Date from
  (select [Assignment_History].assignment_id, ROW_NUMBER() OVER (partition by assignment_id order by Id asc) n, Log_Date
  from [Assignment_History]
  where assignment_state_id=3 /*На перевірці*/) t where n=1
  ) Vykon on [Ass].Id=Vykon.assignment_id
  left join (
  select assignment_id, Log_Date from
  (select [Assignment_History].assignment_id, ROW_NUMBER() OVER (partition by assignment_id order by Id asc) n, Log_Date
  from [Assignment_History]
  where assignment_state_id=5 /*Закрито*/) t where n=1
  ) Closed on [Ass].Id=Closed.assignment_id
  where cast([Que].Registration_date as date) between cast(@RegistrationDateFrom as date) and cast(@RegistrationDateTo as date)
  and ([Ass].[executor_organization_id] in (select OrgId from #temp_OUT))
  and ([ReceiptSources].[Id] = @ReceiptSourcesId or @ReceiptSourcesId is null)
  and [Que].question_type_id in (select QueTypeId from #temp_OUT_QuestionGroup)
  and #filter_columns#

  --convert(date, Vykon.Log_Date)
  --convert(date, Closed.Log_Date)
  --[QueTypes].[Id] as [QuestionTypeId]
  --[Vykon].Log_Date Vykon_date,
  --[Closed].Log_Date Close_date,