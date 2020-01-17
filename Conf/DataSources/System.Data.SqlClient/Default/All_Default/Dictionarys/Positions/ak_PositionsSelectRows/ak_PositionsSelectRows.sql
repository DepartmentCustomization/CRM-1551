SELECT [Id]
      ,[parent_id]
      ,[position_code]
      ,[position]
      ,[phone_number]
      ,[address]
      ,[name]
      ,[active]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
  FROM [CRM_1551_Analitics].[dbo].[Positions]
   where #filter_columns#
   order by id 
  --#sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only