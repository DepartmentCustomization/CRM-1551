 

 
 --declare @filter nvarchar(max)=N'1=1';
 --declare @sort nvarchar(max)=N'full_name';
 --declare @buildId int =708;

 declare @sort1 nvarchar(max)=case when @sort=N'1=1' then N'QuestionType' else @sort end;
 



 declare @qcode nvarchar(max)=N'

 select Id, registration_number, QuestionType, full_name, phone_number, DistrictName District,
 house, place_problem, vykon, zmist, comment, [history], ApplicantsId, BuildingId, [Organizations_Id],
 cc_nedozvon, AssignmentStates_code, states, result, result_id, entrance, [edit_date], [control_comment], [registration_date]
 
 from
 (
 select [Assignments].Id, [Questions].registration_number, ltrim([QuestionTypes].name) QuestionType,
  [Applicants].full_name, [ApplicantPhones].phone_number, [Districts].Id District,
  [Districts].Name DistrictName,
  isnull([StreetTypes].shortname+N'' '',N'''')+
  isnull([Streets].name+N'', '',N'''')+
  isnull([Buildings].name, N'''')+
  isnull(N'' кв. ''+[LiveAddress].flat,N'''') house,

  isnull([StreetTypes2].shortname+N'' '',N'''')+
  isnull([Streets2].name+N'', '',N'''')+
  isnull([Buildings2].name, N'''') place_problem
  ,[Organizations].short_name vykon
  ,[Questions].question_content zmist
  ,[AssignmentConsiderations].short_answer comment
  , null [history]
  --,[Assignments].executor_organization_id
  ,[Applicants].Id ApplicantsId, [Buildings].Id BuildingId
  ,[Organizations].Id [Organizations_Id]
  ,isnull([AssignmentRevisions].[missed_call_counter], 0) cc_nedozvon
  ,case when [Assignments].assignment_state_id=3
  then [Assignments].state_change_date end [state_changed_date] -- good
  ,case when [Assignments].assignment_state_id=3 and [AssignmentConsiderations].assignment_result_id=4
  then [Assignments].state_change_date end [state_changed_date_done]
  --,[Questions].entrance
  ,[LiveAddress].entrance
  ,[Questions].flat
  ,[Objects].Id [object]
  ,[Organizations].Id organization
  ,[QuestionTypes].Id question_type
  ,[Rating].Id [question_list_state]
  ,[Assignments].registration_date
  ,[AssignmentStates].code AssignmentStates_code
  ,[AssignmentStates].name states
  ,[AssignmentRevisions].[edit_date]
  ,[AssignmentRevisions].[control_comment]
  ,[AssignmentResults].[name] as result
  ,[Assignments].AssignmentResultsId as result_id
  from [Assignments] with (nolock)
  left join [AssignmentStates] with (nolock) on [Assignments].assignment_state_id=[AssignmentStates].Id
  left join [AssignmentResults] with (nolock) on [Assignments].AssignmentResultsId=[AssignmentResults].Id
  left join [AssignmentConsiderations] with (nolock) on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
  left join [Questions] with (nolock) on [Assignments].question_id=[Questions].Id
  left join [QuestionTypes] with (nolock) on [Questions].question_type_id=[QuestionTypes].Id
  left join [Appeals] with (nolock) on [Questions].appeal_id=[Appeals].Id
  left join [Applicants] with (nolock) on [Appeals].applicant_id=[Applicants].Id
  left join [ApplicantPhones] with (nolock) on [ApplicantPhones].applicant_id=[Applicants].Id and [ApplicantPhones].IsMain = 1
  left join [LiveAddress] with (nolock) on [LiveAddress].applicant_id=[Applicants].Id
  left join [Buildings] with (nolock) on [LiveAddress].building_id=[Buildings].Id
  left join [Districts] with (nolock) on [Buildings].district_id=[Districts].Id
  left join [Streets] with (nolock) on [Buildings].street_id=[Streets].Id
  left join [StreetTypes] with (nolock) on [Streets].street_type_id=[StreetTypes].Id
  left join [Objects] with (nolock) on [Questions].object_id=[Objects].Id
  left join [Buildings] [Buildings2] with (nolock) on [Objects].[builbing_id]=[Buildings2].Id
  left join [Districts] [Districts2] with (nolock) on [Buildings2].district_id=[Districts2].Id
  left join [Streets] [Streets2] with (nolock) on [Buildings2].street_id=[Streets2].Id
  left join [StreetTypes] [StreetTypes2] with (nolock) on [Streets2].street_type_id=[StreetTypes2].Id
  left join [Organizations] with (nolock) on [Assignments].executor_organization_id=[Organizations].Id
  left join [ReceiptSources] with (nolock) on [Appeals].receipt_source_id=[ReceiptSources].Id
  left join [QuestionTypeInRating] with (nolock) on [QuestionTypes].question_type_id=[QuestionTypes].Id
  left join [Rating] with (nolock) on [QuestionTypeInRating].Rating_id=[Rating].Id
  left join [AssignmentRevisions] with (nolock) on [AssignmentConsiderations].Id=[AssignmentRevisions].assignment_consideration_іd


  where --[AssignmentStates].code in (N''Registered'', N''InWork'', N''OnCheck'', N''NotFulfilled'') and
   [Assignments].[main_executor]=''true'' 
   --    ([ReceiptSources].code<>N''UGL'' and [AssignmentStates].code<>N''OnCheck'' and [AssignmentResults].code<>N''Done'')
     -- and  not (([ReceiptSources].code=N''UGL'' or [ReceiptSources].code=N''Website_mob.addition'') and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''Done'')

	 and  not (([ReceiptSources].code=N''UGL'' or [ReceiptSources].code=N''Website_mob.addition'') and [AssignmentResults].code=N''Done'')
    and not ([ReceiptSources].code=N''UGL'' or [ReceiptSources].code=N''Website_mob.addition'')

and 
	
	(case when [AssignmentStates].code=N''Closed'' and 
	
	(ltrim(isnull(year([Assignments].[close_date]), 2000))+ltrim(isnull(month([Assignments].[close_date]),1)))*1<>
	(ltrim(year(getutcdate()))+ltrim(month(getutcdate())))*1
	
	
	then 0 else 1 end)=1


  ) t

  where BuildingId='+cast(ltrim(@buildId) as nvarchar(max))+N' and '+@filter+N'
  order by '+@sort1

  exec(@qcode)
