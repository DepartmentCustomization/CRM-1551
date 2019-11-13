--declare @zayiavnykId int = 20;
--declare @questionId int =1034;
declare @question_content nvarchar(500)=
(select [question_content]
  FROM [CRM_1551_Analitics].[dbo].[Questions]
  where Id=@questionId);

select [LiveAddress].Id, @question_content content,
[StreetTypes].shortname+N' '+[Streets].name+N', буд. '+ [Buildings].name+ 
  case when [Buildings].letter is not null then [Buildings].letter else N'' end
  +case when [LiveAddress].house_block is not null then N', корпус '+[LiveAddress].house_block else N'' end+
  case when [LiveAddress].entrance is not null then N', парадне '+convert(nvarchar(200),[LiveAddress].entrance) else N'' end+
  case when [LiveAddress].flat is not null then N', кв. '+convert(nvarchar(200), [LiveAddress].flat) else N'' end address
  
  from [CRM_1551_Analitics].[dbo].[LiveAddress]-- left join [CRM_1551_Analitics].[dbo].[Applicants] on [LiveAddress].applicant_id=[Applicants].Id
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [LiveAddress].building_id=[Buildings].Id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
  left join [CRM_1551_Analitics].[dbo].[StreetTypes] on [Streets].street_type_id=[StreetTypes].Id
  where [LiveAddress].applicant_id=@zayiavnykId