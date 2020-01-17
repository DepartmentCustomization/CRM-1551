select [PersonExecutorChooseObjects].Id, [Districts].name district_name, [Objects].name [object_name],
[Districts].Id districts_Id, [Objects].Id object_Id, [PersonExecutorChooseObjects].[person_executor_choose_id]
  from [PersonExecutorChooseObjects]
  inner join [Objects] on [PersonExecutorChooseObjects].object_id=[Objects].Id
  left join [Buildings] on [Objects].builbing_id=[Buildings].Id
  left join [Districts] on [Buildings].district_id=[Districts].Id
  where [PersonExecutorChooseObjects].Id=@Id