SELECT [priority], main, executor_role_level_id, priocessing_kind_id
			from RulesForExecutorRole 
			where rule_id = 3 and main = 1
			order by [priority]