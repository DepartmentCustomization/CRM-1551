UPDATE [dbo].[SearchTableFilters]
  SET [filter_name]=@filter_name
  WHERE Id=@Id AND [user_id]=@user_id