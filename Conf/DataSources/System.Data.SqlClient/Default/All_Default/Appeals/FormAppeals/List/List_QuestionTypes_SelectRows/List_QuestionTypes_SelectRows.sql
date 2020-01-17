
declare @TypeId int = (SELECT top 1 [Id] FROM [dbo].[QuestionTypes] where #filter_columns#)

if @TypeId = 1
begin
		with [Parent_question_types] as (
		   SELECT 
				 [Id]
				 ,[Name]
				 ,[question_type_id] as [ParentId]
				 ,[has_child]
		    FROM [dbo].[QuestionTypes]
			where active = 1
			and #filter_columns#
		),
		[Child_question_types] as (
			SELECT 
			   [Id]
		      ,[ParentId]
		      ,[Name]
		      ,[has_child]
		    FROM [Parent_question_types]
		    
		    UNION all
		    
		    SELECT
		         [Id]
		         ,[question_type_id] as [ParentId]
				 ,[Name]
				 ,[has_child]
		    from [dbo].[QuestionTypes]
		    where active = 1 and exists(select * from [Parent_question_types] where [Parent_question_types].[Id] = [QuestionTypes].[question_type_id])
		)
		
		
		select 
		   [Id]
		      ,[ParentId]
		      ,[Name]
		      ,[has_child]
		from [Child_question_types]

end
else
begin
		with [Parent_question_types] as (
		   SELECT 
				 [Id]
				 ,[Name]
				 ,[question_type_id] as [ParentId]
				 ,[has_child]
		    FROM [dbo].[QuestionTypes]
			where active = 1
			and #filter_columns#
		),
		[Child_question_types] as (
			SELECT 
			   [Id]
		      ,[ParentId]
		      ,[Name]
		      ,[has_child]
		    FROM [Parent_question_types]
		    
		    UNION all
		    
		    SELECT 
				 [Id]
				 ,[question_type_id] as [ParentId]
				 ,[Name]
				 ,[has_child]
		    FROM [dbo].[QuestionTypes]
			where active = 1
		    and [QuestionTypes].Id in (select Id from [Parent_question_types] where [Parent_question_types].[Id] = [QuestionTypes].[question_type_id])
		)
		
		
		select 
		   [Id]
		      ,[ParentId]
		      ,[Name]
		      ,[has_child]
		from [Child_question_types]
end







---ниже было

-- --declare @ParentId1 int=1;

-- with [ParentOrganisations] as (
--     select
--       [Id]
--       ,[Name]
--       ,[ParentId]
--     from (select [Id] ,[name] as [Name] ,[question_type_id] as [ParentId] from [dbo].[QuestionTypes] where active = 1 ) as t1
-- 	where #filter_columns#
-- 	union all
--     select
--       [Id]
--       ,[Name]
--       ,[ParentId]
--     from (select [Id] ,[name] as [Name] ,[question_type_id] as [ParentId] from [dbo].[QuestionTypes] where active = 1 ) as t1
-- 	where ParentId =1
-- ),
-- [Organisations] as (
--     select
--       [Id]
--       ,[Name]
--       ,[ParentId]
--     from [ParentOrganisations]
--     union all
--     select
--       t1.[Id]
--       ,t1.[Name]
--       ,t1.[ParentId]
--     from (select [Id] ,[name] as [Name] ,[question_type_id] as [ParentId] from [dbo].[QuestionTypes]  where active = 1) as t1
--     --where exists(select * from [ParentOrganisations] where [ParentOrganisations].[Id] = t1.[ParentId])
--     where t1.Id in (select Id from [ParentOrganisations] where [ParentOrganisations].[ParentId] = t1.[Id])
-- )
-- select 
--       [Id]
--       ,[Name]
--       ,[ParentId]
-- from [Organisations]


-- with [ParentOrganisations] as (
--     select
--       [Id]
--       ,[Name]
--       ,[ParentId]
-- 	  ,[has_child]
--     from (select [Id] ,[name] as [Name] ,[question_type_id] as [ParentId], [has_child] from [dbo].[QuestionTypes] where active = 1 and #filter_columns#) as t1
    
    
-- --     union all
-- --     select
-- --       [Id]
-- --       ,[Name]
-- --       ,[ParentId]
-- --     from (select [Id] ,[name] as [Name] ,[question_type_id] as [ParentId] from [dbo].[QuestionTypes] where active = 1 ) as t1
-- -- 	where ParentId =1
    
    
    
-- ),
-- [Organisations] as (
--     select
--       [Id]
--       ,[Name]
--       ,[ParentId]
-- 	  ,[has_child]
--     from [ParentOrganisations]
--     union all
--     select
--       t1.[Id]
--       ,t1.[Name]
--       ,t1.[ParentId]
-- 	  ,t1.[has_child]
--     from (select [Id] ,[name] as [Name] ,[question_type_id] as [ParentId], [has_child] from [dbo].[QuestionTypes]  where active = 1) as t1
--     --where exists(select * from [ParentOrganisations] where [ParentOrganisations].[Id] = t1.[ParentId])
--     where t1.Id in (select Id from [ParentOrganisations] where [ParentOrganisations].[ParentId] = t1.[Id])
-- )
-- select 
--       [Id]
--       ,[Name]
--       ,[ParentId]
-- 	  ,[has_child]
-- from [Organisations]