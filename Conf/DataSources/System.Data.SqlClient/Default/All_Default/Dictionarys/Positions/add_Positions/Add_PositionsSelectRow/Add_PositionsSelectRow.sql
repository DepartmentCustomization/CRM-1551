SELECT p.[Id], p.[position], p.[organizations_id] [organization_id], p.[active], @Id [position_id],
o.[short_name]
  FROM [dbo].[Positions] p
  LEFT JOIN [dbo].[Organizations] o ON p.organizations_id=o.Id
  WHERE p.Id=@Id;