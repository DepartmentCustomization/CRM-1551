SELECT [Questions].[Id]
      ,[Questions].[registration_number]
      ,[Questions].[registration_date]
	  ,Organizations.name as org_name

  FROM [dbo].[Questions]
	left join Assignments on Assignments.question_id = Questions.Id
	left join Organizations on Organizations.Id = Assignments.executor_organization_id
where Questions.object_id = @objectGorodoc
	and Questions.application_town_id is not null
	and #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only