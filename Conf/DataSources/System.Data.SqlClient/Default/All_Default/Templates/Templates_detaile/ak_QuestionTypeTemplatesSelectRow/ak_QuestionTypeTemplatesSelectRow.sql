
select qtt.Id, t.name templates_name, t.Id templates_Id, qtt.question_type_id
from [QuestionTypeTemplates] qtt
inner join [Templates] t on qtt.template_id=t.Id
where qtt.Id=@Id