--declare @position_id int =1;

--declare @organizations_id int =1;

  --id, name, phone_number, position, active

  select [Positions].Id, isnull([User].FirstName, N'')+N' '+isnull([User].LastName, N'')+N' '+isnull([User].Patronymic,N'') name,
  [User].PhoneNumber, [Positions].position, [Positions].active,
  [Positions].organizations_id organization_id, [Positions].role_id,
  [Positions].programuser_id
  from [CRM_1551_Analitics].[dbo].[Positions]
  left join [CRM_1551_System].[dbo].[User] on [Positions].programuser_id=[User].UserId
  where [Positions].organizations_id=@organization_id
  and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only


  --id, name, phone_number, position, active

--   select [Positions].Id, isnull([User].FirstName, N'')+N' '+isnull([User].LastName, N'')+N' '+isnull([User].Patronymic,N'') name,
--   [User].PhoneNumber, [Positions].position, [Positions].active,
--   [Positions].organizations_id organization_id, [Positions].role_id,
--   [Positions].programuser_id
--   from [CRM_1551_Analitics].[dbo].[Positions]
--   left join [CRM_1551_System].[dbo].[User] on [Positions].programuser_id=[User].UserId
--   where [Positions].Id=@position_id
--   and #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only

-- select id, name, phone_number, position, active
--   from [CRM_1551_Analitics].[dbo].[Workers]
--   where [organization_id]=@organization_id
--   and #filter_columns#
--   #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 