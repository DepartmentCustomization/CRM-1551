--declare @ClaimId int = 262524

SELECT [Lokal_copy_gorodok_claims].[Id]
      ,[Lokal_copy_gorodok_claims].[claim_number]
      ,[QuestionStates].[name] as [claim_state]
      ,[Lokal_copy_gorodok_claims].[claims_type] as [claim_type]
      ,[Lokal_copy_gorodok_claims].[content] as [claim_content]
      ,/*case when [Buildings].[index] is null then N'' else isnull(rtrim([Buildings].[index]),N'')+N', ' end + */isnull([StreetTypes].shortname,N'')+N' '+isnull([Streets].name,N'')+N' '+isnull([Buildings].name,N'') 
		+ case when len(isnull([LiveAddress].flat,N'')) = 0 then N'' else N', кв. '+isnull(rtrim([LiveAddress].flat),N'') end as [main_object_id]
      ,[Lokal_copy_gorodok_claims].[executor]
      ,[Lokal_copy_gorodok_claims].[registration_date] as [start_date]
      ,[Lokal_copy_gorodok_claims].[plan_finish_date] as [planned_end_date]
      ,null as [fact_end_date]
      ,[Lokal_copy_gorodok_claims].[executor_comment] as [comment_executor]
  FROM [CRM_1551_GORODOK_Integrartion].[dbo].[Gorodok_1551_houses]
	  left join[CRM_1551_GORODOK_Integrartion].[dbo].[Lokal_copy_gorodok_claims] on [Lokal_copy_gorodok_claims].[object_id] =  [Gorodok_1551_houses].gorodok_houses_id
	  left join [CRM_1551_GORODOK_Integrartion].[dbo].Claims_states on Claims_states.[name] = [Lokal_copy_gorodok_claims].[status]
	  left join [dbo].[QuestionStates] on [QuestionStates].Id = Claims_states.[1551_state]
	  left join [dbo].[LiveAddress] on [LiveAddress].building_id = [Gorodok_1551_houses].[1551_houses_id]
	  left join [dbo].[Buildings] on [Buildings].Id = [LiveAddress].building_id
	  left join [dbo].[Streets] on [Streets].Id = [Buildings].street_id
	  left join [dbo].[StreetTypes] on [StreetTypes].Id = [Streets].street_type_id
	  left join [dbo].[Districts] on [Districts].Id = [Streets].district_id
  where [Lokal_copy_gorodok_claims].[Id] = @ClaimId