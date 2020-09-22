INSERT INTO [dbo].[Rating_EtalonDaysToExecution]
  (
  [QuestionTypeId]
      ,[DateStart]
      ,[EtalonDaysToExecution]
      ,[EtalonDaysToExplain]
      ,[CreatedAt]
      ,[CreatedByUserId]
  )

  SELECT
  @QuestionTypes_Id [QuestionTypeId]
  ,CONVERT(DATE, @DateStart) [DateStart]
  ,@avg_EtalonDaysToExecution_change [EtalonDaysToExecution]
  ,@avg_EtalonDaysToExplain_change [EtalonDaysToExplain]
  ,GETUTCDATE() [CreatedAt]
  ,@user_id [CreatedByUserId];