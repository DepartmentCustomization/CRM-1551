
--declare @user_id nvarchar(300)=N'Вася';
--declare @Ids nvarchar(max) = N'1,2,3';

--расспарсивание @ids в таблицу начало

-- наша входная строка с айдишниками
declare @input_str nvarchar(max) = @ids+N','
-- создаем таблицу в которую будем
-- записывать наши айдишники
declare @table table (id int)
-- создаем переменную, хранящую разделитель
declare @delimeter nvarchar(1) = ','
-- определяем позицию первого разделителя
declare @pos int = charindex(@delimeter,@input_str)
-- создаем переменную для хранения
-- одного айдишника
declare @id nvarchar(10)
while (@pos != 0)
begin
    -- получаем айдишник
    set @id = SUBSTRING(@input_str, 1, @pos-1)
    -- записываем в таблицу
    insert into @table (id) values(cast(@id as int))
    -- сокращаем исходную строку на
    -- размер полученного айдишника
    -- и разделителя
    set @input_str = SUBSTRING(@input_str, @pos+1, LEN(@input_str))
    -- определяем позицию след. разделителя
    set @pos = CHARINDEX(@delimeter,@input_str)
end

--select * from @table

--расспарсивание @ids в таблицу конец


declare @tabIds table (Id int)

--[AssignmentTypes].code<>N''ToAttention'' and [AssignmentStates].code=N''OnCheck'' and [AssignmentResults].code=N''WasExplained '' and [AssignmentResolutions].code=N''Requires1551ChecksByTheController''
insert into @tabIds (Id)

select [Assignments].Id
from [Assignments]
inner join [AssignmentTypes] on [Assignments].assignment_type_id=[AssignmentTypes].Id
inner join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
inner join [AssignmentResults] on [Assignments].AssignmentResultsId=[AssignmentResults].Id
where


 (([AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'Registered' and [AssignmentResults].[name]=N'Очікує прийому в роботу') 
 or ([AssignmentResults].code=N'ReturnedToTheArtist' and [AssignmentStates].code=N'Registered'))

and [Assignments].Id in (select Id from @table t)


--select Id from @tabIds


  update [CRM_1551_Analitics].[dbo].[Assignments]
  set [user_edit_id]=@user_id,
  edit_date= GETUTCDATE(),
  assignment_state_id=2,
  [AssignmentResultsId]=9,
  [AssignmentResolutionsId]=null,
  [LogUpdated_Query] = N'Button_Nadiishlo_VzyatyVRobotu_Row12'
  where id in (select Id from @tabIds)
  
  
  update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  set [assignment_result_id]=9,
  [assignment_resolution_id]=null,
  [user_edit_id]=@user_id,
  edit_date= GETUTCDATE()
--   where [assignment_id] in ('+@Ids+N')
 where Id in ( select current_assignment_consideration_id from Assignments where Id in (select Id from @tabIds) )

-- declare @exec nvarchar(max);
--   --declare @user_id nvarchar(300)=N'Вася';
--   --declare @Ids nvarchar(max) = N'1,2,3';

--   set @exec= N'
--   update [CRM_1551_Analitics].[dbo].[Assignments]
--   set [user_edit_id]=N'''+@user_id+N''',
--   edit_date= GETUTCDATE(),
--   assignment_state_id=2,
--   [AssignmentResultsId]=9,
--   [AssignmentResolutionsId]=null,
--   [LogUpdated_Query] = N''Button_Nadiishlo_VzyatyVRobotu_Row12'''+N'
--   where id in ('+@Ids+N')
  
  
--   update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
--   set [assignment_result_id]=9,
--   [assignment_resolution_id]=null,
--   [user_edit_id]=N'''+@user_id+N''',
--   edit_date= GETUTCDATE()
-- --   where [assignment_id] in ('+@Ids+N')
--  where Id in ( select current_assignment_consideration_id from Assignments where Id in ('+@Ids+N') )

--   '

--   exec (@exec)