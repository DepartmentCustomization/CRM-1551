
with [KnowledgeBaseStatesTable] as (
    select
       t1.[Id]
      ,t1.[Name]
      ,t1.[ParentId]
	  ,[has_child]
      ,CONVERT(nvarchar(max), isnull(t1.[Name],N'')) as [Path]
    from (select [Id] ,[name] as [Name] ,[parent_id] as [ParentId], case when [id] = 1 then 1 else 0 end [has_child]
	      from [dbo].[KnowledgeBaseStates] where is_visible = 1) as t1
    where [ParentId] is NULL
    union all
    select
       t1.[Id]
      ,t1.[Name]
      ,t1.[ParentId]
	  ,t1.[has_child]
      ,CONVERT(nvarchar(max), isnull([Path],N'') + N'\' + isnull(t1.[Name],N'')) as [Path]
    from (select [Id] ,[name] as [Name] ,[parent_id] as [ParentId],  case when [id] = 1 then 1 else 0 end [has_child]
	      from [dbo].[KnowledgeBaseStates] where is_visible = 1) as t1
    join [KnowledgeBaseStatesTable] on [KnowledgeBaseStatesTable].[Id] = t1.[ParentId]
)
SELECT * FROM (
select
       [Id]
      ,[Name]
      ,[Path]
      ,[has_child]
from [KnowledgeBaseStatesTable]
WHERE case when [id] = 1 then 1 else 0 end =0) s1
where #filter_columns#
#sort_columns#
offset @pageOffsetRows rows fetch next @pageLimitRows rows only