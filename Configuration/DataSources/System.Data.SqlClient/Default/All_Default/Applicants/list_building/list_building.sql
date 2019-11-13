SELECT 
     [Buildings].Id,
     --,StreetTypes.shortname+N' '+Streets.name+N' '+rtrim(Buildings.number)+isnull(Buildings.letter, N'') as name
	concat(StreetTypes.shortname, N' ', Streets.name, N' ', Buildings.number,isnull(Buildings.letter, null)) as name

/*	case when StreetTypes.shortname is not null then StreetTypes.shortname+N' ' else N'' end+ 
    case when Streets.name is not null then Streets.name+N' ' else N'' end+ 
    case when Buildings.number is not null then ltrim(Buildings.number)+N' ' else N'' end+
    case when Buildings.letter is not null then Buildings.letter else N'' end as name
*/

  FROM [dbo].[Buildings]
	 left join Streets on Streets.Id = Buildings.street_id
	 left join StreetTypes on StreetTypes.Id = Streets.street_type_id
	 where #filter_columns#
     #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only