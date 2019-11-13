select isnull(Organization_is, 0) as Organization_is,	isnull(Object_is, 0) as Object_is
from QuestionTypes
where Id = @question_type_id