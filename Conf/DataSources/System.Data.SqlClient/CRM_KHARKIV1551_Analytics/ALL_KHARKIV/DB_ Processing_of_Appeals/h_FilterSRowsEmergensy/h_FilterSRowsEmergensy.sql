select f.Id, [Emergensy].Id emergensy_id, [Emergensy].emergensy_name
  from [dbo].[FiltersForControler] f
  inner join [dbo].[Emergensy] on f.emergensy_id=[Emergensy].Id
  where f.user_id=@user_id