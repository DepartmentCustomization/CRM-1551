INSERT INTO
  [CRM_1551_Analitics].[dbo].[ExecutorInRoleForObject] (
    [district_id],
    [executor_role_id],
    [executor_id]
  )
SELECT
  @district_id,
  @executor_role_id,
  @executor_id 
  ;