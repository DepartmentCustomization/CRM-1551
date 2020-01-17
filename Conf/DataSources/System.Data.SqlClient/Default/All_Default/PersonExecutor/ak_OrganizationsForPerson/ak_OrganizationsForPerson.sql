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
         INNER JOIN cte1 curr ON tp.[parent_organization_id] = curr.Id )
SELECT Id, Name 
FROM    cte1
where 
  #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
