/*declare @dateFrom date;
declare @dateTo date;
declare @user_id nvarchar(128);
declare @is_worked bit;
*/
if @is_worked is not null
begin

select Id, [№ звернення] [EnterNumber], [Створено] [RegistrationDate], [Заявник] [Applicant], [Адреса] [Address], [Зміст] [Content], [Питання] QuestionNumber
from [Звернення УГЛ]
where convert(date, [Створено]) between @dateFrom and @dateTo
and #filter_columns# /*[Опрацював]=@user_id*/
and [Опрацьовано]= @is_worked 

-- #sort_columns#
--  offset @pageOffsetRows rows fetch next @pageLimitRows rows only

end

if @is_worked is null
begin
select Id, [№ звернення] [EnterNumber], [Створено] [RegistrationDate], [Заявник] [Applicant], [Адреса] [Address], [Зміст] [Content], [Питання] QuestionNumber
from [Звернення УГЛ]
where convert(date, [Створено]) between @dateFrom and @dateTo
and #filter_columns# /*[Опрацював]=@user_id*/
end