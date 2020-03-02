with [ParentOrganisations] as (
    select
       [Id]
      ,[Name]
      ,[ParentId]
    from (select [Id] ,short_name as [Name] ,[parent_organization_id] as [ParentId] from [dbo].[Organizations] where active = 1
	) as t1
   where
   #filter_columns#
),
[Organisations] as (
    select
       [Id]
      ,[Name]
      ,[ParentId]
    from [ParentOrganisations]
    union all
    select
       t1.[Id]
      ,t1.[Name]
      ,t1.[ParentId]
    from (select [Id] ,short_name as [Name] ,[parent_organization_id] as [ParentId] from [dbo].[Organizations] where active = 1) as t1
    -- where exists(select * from [ParentOrganisations] where [ParentOrganisations].[Id] = t1.[ParentId])
    	    where t1.Id in (select Id from [ParentOrganisations] where [ParentOrganisations].[ParentId] = t1.[Id])
)
select
       [Id]
      ,[Name]
      ,[ParentId]
from [Organisations]