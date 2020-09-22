UPDATE [dbo].[SearchTableFilters]
  SET [filters]=@filters
  WHERE Id=@Id AND [user_id]=@user_id