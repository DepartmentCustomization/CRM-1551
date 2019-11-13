SELECT [Id]
      ,[name]
  FROM [dbo].[AnswerTypes]
  where Id = (case 
	when @Id = 1 then 2
	when @Id = 2 then 4
	when @Id = 3 then 5
	when @Id = 4 then 3
	when @Id = 5 then 4
	else 1 end
  )




-- SELECT [Id]
--       ,[name]
--   FROM [dbo].[AnswerTypes]
--   where Id = @Id