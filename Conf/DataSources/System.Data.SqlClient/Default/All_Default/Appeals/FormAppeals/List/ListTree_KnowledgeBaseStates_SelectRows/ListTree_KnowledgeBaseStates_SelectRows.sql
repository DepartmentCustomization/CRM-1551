-- DECLARE @TypeId INT = (
-- 	SELECT
-- 		TOP 1 [Id]
-- 	FROM
-- 		[dbo].[KnowledgeBaseStates]
-- 	WHERE
-- 		#filter_columns /*parent_id is null*/)
-- 		IF @TypeId = 1 
-- 		BEGIN 
-- 		WITH [Parent_data] AS (
-- 			SELECT
-- 				[Id],
-- 				[parent_id],
-- 				[Name]
-- 			FROM
-- 				[dbo].[KnowledgeBaseStates]
-- 			WHERE isnull(is_visible,0) = 1
-- 			AND #filter_columns# /*[parent_id] is null*/
-- 		),
-- 		[Child_data] AS (
-- 			SELECT
-- 				[Id],
-- 				[parent_id],
-- 				[Name]
-- 			FROM
-- 				[Parent_data]
-- 			UNION
-- 			ALL
-- 			SELECT
-- 				[Id],
-- 				[parent_id],
-- 				[Name]
-- 			FROM
-- 				[dbo].[KnowledgeBaseStates]
-- 			WHERE
-- 				EXISTS(
-- 					SELECT
-- 						1
-- 					FROM
-- 						[Parent_data]
-- 					WHERE
-- 						[Parent_data].[Id] = [KnowledgeBaseStates].[parent_id]
-- 				)
-- 		)
-- 	SELECT
-- 		[Id],
-- 		[parent_id],
-- 		[Name]
-- 	FROM
-- 		[Child_data]
-- END
-- ELSE 
-- BEGIN 
-- WITH [Parent_data] AS (
-- 	SELECT
-- 		[Id],
-- 		[parent_id],
-- 		[Name]
-- 	FROM [dbo].[KnowledgeBaseStates]
-- 	WHERE isnull(is_visible,0) = 1
-- 		AND #filter_columns# /*[parent_id] is null*/
-- ),
-- [Child_data] AS (
-- 	SELECT
-- 		[Id],
-- 		[parent_id],
-- 		[Name]
-- 	FROM
-- 		[Parent_data]
-- 	UNION
-- 	ALL
-- 	SELECT
-- 		[Id],
-- 		[parent_id],
-- 		[Name]
-- 	FROM
-- 		[dbo].[KnowledgeBaseStates]
-- 	WHERE
-- 		[KnowledgeBaseStates].Id IN (
-- 			SELECT
-- 				Id
-- 			FROM
-- 				[Parent_data]
-- 			WHERE
-- 				[Parent_data].[Id] = [KnowledgeBaseStates].[parent_id]
-- 		)
-- )
-- SELECT
-- 	[Id],
-- 	parent_id,
-- 	[Name]
-- FROM
-- 	[Child_data]
-- END

declare @KnowledgeBaseId int = (SELECT top 1 [Id] FROM [dbo].[KnowledgeBaseStates] where #filter_columns#)

if @KnowledgeBaseId = 1
begin
		with [Parent_KnowledgeBaseStates] as (
		   SELECT 
				 [Id]
				 ,[Name]
				 ,[parent_id] as [ParentId]
				 ,case when id = 1 then 1 else 0 end [has_child]
		    FROM [dbo].[KnowledgeBaseStates]
			where isnull(is_visible,0) = 1
			and #filter_columns#
		),
		[Child_question_types] as (
			SELECT 
			   [Id]
		      ,[ParentId]
		      ,[Name]
		      ,case when id = 1 then 1 else 0 end [has_child]
		    FROM [Parent_KnowledgeBaseStates]
		    
		    UNION all
		    
		    SELECT
		         [Id]
		         ,[parent_id] as [ParentId]
				 ,[Name]
				 ,case when id = 1 then 1 else 0 end [has_child]
		    from [dbo].[KnowledgeBaseStates]
		    where isnull(is_visible,0) = 1 and exists(select * from [Parent_KnowledgeBaseStates] where [Parent_KnowledgeBaseStates].[Id] = [KnowledgeBaseStates].[parent_id])
		)
		
		
		select 
		   [Id]
		      ,[ParentId]
		      ,[Name]
		      ,case when id = 1 then 1 else 0 end [has_child]
		from [Child_question_types]

end
else
begin
		with [Parent_KnowledgeBaseStates] as (
		   SELECT 
				 [Id]
				 ,[Name]
				 ,[parent_id] as [ParentId]
				 ,case when id = 1 then 1 else 0 end [has_child]
		    FROM [dbo].[KnowledgeBaseStates]
			where isnull(is_visible,0) = 1
			and #filter_columns#
		),
		[Child_question_types] as (
			SELECT 
			   [Id]
		      ,[ParentId]
		      ,[Name]
		      ,case when id = 1 then 1 else 0 end [has_child]
		    FROM [Parent_KnowledgeBaseStates]
		    
		    UNION all
		    
		    SELECT 
				 [Id]
				 ,[parent_id] as [ParentId]
				 ,[Name]
				 ,case when id = 1 then 1 else 0 end [has_child]
		    FROM [dbo].[KnowledgeBaseStates]
			where isnull(is_visible,0) = 1
		    and [KnowledgeBaseStates].Id in (select Id from [Parent_KnowledgeBaseStates] where [Parent_KnowledgeBaseStates].[Id] = [KnowledgeBaseStates].[parent_id])
		)
		
		
		select 
		   [Id]
		      ,[ParentId]
		      ,[Name]
		      ,case when id = 1 then 1 else 0 end [has_child]
		from [Child_question_types]
end

