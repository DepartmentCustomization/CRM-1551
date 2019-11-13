select *
from
(
select 1 Id, N'email' Sourceincome, 100 QuestionNumber, N'просто' TypeQuestion, N'Вася' Applicant, N'дом' PlaceProblem, N'Степа' Performer
union all
select 2 Id, N'transport' Sourceincome, 100 QuestionNumber, N'не просто' TypeQuestion, N'Федя' Applicant, N'трасса' PlaceProblem, N'Степа' Performer
union all
select 3 Id, N'email' Sourceincome, 100 QuestionNumber, N'сложно' TypeQuestion, N'Катя' Applicant, N'дом' PlaceProblem, N'Степа' Performer
union all
select 4 Id, N'letter' Sourceincome, 100 QuestionNumber, N'просто' TypeQuestion, N'Иван' Applicant, N'дом' PlaceProblem, N'Петя' Performer
) a
 /*where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only
 */