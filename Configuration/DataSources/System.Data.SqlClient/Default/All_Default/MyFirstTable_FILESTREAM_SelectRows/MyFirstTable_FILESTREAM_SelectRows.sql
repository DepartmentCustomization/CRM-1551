SELECT [Id],
       [GUID],
       [File],
       [Name]
  FROM [dbo].[MyFirstTable_FILESTREAM]
  WHERE 
    #filter_columns#
    #sort_columns#
    offset @pageOffsetRows rows fetch next @pageLimitRows rows only