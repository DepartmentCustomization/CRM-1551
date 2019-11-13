
--declare @question_type_id int =11;
--declare @user_id nvarchar(300)=N'02ece542-2d75-479d-adad-fd333d09604d';


 declare @QuestionTypes table(Id int);

 declare @QuestionTypeId int = @question_type_id;


 declare @IdT table (Id int);

 -- НАХОДИМ ИД ОРГАНИЗАЦИЙ ГДЕ ИД И ПАРЕНТЫ ВЫБРАНОЙ И СРАЗУ ЗАЛИВАЕМ
 insert into @IdT(Id)
 select Id from [CRM_1551_Analitics].[dbo].[QuestionTypes] 
 where (Id=@QuestionTypeId or [question_type_id]=@QuestionTypeId) and Id not in (select Id from @IdT)

 --  НАХОДИМ ПАРЕНТЫ ОРГ, КОТОРЫХ ЗАЛИЛИ, <-- нужен цыкл
 while (select count(id) from (select Id from [CRM_1551_Analitics].[dbo].[QuestionTypes]
 where [question_type_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT)) q)!=0
 begin

 insert into @IdT (Id)
 select Id from [CRM_1551_Analitics].[dbo].[QuestionTypes]
 where [question_type_id] in (select Id from @IdT) --or Id in (select Id from @IdT)
 and Id not in (select Id from @IdT)
 end 

 insert into @QuestionTypes (Id)
 select Id from @IdT;

 select qt.Id, QuestionTypes.Name
 from @QuestionTypes qt
 inner join QuestionTypes on qt.Id=QuestionTypes.Id
  where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
