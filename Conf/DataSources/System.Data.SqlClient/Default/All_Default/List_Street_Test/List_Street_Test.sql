SELECT top 5 [Streets].[Id]
      ,concat(StreetTypes.shortname,' ', [Streets].[name]) as name
	  --,[Streets].[name]
  FROM [dbo].[Streets]
	left join StreetTypes on StreetTypes.Id = Streets.street_type_id
	where concat(StreetTypes.shortname,' ', [Streets].[name]) like N'%'+replace(@input_text,N' ',N'%')+'%'

    /*and 
    #filter_columns#
     #sort_columns#*/
    order by 2 
    /*offset @pageOffsetRows rows fetch next @pageLimitRows rows only*/