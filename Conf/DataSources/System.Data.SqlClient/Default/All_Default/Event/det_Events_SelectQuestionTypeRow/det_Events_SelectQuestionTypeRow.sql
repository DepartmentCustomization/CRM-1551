select 
	eqt.Id
	,qt.name as qt_name
	,qt.Id as qt_id
	,eqt.is_hard_connection
	from EventQuestionsTypes eqt
	left join QuestionTypes as qt on qt.Id = eqt.question_type_id
	where eqt.id = @Id