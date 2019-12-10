select [PersonExecutorChooseObjects].Id, [Districts].name District_name, [Objects].name [Object_name]
  from [PersonExecutorChooseObjects]
  inner join [Objects] on [PersonExecutorChooseObjects].object_id=[Objects].Id
  left join [Buildings] on [Objects].builbing_id=[Buildings].Id
  left join [Districts] on [Buildings].district_id=[Districts].Id
  where [PersonExecutorChooseObjects].person_executor_choose_id=@person_executor_choose_id
  and #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
