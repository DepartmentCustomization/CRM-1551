--declare @phone_number nvarchar(25) = N'0993896537'


if (SELECT count(1) as kolvo
  FROM [CRM_1551_Analitics].[dbo].[Appeals]
  left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[appeal_id] = [Appeals].[Id]
  left join [CRM_1551_Analitics].[dbo].[ApplicantPhones] on [ApplicantPhones].[applicant_id] = [Appeals].[applicant_id]
  where [ApplicantPhones].phone_number = @phone_number
  and [Questions].[Id] is not null) > 0
begin
	select rtrim((	
		 select * 
		 from (
					SELECT [Questions].[Id] as [QuestionId],
							[Questions].[registration_number] as [QuestionRegistrationNumber],
							[QuestionTypes].[name] as [QuestionTypeName]
					FROM [CRM_1551_Analitics].[dbo].[Appeals]
					left join [CRM_1551_Analitics].[dbo].[Questions] on [Questions].[appeal_id] = [Appeals].[Id]
					left join [CRM_1551_Analitics].[dbo].[QuestionTypes] on [QuestionTypes].[Id] = [Questions].[question_type_id]
					left join [CRM_1551_Analitics].[dbo].[ApplicantPhones] on [ApplicantPhones].[applicant_id] = [Appeals].[applicant_id]
					where [ApplicantPhones].phone_number = @phone_number
					and [Questions].[Id] is not null
					and [Questions].[registration_date] >= dateadd(hour, -2, getutcdate())
					
	 ) as result
		order by result.[QuestionId] 
		FOR JSON AUTO
	 ))
end
else
begin
 select N'вихідні параметри - питань немає' as [result]
end