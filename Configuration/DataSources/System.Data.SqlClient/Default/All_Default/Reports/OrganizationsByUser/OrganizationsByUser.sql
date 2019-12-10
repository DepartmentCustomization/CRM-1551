
-- declare @user_id nvarchar(128) = 'eb6d56d2-e217-45e4-800b-c851666ce795';
declare @user_org table (
    Id int);
declare @kbu_orgs table (Id int);
declare @is_root smallint;

Insert into @user_org
select OrganisationStructureId
from [CRM_1551_System].[dbo].[UserInOrganisation]
where UserId = @user_id

--- Получить организации дочерние от КБУ
;WITH
    RecursiveOrg
    (Id, parentID, orgName)
    AS
    (
                    SELECT o.Id, ParentId, Name
            FROM [CRM_1551_System].[dbo].[OrganisationStructure] o
            WHERE o.Id = 4
        UNION ALL
            SELECT o.Id, o.ParentId, o.Name
            FROM[CRM_1551_System].[dbo].[OrganisationStructure] o
                JOIN RecursiveOrg r ON o.ParentId = r.Id
    )
Insert into @kbu_orgs
SELECT distinct
    Id
FROM RecursiveOrg r


set @is_root = (
  select count(x) xqty
from (
  select
        case when Id in (2) or Id in (select Id
            from @kbu_orgs) 
  then 'One' else 'Zero' end as x
    from @user_org )x
where x.x = 'One'
  )
if object_id('tempdb..#orgList') is not null
		drop table #orgList
create table #orgList
(
    Id int,
    parentID int,
    orgName nvarchar(255)
);

--- Если юзер из структуры админов или КБУ - показывать все
If(@is_root > 0)
    begin
    ;
    WITH
        RecursiveOrg
        (Id, parentID, orgName)
        AS
        (
                            SELECT o.Id, parent_organization_id, short_name
                FROM Organizations o
                where o.Id > 1
            UNION ALL
                SELECT o.Id, o.parent_organization_id, o.short_name
                FROM Organizations o
                    JOIN RecursiveOrg r ON o.parent_organization_id = r.Id
        )

    Insert into #orgList
    SELECT distinct
        Id,
        parentID,
        orgName
    FROM RecursiveOrg r
end
   --- Иначе выборка по должности
   Else if (@is_root = 0)
   begin
    ;
    WITH
        RecursiveOrg
        (Id, parentID, orgName)
        AS
        (
                            SELECT o.Id, parent_organization_id, short_name
                FROM Organizations o
                    join Positions p on p.organizations_id = o.Id
                WHERE p.programuser_id = @user_id
            UNION ALL
                SELECT o.Id, o.parent_organization_id, o.short_name
                FROM Organizations o
                    JOIN RecursiveOrg r ON o.parent_organization_id = r.Id
        )

    Insert into #orgList
    SELECT distinct
        Id,
        parentID,
        orgName
    FROM RecursiveOrg r
end

Select
    Id, orgName
from #orgList
where #filter_columns#
order by Id 
         offset @pageOffsetRows rows fetch next @pageLimitRows rows only