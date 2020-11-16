
/*
 declare @Ids nvarchar(300)=N'21,23,24,25,26,28'
 declare @true_applicant_id int =24;
 declare @user_id nvarchar(128)=N'Тестовый';
 declare @Id_table int=55;
 */

DECLARE @phone NVARCHAR(50) =(
      SELECT top 1
            PhoneNumber
      FROM
            [dbo].[ApplicantDublicate]
      WHERE
            Id = @Id_table
);
--select @phone

declare @phone_id_true int =
  (
  select top 1 [ApplicantPhones].Id 
  from [ApplicantPhones] 
  inner join [ApplicantDublicate] on replace([ApplicantPhones].[phone_number], N'+38', N'')=[ApplicantDublicate].PhoneNumber
  inner join [Applicants] on [ApplicantPhones].applicant_id=[Applicants].Id
  where [ApplicantDublicate].Id=@Id_table and [Applicants].Id=@true_applicant_id
  )

  declare @live_address_id_true int =
  (
  select top 1 [LiveAddress].Id
  from [ApplicantPhones] 
  inner join [ApplicantDublicate] on replace([ApplicantPhones].[phone_number], N'+38', N'')=[ApplicantDublicate].PhoneNumber
  inner join [Applicants] on [ApplicantPhones].applicant_id=[Applicants].Id
  left join [LiveAddress] on [Applicants].Id=[LiveAddress].applicant_id
  where [ApplicantDublicate].Id=@Id_table and [Applicants].Id=@true_applicant_id
  )

  --select @phone_id_true, @live_address_id_true
  --норм
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
--норм
--по комментарию начало
declare @ApplicantFromSiteId int=
(
select top 1 [Applicants].ApplicantFromSiteId
from [dbo].[Applicants]
inner join @table_applicant ta on [Applicants].Id=ta.Id
where [Applicants].ApplicantFromSiteId is not null
order by 
case when ta.id=@true_applicant_id then 0 else 1 end,
ta.id desc
)

update [dbo].[Applicants]
set ApplicantFromSiteId=@ApplicantFromSiteId
where Id=@true_applicant_id


update [CRM_1551_Site_Integration].[dbo].[ApplicantsFromSite]
  set [ApplicantId]=@true_applicant_id
  where [ApplicantId] in
  (select Id
  from @table_applicant ta)


-- по комментарию конец

-- обновить таблицу дубликатов 
/*
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
	*/  
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
	  --норм
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
--норм
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
      /*
	select N'update ApplicantPhones' u, Id, CASE
            WHEN Id=@phone_id_true THEN 'true'
            ELSE 'false'
      END is_main_new,
      applicant_id,
	  @true_applicant_id true_applicant_id
	from [dbo].[ApplicantPhones]
	WHERE
      applicant_id IN (
            SELECT
                  Id
            FROM
                  @table_applicant
      )
	  */
UPDATE
      [dbo].[ApplicantPhones]
SET
      [IsMain] =CASE
            WHEN Id=@phone_id_true THEN 'true'
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
      /*
	  --DELETE 
	  select N'delete ApplicantPhones', *
	  FROM
      [dbo].[ApplicantPhones]
	  where Id in
	  (
	  select [ApplicantPhones].Id
	  from [dbo].[ApplicantPhones] inner join
	  (select Id, row_number() over (partition by REPLACE([ApplicantPhones].[phone_number], N'+38', N'') order by case when [IsMain]='true' then -1 else Id end) n
	  from [dbo].[ApplicantPhones]
	  where applicant_id=@true_applicant_id) t on [ApplicantPhones].id=t.Id and n<>1
	  )
*/
	  DELETE 
	  --select *
	  FROM
      [dbo].[ApplicantPhones]
	  where Id in
	  (
	  select [ApplicantPhones].Id
	  from [dbo].[ApplicantPhones] inner join
	  (select Id, row_number() over (partition by REPLACE([ApplicantPhones].[phone_number], N'+38', N'') order by case when [IsMain]='true' then -1 else Id end) n
	  from [dbo].[ApplicantPhones]
	  where applicant_id=@true_applicant_id) t on [ApplicantPhones].id=t.Id and n<>1
	  )
	  --норм
--DELETE FROM
--      [dbo].[ApplicantPhones]
--WHERE
--      applicant_id = @true_applicant_id
--      AND Id NOT IN (
--            SELECT
--                  min(Id) mid
--            FROM
--                  [dbo].[ApplicantPhones]
--            WHERE
--                  applicant_id = @true_applicant_id --and [IsMain]='true'
--            GROUP BY
--                  REPLACE([ApplicantPhones].[phone_number], N'+38', N'')
--      ); 
      --обновить таблицу [LiveAddress] на нового заявителя и его адресс главный, остальные других выбраных не главные
      /*

	  select N'update LiveAddress', Id, 
	  CASE
            WHEN Id=@live_address_id_true THEN 'true'
            ELSE 'false'
      END new_main,
      applicant_id,
	  @true_applicant_id true_applicant_id
	  from [dbo].[LiveAddress]
*/
UPDATE
      [dbo].[LiveAddress]
SET
      main =CASE
            WHEN Id=@live_address_id_true THEN 'true'
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
--DELETE FROM
--      [dbo].[LiveAddress]
--WHERE
--      applicant_id = @true_applicant_id
--      AND Id NOT IN(
--            SELECT
--                  min(Id) mid
--            FROM
--                  [dbo].[LiveAddress]
--            WHERE
--                  applicant_id = @true_applicant_id --and [main]='true'
--            GROUP BY
--                  [building_id],
--                  [flat]
--      ); 

/*
--DELETE 
select N'delete LiveAddress', *
FROM
      [dbo].[LiveAddress]
	  where Id in
	  (
	  select [LiveAddress].Id
	  from [dbo].[LiveAddress] inner join
	  (select Id, row_number() over (partition by [building_id], [flat] order by case when [main]='true' then -1 else Id end) n
	  from [dbo].[LiveAddress]
	  where applicant_id=@true_applicant_id) t on [LiveAddress].id=t.Id and n<>1
	  )
*/

DELETE FROM
      [dbo].[LiveAddress]
	  where Id in
	  (
	  select [LiveAddress].Id
	  from [dbo].[LiveAddress] inner join
	  (select Id, row_number() over (partition by [building_id], [flat] order by case when [main]='true' then -1 else Id end) n
	  from [dbo].[LiveAddress]
	  where applicant_id=@true_applicant_id) t on [LiveAddress].id=t.Id and n<>1
	  )
      -- удаление с таблицы [Applicants]
/*select N'delete Applicants', *
 FROM
      [dbo].[Applicants]
WHERE
      Id IN (
            SELECT
                  Id
            FROM
                  @table_applicant
      )
      AND Id <> @true_applicant_id;
	  */
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