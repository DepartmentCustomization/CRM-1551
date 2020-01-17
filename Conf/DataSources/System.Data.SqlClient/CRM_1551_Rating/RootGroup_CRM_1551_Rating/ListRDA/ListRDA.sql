
select * from (
SELECT 0 as [Id], N'Усі РДА' as [Name]
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2000
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2001
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2002
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2003
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2004
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2005
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2006
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2007
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2008
union all
SELECT [Id], [short_name] as [Name] FROM [CRM_1551_Analitics].[dbo].[Organizations] where Id =  2009
) as t
  WHERE 
    #filter_columns#
    #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only