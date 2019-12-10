

/*
--declare @user_Id nvarchar(128)=N'dc61a839-2cbc-4822-bfb5-5ca157487ced';

with
  cte1 -- все подчиненные 3 и 3
   AS ( SELECT   t.Id, [short_name] Name
                 --[parent_organization_id] ParentId
         FROM     [Organizations] t
		 inner join [Positions] on t.Id=[Positions].organizations_id
         WHERE    [Positions].[programuser_id]=@user_id
         UNION ALL
         SELECT   tp.Id, tp.[short_name]
                  --tp.[parent_organization_id] ParentId
         FROM     [Organizations] tp 
         INNER JOIN cte1 curr ON tp.[parent_organization_id] = curr.Id ),

	main as
	(
	select p.Id, [Organizations].Id organization_Id, [Organizations].short_name Organization_name, p.name PersonExecutorChoose_name, [Positions].position+N' ('+isnull([Positions].name,0)+N')' Positions_name,

  N'Типів '+ltrim(count(distinct [PersonExecutorChooseQT].Id))+N':'+stuff((select N', '+[QuestionTypes].name
  from [PersonExecutorChooseQT]
  inner join [QuestionTypes] on [PersonExecutorChooseQT].question_type_id=[QuestionTypes].Id
  where [PersonExecutorChooseQT].person_executor_choose_id=p.Id
  for xml path('')),1,2,N'') questions_types

  ,N'Об`єктів '+ltrim(count(distinct [PersonExecutorChooseObjects].Id))+N':'+stuff((select N', '+isnull([Objects].name,N'')
  from [PersonExecutorChooseObjects]
  inner join [Objects] on [PersonExecutorChooseObjects].object_id=[Objects].Id
  where [PersonExecutorChooseObjects].person_executor_choose_id=p.Id
  for xml path ('')), 1,2, N'') [objects]

  from [PersonExecutorChoose] p
  left join [Organizations] on p.organization_id=[Organizations].Id
  left join [Positions] on p.position_id=[Positions].Id
  left join [PersonExecutorChooseQT] on p.Id=[PersonExecutorChooseQT].person_executor_choose_id
  left join [PersonExecutorChooseObjects] on p.Id=[PersonExecutorChooseObjects].person_executor_choose_id
  group by p.Id, [Organizations].Id, [Organizations].short_name , p.name , [Positions].position+N' ('+isnull([Positions].name,0)+N')'
	)

SELECT main.Id, main.Organization_name, main.Positions_name, main.PersonExecutorChoose_name, main.questions_types, main.[objects] 
FROM main inner join cte1 on main.organization_Id=cte1.Id
*/



select Id, Organization_name, Positions_name, PersonExecutorChoose_name, questions_types, [objects]

from(
select p.Id, [Organizations].short_name Organization_name, p.name PersonExecutorChoose_name, [Positions].position+N' ('+isnull([Positions].name,0)+N')' Positions_name,

  N'Типів '+ltrim(count(distinct [PersonExecutorChooseQT].Id))+N':'+stuff((select N', '+[QuestionTypes].name
  from [PersonExecutorChooseQT]
  inner join [QuestionTypes] on [PersonExecutorChooseQT].question_type_id=[QuestionTypes].Id
  where [PersonExecutorChooseQT].person_executor_choose_id=p.Id
  for xml path('')),1,2,N'') questions_types

  ,N'Об`єктів '+ltrim(count(distinct [PersonExecutorChooseObjects].Id))+N':'+stuff((select N', '+isnull([Objects].name,N'')
  from [PersonExecutorChooseObjects]
  inner join [Objects] on [PersonExecutorChooseObjects].object_id=[Objects].Id
  where [PersonExecutorChooseObjects].person_executor_choose_id=p.Id
  for xml path ('')), 1,2, N'') [objects]

  from [PersonExecutorChoose] p
  left join [Organizations] on p.organization_id=[Organizations].Id
  left join [Positions] on p.position_id=[Positions].Id
  left join [PersonExecutorChooseQT] on p.Id=[PersonExecutorChooseQT].person_executor_choose_id
  left join [PersonExecutorChooseObjects] on p.Id=[PersonExecutorChooseObjects].person_executor_choose_id
  group by p.Id, [Organizations].short_name , p.name , [Positions].position+N' ('+isnull([Positions].name,0)+N')'
) t



where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only

