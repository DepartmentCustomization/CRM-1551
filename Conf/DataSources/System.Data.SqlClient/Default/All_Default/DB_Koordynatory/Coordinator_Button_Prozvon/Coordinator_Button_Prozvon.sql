 --declare @ids nvarchar(200)=N'1,2,3';
--declare @user nvarchar(128)=N'Вася';
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
inner join [AssignmentResolutions] on [Assignments].AssignmentResolutionsId=[AssignmentResolutions].Id
inner join [AssignmentStates] on [Assignments].assignment_state_id=[AssignmentStates].Id
inner join [AssignmentResults] on [Assignments].AssignmentResultsId=[AssignmentResults].Id
where
[AssignmentTypes].code<>N'ToAttention' and [AssignmentStates].code=N'OnCheck' and 
[AssignmentResults].code=N'WasExplained ' and [AssignmentResolutions].code=N'Requires1551ChecksByTheController'
and [Assignments].Id in (select Id from @table t)


--select * from @tabIds


  --declare @t nvarchar(max)=N'

  update [CRM_1551_Analitics].[dbo].[Assignments]
  set
   assignment_state_id=3
  ,[AssignmentResultsId]=4 
  ,[AssignmentResolutionsId]=4
  ,edit_date = GETUTCDATE()
  ,user_edit_id = @user
  ,[LogUpdated_Query] = N'Coordinator_Button_Prozvon_Row11'
  where Id in (select Id from @tabIds)
  
  
  update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  set 
   [assignment_result_id]=4 
  ,[assignment_resolution_id]=4 
  ,edit_date = GETUTCDATE()
  ,user_edit_id = @user
  where Id in ( select current_assignment_consideration_id from dbo.Assignments where Id in (select Id from @tabIds) )

  update dbo.AssignmentRevisions
    set
     assignment_resolution_id = 4
    ,control_result_id = NULL
    ,control_date = NULL
    ,control_type_id = 2
    ,edit_date = GETUTCDATE()
    ,user_edit_id = @user
  where assignment_consideration_іd in (SELECT current_assignment_consideration_id FROM dbo.Assignments WHERE Id IN (select Id from @tabIds) )

 
 
 -- declare @ids nvarchar(200)=N'1,2,3';
  --declare @user nvarchar(200)=N'Вася'
  -- declare @t nvarchar(max)=N'

  -- update [CRM_1551_Analitics].[dbo].[Assignments]
  -- set
  --  assignment_state_id=3
  -- ,[AssignmentResultsId]=4 
  -- ,[AssignmentResolutionsId]=4
  -- ,edit_date = GETUTCDATE()
  -- ,user_edit_id = N'''+ @user + N'''
  -- ,[LogUpdated_Query] = N''Coordinator_Button_Prozvon_Row11'''+N'
  -- where Id in ( '+ @ids+N')'+
  -- N'
  
  -- update [CRM_1551_Analitics].[dbo].[AssignmentConsiderations]
  -- set 
  --  [assignment_result_id]=4 
  -- ,[assignment_resolution_id]=4 
  -- ,edit_date = GETUTCDATE()
  -- ,user_edit_id = N'''+ @user + N'''
  -- where Id in ( select current_assignment_consideration_id from dbo.Assignments where Id in ('+@Ids+N') )

  -- update dbo.AssignmentRevisions
  --   set
  --    assignment_resolution_id = 4
  --   ,control_result_id = NULL
  --   ,control_type_id = 2
  --   ,edit_date = GETUTCDATE()
  --   ,user_edit_id = N'''+ @user + N'''
  -- where assignment_consideration_іd in (SELECT current_assignment_consideration_id FROM dbo.Assignments WHERE Id IN ('+@Ids+N') )

  -- '
  
  -- --select @t
  -- exec (@t)

