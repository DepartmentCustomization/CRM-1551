

/*
declare @zayiavnykId int = 20;
declare @questionId int =1034;*/

declare @comment nvarchar(300)=
(
select distinct [AssignmentConsiderations].short_answer
  from [CRM_1551_Analitics].[dbo].[Assignments]
  inner join [CRM_1551_Analitics].[dbo].[Questions] on [Assignments].question_id=[Questions].Id
--   inner join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
  inner join [CRM_1551_Analitics].[dbo].[AssignmentConsiderations] on [Assignments].current_assignment_consideration_id=[AssignmentConsiderations].Id
  inner join [CRM_1551_Analitics].[dbo].[Appeals] on [Questions].appeal_id=[Appeals].Id
  --inner join 
  where [Questions].id=@questionId and [Appeals].applicant_id=@zayiavnykId
);



declare @question_content nvarchar(500)=
(select [question_content]
  FROM [CRM_1551_Analitics].[dbo].[Questions]
  where Id=@questionId);

select [LiveAddress].Id, 
--N'вул. '+[Streets].name+N', буд. '+ [Buildings].name+ 
--  case when [Buildings].letter is not null then [Buildings].letter else N'' end
--  +case when [LiveAddress].house_block is not null then N', корпус '+[LiveAddress].house_block else N'' end+
--  case when [LiveAddress].entrance is not null then N', парадне '+convert(nvarchar(200),[LiveAddress].entrance) else N'' end+
--  case when [LiveAddress].flat is not null then N', кв. '+convert(nvarchar(200), [LiveAddress].flat) else N'' end address,
  @question_content content, @comment comment
  from [CRM_1551_Analitics].[dbo].[LiveAddress]-- left join [CRM_1551_Analitics].[dbo].[Applicants] on [LiveAddress].applicant_id=[Applicants].Id
  left join [CRM_1551_Analitics].[dbo].[Buildings] on [LiveAddress].building_id=[Buildings].Id
  left join [CRM_1551_Analitics].[dbo].[Streets] on [Buildings].street_id=[Streets].Id
  where [LiveAddress].applicant_id=@zayiavnykId