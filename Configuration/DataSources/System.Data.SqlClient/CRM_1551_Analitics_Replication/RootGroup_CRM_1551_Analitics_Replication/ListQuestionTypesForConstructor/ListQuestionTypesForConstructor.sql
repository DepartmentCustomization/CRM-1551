
--declare @GroupQuestionId int ;

if @GroupQuestionId is null 
begin
	

	declare @sql nvarchar(max)  = N'select [QuestionTypes].Id, [QuestionTypes].[name] as [Name] from [CRM_1551_Analitics].[dbo].[QuestionTypes] where Id in (' 
								  + rtrim(stuff((select N','+QuestionTypes 
								    from QuestionTypesAndParent
								    where #filter_columns# /*ParentId*/
								    for xml path('')), 1,1,N''))+N')'
	exec sp_executesql @sql
end
else 
begin
	select [QuestionTypes].Id, [QuestionTypes].[name] as [Name]
	from QGroupIncludeQTypes
	inner join  [QuestionTypes] on [QuestionTypes].Id = QGroupIncludeQTypes.type_question_id
	where [group_question_id] = @GroupQuestionId
end



