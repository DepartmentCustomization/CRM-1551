

  --declare @assignment_id int=2975838;
  --declare @user_Id nvarchar(128)=N'29796543-b903-48a6-9399-4840f6eac396';

  declare @organization_table table (Id int);

  WITH  cte -- все высше стоящие 3 и 3
    AS ( SELECT   Id, [parent_organization_id] ParentId
         FROM [Organizations] t
         WHERE Id in /*=@Id*/ (select distinct organizations_id from [Positions] where active='true' and programuser_id=@user_Id) 
         UNION ALL
         SELECT   tp.Id,
                  [parent_organization_id] ParentId--, [name]
         FROM [Organizations] tp 
         INNER JOIN cte curr ON tp.Id = curr.ParentId ),
     cte1 -- все подчиненные 3 и 3
   AS ( SELECT   Id, [parent_organization_id] ParentId
         FROM [Organizations] t
         WHERE Id /*= @Id*/in (select distinct organizations_id from [Positions] where active='true' and programuser_id=@user_Id)
         UNION ALL
         SELECT   tp.Id,
                  tp.[parent_organization_id] ParentId
         FROM [Organizations] tp 
         INNER JOIN cte1 curr ON tp.[parent_organization_id] = curr.Id )

insert into @organization_table (Id)
SELECT Id FROM cte
where Id>4
UNION
SELECT Id FROM cte1
where Id>4



  select distinct Id, name
  from (
  select  t.Id, t.name
  from [QuestionTypeTemplates] qtt
  inner join [QuestionTypes] qt on qtt.question_type_id=qt.Id
  inner join [Questions] q on q.question_type_id=qt.Id
  inner join [Assignments] a on a.question_id=q.Id
  inner join [Templates] t on qtt.template_id=t.Id
  where a.Id=@assignment_id and
   t.organization_id in (select Id from @organization_table)
  ) t
  
where  
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
