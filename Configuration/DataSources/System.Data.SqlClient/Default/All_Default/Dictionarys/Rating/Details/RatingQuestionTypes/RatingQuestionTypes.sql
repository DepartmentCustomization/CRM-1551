-- declare @RatingId int = 1;

Select 
qt.Id,
qt.[name]

from Rating r 
join QuestionTypeInRating qtr on r.Id = qtr.Rating_id
join QuestionTypes qt on qt.Id = qtr.QuestionType_id
where r.Id = @RatingId
and #filter_columns#
    #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only