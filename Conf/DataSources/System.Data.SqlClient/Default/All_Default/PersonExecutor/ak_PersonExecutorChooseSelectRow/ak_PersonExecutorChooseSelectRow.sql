select [PersonExecutorChoose].Id, [Organizations].Id organization_id, [Positions].Id position_id,
   [Organizations].short_name organization_name, [Positions].position+N' ('+isnull([Positions].name,0)+N')' position_name, [PersonExecutorChoose].[name] 
	  from [PersonExecutorChoose]
	  inner join [Organizations] on [PersonExecutorChoose].organization_id=[Organizations].Id
	  inner join [Positions] on [PersonExecutorChoose].position_id=[Positions].Id
	  where [PersonExecutorChoose].Id=@Id