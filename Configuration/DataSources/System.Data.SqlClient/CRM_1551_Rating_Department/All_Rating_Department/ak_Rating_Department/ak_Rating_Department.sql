--  declare @Date datetime ='2019-12-03';

  select [Organization_Id] Id
      ,[Organization_name]
      ,[Count_rmz]
      ,[Count_rpz]
      ,[Count_rzz]
      ,[Count_rzr]
      ,[Count_rzvv]
      ,[Count_rzvnv]
      ,[Count_rzvp]
      ,[Vids_vz]
      --,[StateToDate]
  from [Department_ResultTable]
  where CONVERT(date, [StateToDate])=CONVERT(date, @Date)