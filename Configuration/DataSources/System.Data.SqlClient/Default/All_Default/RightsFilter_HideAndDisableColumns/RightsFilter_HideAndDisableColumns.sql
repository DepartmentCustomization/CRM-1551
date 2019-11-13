--declare @programuser_id nvarchar(128) = N'45d2f527-bd52-47ef-bc6c-4e0943d8e333'
declare @form nvarchar(128) = N'Assignment'


select [PosibilitiesForRoles].colunmcode,  [RulestypeforRights].code
 FROM [dbo].[PosibilitiesForRoles]
 left join [dbo].[RulesforRights] on [RulesforRights].id = [PosibilitiesForRoles].RulesforRightsId
 left join [dbo].[RulestypeforRights] on [RulestypeforRights].id = [RulesforRights].ruletype_id
where [PosibilitiesForRoles].role_id in (SELECT 
      [role_id]
  FROM [dbo].[Positions]
  where programuser_id = @programuser_id)
and RulesforRightsId in (SELECT [id]
  FROM [dbo].[RulesforRights]
  where formcode = @form)
  and  [PosibilitiesForRoles].colunmcode not in (N'complaintype', N'transitionassignmentstate')
