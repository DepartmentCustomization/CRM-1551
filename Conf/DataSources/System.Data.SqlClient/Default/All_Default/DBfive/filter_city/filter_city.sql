select Id, Name
from
(
select	193 Id	, N'Районні у м. Києві адміністрації:' Name union all
select	194	, N'Голосіївська РДА' union all
select	195	, N'Дарницька РДА' union all
select	196	, N'Деснянська РДА' union all
select	197	, N'Дніпровська РДА' union all
select	198	, N'Оболонська РДА' union all
select	199	, N'Печерська РДА' union all
select	200	, N'Подільська  РДА' union all
select	201	, N'Святошинська РДА' union all
select	202	, N'Солом`янська РДА' union all
select	203	, N'Шевченківська РДА' union all
select	900	, N'Служби та підрозділи м. Києва:' union all
select	9564	, N'Центральна диспетчерська служба' union all
select	923	, N'ПАТ "Водоканал"' union all
select	5143	, N'Ліфтові організації м. Києва' union all
select	9443	, N'Радник керівника апарату КМР (КМДА)' union all
select	1020	, N'ПАТ "Київенерго"' union all
select	9103	, N'ДП "ГДІП"' union all
select	10263	, N'КП "Київтеплоенерго"' union all
select	9203	, N'ТОВ «Євро-Реконструкція»' union all
select	1523	, N'ПАТ "Київгаз"' union all
select	10043	, N'Громадська організація "ЛАКФАІНД"' union all
select	10003	, N'АТ «Ощадбанк»' 
) q

where #filter_columns#
  #sort_columns#
 offset @pageOffsetRows rows fetch next @pageLimitRows rows only