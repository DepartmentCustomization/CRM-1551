

--declare @Id int = 2809572
------------

declare @AppealId int = (select top 1 [Appeals].Id 
						 from [Assignments]
						 inner join [Questions] on [Assignments].question_id=[Questions].Id
						 inner join [Appeals] on [Questions].appeal_id=[Appeals].Id
						 where [Assignments].Id=@Id)


delete from [dbo].[AssignmentConsDocFiles] where [assignment_cons_doc_id] in (select [Id] from [dbo].[AssignmentConsDocuments] where [assignment_сons_id] in (select [Id] from [dbo].[AssignmentConsiderations] where assignment_id in (select [Id] from [dbo].[Assignments] where [question_id] in (select [Id] from [dbo].[Questions] where [appeal_id] = @AppealId))))
delete from [dbo].[AssignmentConsDocuments] where [assignment_сons_id] in (select [Id] from [dbo].[AssignmentConsiderations] where assignment_id in (select [Id] from [dbo].[Assignments] where [question_id] in (select [Id] from [dbo].[Questions] where [appeal_id] = @AppealId)))
delete from [dbo].[Consultations] where [appeal_id] = @AppealId
delete from [dbo].[AssignmentRevisions] where [assignment_consideration_іd] in (select [Id] from [dbo].[AssignmentConsiderations] where assignment_id in (select [Id] from [dbo].[Assignments] where [question_id] in (select [Id] from [dbo].[Questions] where [appeal_id] = @AppealId)))
delete from [dbo].[AssignmentConsiderations] where assignment_id in (select [Id] from [dbo].[Assignments] where [question_id] in (select [Id] from [dbo].[Questions] where [appeal_id] = @AppealId))
delete from [dbo].[Assignments] where [question_id] in (select [Id] from [dbo].[Questions] where [appeal_id] = @AppealId)
delete from [dbo].[Assignment_History] where [assignment_id] in (select [Id] from [dbo].[Assignments] where [question_id] in (select [Id] from [dbo].[Questions] where [appeal_id] = @AppealId))
delete from [dbo].[AssignmentDetailHistory] where [Assignment_id] in (select [Id] from [dbo].[Assignments] where [question_id] in (select [Id] from [dbo].[Questions] where [appeal_id] = @AppealId))
delete from [dbo].[QuestionDocFiles] where [question_id] in (select [Id] from [dbo].[Questions] where [appeal_id] = @AppealId)
delete from [dbo].[Questions] where [appeal_id] = @AppealId
delete from [dbo].[Question_History] where [appeal_id] = @AppealId
delete from [dbo].[Appeals] where [Id] = @AppealId



delete from [CRM_1551_Site_Integration].[dbo].[AppealFromSiteFiles] where [AppealFromSiteId]  in (select [Id] from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] where [Appeal_Id] = @AppealId)
delete from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite_History] where [AppealsFromSiteId] in (select [Id] from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] where [Appeal_Id] = @AppealId)
delete from [CRM_1551_Site_Integration].[dbo].[AppealsFromSite] where [Appeal_Id] = @AppealId

-- --declare @Id int = 2968244;
-- declare @table_del table (
-- Assignment_Id int, 
-- Questions_Id int, 
-- Appeals_Id int,
-- Assignment_consideration_id int
-- )



-- insert into @table_del
-- (
-- Assignment_Id, 
-- Questions_Id, 
-- Appeals_Id,
-- Assignment_consideration_id
-- )

-- select [Assignments].Id Assignment_Id, [Questions].Id Questions_Id, [Appeals].Id Appeals_Id,
-- [Assignments].current_assignment_consideration_id [Assignment_consideration_id]
-- from [Assignments]
-- inner join [Questions] on [Assignments].question_id=[Questions].Id
-- inner join [Appeals] on [Questions].appeal_id=[Appeals].Id
-- --left join [AssignmentConsiderations] on [Assignments].Id=[AssignmentConsiderations].assignment_id
-- where [Assignments].Id=@Id
-- union
-- select null, null, null, Id 
-- from [AssignmentConsiderations]
-- where [AssignmentConsiderations].assignment_id=@Id



-- delete
-- from [Question_History]
-- where [question_id] in (select distinct Questions_Id from @table_del)

-- delete
-- from [Assignment_History]
-- where assignment_id in (select distinct Assignment_Id from @table_del)

-- delete
-- from [AssignmentRevisions]
-- where assignment_consideration_іd in (select distinct [Assignment_consideration_id] from @table_del)

-- -- delete
-- -- from [QuestionDocuments]
-- -- where question_id in (select distinct Questions_Id from @table_del)

-- delete
-- from [QuestionDocFiles]
-- where question_id in (select distinct Questions_Id from @table_del)


-- delete
-- from [AssignmentConsDocuments]
-- where assignment_сons_id in (select distinct [Assignment_consideration_id] from @table_del)

-- delete
-- from [AssignmentConsDocFiles]
-- where assignment_cons_doc_id in
-- (
-- select Id from [AssignmentConsDocuments]
-- where assignment_сons_id in (select distinct [Assignment_consideration_id] from @table_del))

-- delete
-- from [AssignmentConsiderations]
-- where Id in (select distinct [Assignment_consideration_id] from @table_del)


-- delete
-- from [Appeals]
-- where Id in (select distinct Appeals_Id from @table_del)

-- delete
-- from [Assignments]
-- where Id in (select distinct Assignment_Id from @table_del)

-- delete
-- from [Questions]
-- where Id in (select distinct Questions_Id from @table_del)

