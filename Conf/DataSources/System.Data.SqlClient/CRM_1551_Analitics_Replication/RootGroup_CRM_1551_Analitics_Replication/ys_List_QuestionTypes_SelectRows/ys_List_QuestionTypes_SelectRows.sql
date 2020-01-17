
with [ParentOrganisations] as (
    select
      [Id]
      ,[Name]
      ,[ParentId]
	  ,[has_child]
    from (select [Id] ,[name] as [Name] ,[question_type_id] as [ParentId], [has_child] from [dbo].[QuestionTypes] where active = 1 and #filter_columns#) as t1
    ),
[Organisations] as (
    select
      [Id]
      ,[Name]
      ,[ParentId]
	  ,[has_child]
    from [ParentOrganisations]
    union all
    select
      t1.[Id]
      ,t1.[Name]
      ,t1.[ParentId]
	  ,t1.[has_child]
    from (select [Id] ,[name] as [Name] ,[question_type_id] as [ParentId], [has_child] from [dbo].[QuestionTypes]  where active = 1) as t1
    --where exists(select * from [ParentOrganisations] where [ParentOrganisations].[Id] = t1.[ParentId])
    where t1.Id in (select Id from [ParentOrganisations] where [ParentOrganisations].[ParentId] = t1.[Id])
)
select 
      [Id]
      ,[Name]
      ,[ParentId]
	  ,[has_child]
from [Organisations]