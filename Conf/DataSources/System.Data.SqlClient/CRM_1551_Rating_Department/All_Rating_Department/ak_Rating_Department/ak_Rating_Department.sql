--  declare @Date datetime ='2019-12-03';

  SELECT [Organization_Id] Id
      ,[Organization_name]
      ,[Count_rmz] [ReestrZKMM]
      ,[Count_rpz] [ReestrZKPM]
      ,[Count_rzz] [ReestrZNZ]
      ,[Count_rzr] [ReestrZNVR]
      ,[Count_rzvv] [ReestrZVV]
      ,[Count_rzvnv] [ReestrZVNV]
      ,[Count_rzvp] [ReestrZVP]
      ,[Vids_vz]
      --,[StateToDate]
  FROM [dbo].[Department_ResultTable]  
  WHERE CONVERT(DATE, [StateToDate])=CONVERT(DATE, @Date);