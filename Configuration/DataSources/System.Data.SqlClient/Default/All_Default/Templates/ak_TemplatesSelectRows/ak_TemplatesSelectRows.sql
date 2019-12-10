--declare @user_Id nvarchar(128)=N'b30e5bea-db1e-42ba-9eda-f5c67d46ab2b';

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

select [Templates].Id, [Templates].Name, [Content]
  from [Templates]
  where organization_id in (select Id from @organization_table)
  and 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
