
/*
declare @column nvarchar(max)=N'Роз`яcнено';--N'План / Програма';
declare @user_id nvarchar(128)=N'29796543-b903-48a6-9399-4840f6eac396';
*/

declare @comment_ros nvarchar(max)=(select case when @column=N'Роз`яcнено' then N' ' else N'--' end);
declare @comment_doopr nvarchar(max)=(select case when @column=N'Доопрацьовані' then N' ' else N'--' end);
declare @comment_prostr nvarchar(max)=(select case when @column=N'Прострочені' then N' ' else N'--' end);
declare @comment_nemozh nvarchar(max)=(select case when @column=N'План / Програма' then N' ' else N'--' end);
declare @comment_vykon nvarchar(max)=(select case when @column=N'Виконано' then N' ' else N'--' end);



declare @exec1 nvarchar(max)=N'
select [Assignments].Id, [Organizations].Id OrganizationsId, 

case when len([Organizations].[head_name]) > 5 then [Organizations].[head_name] + '' ( '' + [Organizations].[short_name] + '')''
					else [Organizations].[short_name] end

 OrganizationsName,
[Applicants].full_name zayavnykName, [StreetTypes].shortname+N'' ''+Streets.name+N'', ''+[Buildings].name adress, [Questions].registration_number,
[QuestionTypes].name QuestionType, 
 
 [Applicants].Id zayavnykId, [Questions].Id QuestionId, [Organizations].short_name vykonavets,
 convert(datetime, dateadd(HH, [execution_term], [Assignments].registration_date)) control_date
,[rework_counter].rework_counter, [AssignmentConsiderations].short_answer, [Questions].question_content

,[Applicants].[ApplicantAdress] adressZ

 ,[Organizations2].Id [transfer_to_organization_id]
 ,[Organizations2].[short_name] [transfer_to_organization_name]

from 
[Assignments] with (nolock)
inner join [AssignmentResults] on [Assignments].[AssignmentResultsId]=[AssignmentResults].Id -- +
inner join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
inner join [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
inner join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
inner join [ReceiptSources] on [Appeals].receipt_source_id=[ReceiptSources].Id
left join [QuestionTypes] on [Questions].question_type_id=[QuestionTypes].Id
left join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
left join [AssignmentResolutions] on [Assignments].[AssignmentResolutionsId]=[AssignmentResolutions].Id
left join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id
left join [Objects] with (nolock) on [Questions].[object_id]=[Objects].Id
left join [Buildings] with (nolock) on [Objects].builbing_id=[Buildings].Id
left join [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
left join [Applicants] with (nolock) on [Appeals].applicant_id=[Applicants].Id
left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd
left join [StreetTypes] with (nolock) on [Streets].street_type_id=[StreetTypes].Id
left join (select count(AssignmentRevisions.id) rework_counter, AssignmentConsiderations.assignment_id
from AssignmentRevisions with (nolock)
inner join AssignmentConsiderations on AssignmentRevisions.assignment_consideration_іd=AssignmentConsiderations.Id
where AssignmentRevisions.control_result_id = 5
group by AssignmentConsiderations.assignment_id) rework_counter on Assignments.Id=rework_counter.assignment_id

left join [Organizations] [Organizations2] with (nolock) on [AssignmentConsiderations].[transfer_to_organization_id]=[Organizations2].Id
left join [Buildings] [Buildings5] with (nolock) on [Objects].builbing_id=[Buildings5].Id
left join [Districts] [Districts5] with (nolock) on [Buildings5].district_id=[Districts5].Id
where [ReceiptSources].code=N''UGL'' and
'+@comment_doopr+N'([AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and [AssignmentRevisions].rework_counter in (1,2))
 '+@comment_ros+N'([AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'')
 '+@comment_prostr+N'([AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController'' and [Questions].control_date<=getutcdate())
 '+@comment_nemozh+N'([AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''ItIsNotPossibleToPerformThisPeriod'' and [AssignmentResolutions].code=N''RequiresFunding_IncludedInThePlan'')
 '+@comment_vykon+N'([AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''Done'')
'

 declare @exec_resulr nvarchar(max)=N'
  with

main as
('+@exec1
+N') select  Id, registration_number, zayavnykName, control_date, zayavnykId, QuestionType, adress,  QuestionId, 
OrganizationsName,
 rework_counter, short_answer, question_content, adressZ, [transfer_to_organization_id], [transfer_to_organization_name]
 from main  

 --where #filter_columns#
order by Id desc'



--select @exec1, len(@exec1), len(@exec_resulr)--@exec_resulr

exec(@exec_resulr)
