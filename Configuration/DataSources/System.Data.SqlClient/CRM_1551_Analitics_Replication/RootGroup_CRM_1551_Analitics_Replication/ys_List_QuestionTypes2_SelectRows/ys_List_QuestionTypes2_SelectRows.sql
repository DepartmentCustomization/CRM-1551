select [Id] ,
       [name] as [Name] ,
       isnull([question_type_id],0) as [ParentId]
from [dbo].[QuestionTypes]  where active = 1
and Id != 13339