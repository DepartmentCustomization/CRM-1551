/*
declare @CalcDate date = N'2019-10-16',
		@RatingId int = 1
*/

SELECT t2.[Id] as [RDAId]
      ,t2.[short_name] as [RDAName]
      ,t1.[OfThem_Registered] + t1.[OfThem_AtWork] as [Indicator]
  FROM [dbo].[Rating_ResultTable] as t1
  left join [CRM_1551_Analitics].[dbo].[Organizations] as t2 on t2.Id = t1.RDAId 
  where t1.[DateCalc] = @CalcDate
  and t1.[RatingId] = @RatingId