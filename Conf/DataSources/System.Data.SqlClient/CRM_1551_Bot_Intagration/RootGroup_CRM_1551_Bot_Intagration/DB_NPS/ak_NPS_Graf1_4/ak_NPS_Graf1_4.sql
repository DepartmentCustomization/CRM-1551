SELECT
    grade Id,
    Grade,
    COUNT(grade) Count_people
FROM [dbo].[ExecutorEvaluations]
WHERE CONVERT(DATE, [answer_date]) BETWEEN @date_from AND @date_to
    AND bot_poll_item_id = 27
GROUP BY grade