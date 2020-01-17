select distinct 
qtyRepeated_prev, qtyRepeated_curr, qtyСollective_prev, qtyСollective_curr,
qtyWarsParticipants_prev, qWarsParticipants_curr, qtyInvalids_prev, qtyInvalids_curr,
qtyWorkVeterans_prev, qtyWorkVeterans_curr, qtyWarKids_prev, qtyWarKids_curr,
qtyFamily_prev, qtyFamily_curr, qtyChernobyl_prev, qtyChernobyl_curr
from Questions q
 -- Повторних за попередній
left join (select '-' as qtyRepeated_prev
		   ) qRepeated_prev on 1 <> 0
 -- Повторних за теперішній
left join (select '-' as qtyRepeated_curr
		   ) qRepeated_curr on 1 <> 0
 -- Колективних за попередній
left join (select '-' as qtyСollective_prev
		   ) qСollective_prev on 1 <> 0
 -- Колективних за теперішній
left join (select '-' as qtyСollective_curr
		   ) qСollective_curr on 1 <> 0
 -- Від учасників та інвалідів війни за попередній
left join (select '-' as qtyWarsParticipants_prev
		   ) qWarsParticipants_prev on 1 <> 0
 -- Від учасників та інвалідів війни за теперішній
left join (select '-' as qWarsParticipants_curr
		   ) qWarsParticipants_curr on 1 <> 0
 -- Від інвалідів за попередній
left join (select '-' as qtyInvalids_prev
		   ) qInvalids_prev on 1 <> 0
 -- Від інвалідів за теперішній
left join (select '-' as qtyInvalids_curr
		   ) qInvalids_curr on 1 <> 0
 -- Від ветеранів праці за попередній
left join (select '-' as qtyWorkVeterans_prev
		   ) qWorkVeterans_prev on 1 <> 0
 -- Від ветеранів праці за теперішній
left join (select '-' as qtyWorkVeterans_curr
		   ) qWorkVeterans_curr on 1 <> 0
 -- Від дітей війни за попередній
left join (select '-' as qtyWarKids_prev
		   ) qWarKids_prev on 1 <> 0
 -- Від дітей війни за теперішній
left join (select '-' as qtyWarKids_curr
		   ) qWarKids_curr on 1 <> 0
 -- Від членів багатодітних сімей, одиноких матерів, матерів героїнь за попередній
left join (select '-' as qtyFamily_prev
		   ) qFamily_prev on 1 <> 0
 -- Від членів багатодітних сімей, одиноких матерів, матерів героїнь за теперішній
left join (select '-' as qtyFamily_curr
		   ) qFamily_curr on 1 <> 0
 -- Від учасників ліквідації аварії на ЧАЕС та осіб,що потерпіли від Чорнобильської катастрофи за попередній
left join (select '-' as qtyChernobyl_prev
		   ) qChernobyl_prev on 1 <> 0
 -- Від учасників ліквідації аварії на ЧАЕС та осіб,що потерпіли від Чорнобильської катастрофи за теперішній
left join (select '-' as qtyChernobyl_curr
		   ) qChernobyl_curr on 1 <> 0