declare @number nvarchar(25) = '+38(063)6336234'
--declare @number nvarchar(25) = null
--declare @number nvarchar(25) = '+38(050)6336677'

if @number = any (select phone_number from [ApplicantPhones])
		select   [Applicants].[Id]
		        ,@number as number
		        ,Applicants.full_name
		        ,null as addApp
			from ApplicantPhones 
				left join Applicants on Applicants.Id = ApplicantPhones.applicant_id  
			WHERE [ApplicantPhones].[phone_number] = @number
		union all
    		select null as Id
    		,@number as number
    		, null as full_name
    		,'Додати нового заявника' as addApp
	else
		select null as Id
		,isnull(@number, 'АНОНІМНИЙ') as number
		, 'Заявник відсутній в базі' as full_name
		,'Додати нового заявника' as addApp



/* 
 SELECT [Applicants].[Id]
      ,@number as number
	  ,isnull ((select Applicants.full_name from ApplicantPhones WHERE [ApplicantPhones].[phone_number] = @number), null) as full_name
  FROM [dbo].Applicants
	left join [ApplicantPhones] on Applicants.Id = ApplicantPhones.applicant_id
		
WHERE
#filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 
 */
 
 
 
 
 

/*SELECT [ApplicantPhones].[Id]
      ,[ApplicantPhones].[phone_number]
	  ,table_applicants.full_name
  FROM [dbo].[ApplicantPhones]
	left join --Applicants on Applicants.Id = ApplicantPhones.applicant_id
			(SELECT b.Id
				,(select RTRIM(a.full_name) + N'; ' as 'data()' from Applicants as a where b.Id = a.Id for xml path('')
				) as full_name
			FROM Applicants as b GROUP BY b.Id) as table_applicants  on table_applicants.Id = ApplicantPhones.applicant_id
WHERE
#filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 */
 
