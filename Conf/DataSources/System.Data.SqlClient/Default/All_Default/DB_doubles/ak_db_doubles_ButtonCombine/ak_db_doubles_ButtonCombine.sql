/*
 declare @Ids nvarchar(300)=N'1490251,1490252'
 declare @true_applicant_id int =1490251;
 declare @user_id nvarchar(128)=N'Тестовый';
 declare @Id_table int=3;
 */

DECLARE @phone NVARCHAR(50) =(
      SELECT
            PhoneNumber
      FROM
            [dbo].[ApplicantDublicate]
      WHERE
            Id = @Id_table
);

-- наша входная строка с айдишниками
DECLARE @input_str NVARCHAR(max) = @Ids + N',';

-- создаем таблицу в которую будем
-- записывать наши айдишники
DECLARE @table_applicant TABLE (id INT); -- создаем переменную, хранящую разделитель
DECLARE @delimeter NVARCHAR(1) = ','; -- определяем позицию первого разделителя
DECLARE @pos INT = charindex(@delimeter, @input_str); -- создаем переменную для хранения
-- одного айдишника
DECLARE @id NVARCHAR(100);
WHILE (@pos != 0) 
BEGIN -- получаем айдишник
SET
      @id = SUBSTRING(@input_str, 1, @pos -1); -- записываем в таблицу
INSERT INTO
      @table_applicant (id)
VALUES
(CAST(@id AS INT)); 
      -- сокращаем исходную строку на
      -- размер полученного айдишника
      -- и разделителя
SET
      @input_str = SUBSTRING(@input_str, @pos + 1, LEN(@input_str)); 
      -- определяем позицию след. разделителя
SET
      @pos = CHARINDEX(@delimeter, @input_str);
END 
--select * from @table_applicant
-- обновить таблицу дубликатов 
/**/
UPDATE
      [dbo].[ApplicantDublicate] 
SET
      [IsDone] = 'true',
      [User_done_id] = @user_id,
      [Done_date] = getutcdate()
WHERE
      Id = @Id_table; 
      --сформировать таблицу истории
      -- апликант, номера телефона через запятую

DECLARE @table_phones TABLE (applicant_id INT, phones NVARCHAR(max));

INSERT INTO
      @table_phones (applicant_id, phones)
SELECT
      DISTINCT ap1.applicant_id,
      stuff(
            (
                  SELECT
                        DISTINCT N', ' + REPLACE(ap2.[phone_number], N'+38', N'')
                  FROM
                        [dbo].[ApplicantPhones] ap2
                  WHERE
                        ap2.applicant_id = ap1.applicant_id FOR XML PATH ('')
            ),
            1,
            2,
            N''
      ) phones
FROM
      [dbo].[ApplicantPhones] ap1
WHERE
      ap1.applicant_id IN (
            SELECT
                  Id
            FROM
                  @table_applicant
      ); 
      --select * from @table_phones
      -- табличка адресов заявителей, заявителей через запятую
      DECLARE @table_addresses TABLE (applicant_id INT, addresses NVARCHAR(MAX));

INSERT INTO
      @table_addresses (applicant_id, addresses)
SELECT
      DISTINCT la1.applicant_id,
      stuff(
            (
                  SELECT
                        N', Id:' + ltrim(la2.Id) + isnull(N', ' + st.shortname, N'') + isnull(N', ' + s.name, N'') + isnull(N', корпус ' + la2.house_block, N'') + isnull(N', парадне ' + ltrim(la2.entrance), N'') + isnull(N', квартира ' + la2.flat, N'')
                  FROM
                        [dbo].[LiveAddress] la2
                        INNER JOIN [dbo].[Buildings] b ON la2.building_id = b.Id
                        LEFT JOIN [dbo].[Streets] s ON b.street_id = s.Id
                        LEFT JOIN [dbo].[StreetTypes] st ON s.street_type_id = st.Id
                  WHERE
                        la2.applicant_id = la1.applicant_id FOR XML PATH('')
            ),
            1,
            2,
            N''
      ) addresses
FROM
      [dbo].[LiveAddress] la1
WHERE
      la1.applicant_id IN (
            SELECT
                  Id
            FROM
                  @table_applicant
      );

--select * from @table_addresses
--заполняется таблица для history
/**/
INSERT INTO
      [dbo].[ApplicantDublicateHistory] (
            [phone_number],
            [applicant_id],
            [full_name],
            [live_address],
            [birth_date],
            [birth_year],
            [social_state_id],
            [category_type_id],
            [true_applicant_id],
            [user_done_id],
            [done_date]
      )
SELECT
      tp.phones -- [phone_number]
,
      a.Id --[applicant_id]
,
      a.full_name --[full_name]
,
      ta.addresses --[live_address]
,
      a.birth_date [birth_date],
      a.birth_year [birth_year],
      a.social_state_id [social_state_id],
      a.category_type_id [category_type_id],
      @true_applicant_id [true_applicant_id],
      @user_id [user_done_id],
      GETUTCDATE() [done_date]
FROM
      [dbo].[Applicants] a
      LEFT JOIN @table_phones tp ON a.Id = tp.applicant_id
      LEFT JOIN @table_addresses ta ON a.Id = ta.applicant_id
WHERE
      a.Id IN (
            SELECT
                  Id
            FROM
                  @table_applicant
      ); 
      -- обновление таблицы Appeals на новых заявителей
      /**/
UPDATE
      [dbo].[Appeals]
SET
      applicant_id = @true_applicant_id,
      [edit_date] = GETUTCDATE(),
      [user_edit_id] = @user_id
WHERE
      applicant_id IN (
            SELECT
                  Id
            FROM
                  @table_applicant
      );
      --Appeal_getApplicantAddress
      --обновить таблицу [ApplicantPhones] на нового заявителя и его телефон главный, остальные других выбраных не главные
      /**/
UPDATE
      [dbo].[ApplicantPhones]
SET
      [IsMain] =CASE
            WHEN applicant_id = @true_applicant_id THEN 'true'
            ELSE 'false'
      END,
      applicant_id = @true_applicant_id,
	edit_date = GETUTCDATE(),
	user_edit_id = @user_id
WHERE
      applicant_id IN (
            SELECT
                  Id
            FROM
                  @table_applicant
      ); 
      --удалить дубликаты по заявителю и по номеру с таблицы [ApplicantPhones]
      /**/
DELETE FROM
      [dbo].[ApplicantPhones]
WHERE
      applicant_id = @true_applicant_id
      AND Id NOT IN (
            SELECT
                  min(Id) mid
            FROM
                  [dbo].[ApplicantPhones]
            WHERE
                  applicant_id = @true_applicant_id
            GROUP BY
                  REPLACE([ApplicantPhones].[phone_number], N'+38', N'')
      ); 
      --обновить таблицу [LiveAddress] на нового заявителя и его адресс главный, остальные других выбраных не главные
      /**/
UPDATE
      [dbo].[LiveAddress]
SET
      main =CASE
            WHEN applicant_id = @true_applicant_id
            AND main = 'true' THEN 'true'
            ELSE 'false'
      END,
      applicant_id = @true_applicant_id,
	edit_date = GETUTCDATE(),
	user_edit_id = @user_id 
WHERE
      applicant_id IN (
            SELECT
                  Id
            FROM
                  @table_applicant
      ); 
      --удалить дубликаты по заявителю и по адресу с таблицы [LiveAddress]
      /**/
DELETE FROM
      [dbo].[LiveAddress]
WHERE
      applicant_id = @true_applicant_id
      AND Id NOT IN(
            SELECT
                  min(Id) mid
            FROM
                  [dbo].[LiveAddress]
            WHERE
                  applicant_id = @true_applicant_id
            GROUP BY
                  [building_id],
                  [flat]
      ); 
      -- удаление с таблицы [Applicants]
DELETE FROM
      [dbo].[Applicants]
WHERE
      Id IN (
            SELECT
                  Id
            FROM
                  @table_applicant
      )
      AND Id <> @true_applicant_id;