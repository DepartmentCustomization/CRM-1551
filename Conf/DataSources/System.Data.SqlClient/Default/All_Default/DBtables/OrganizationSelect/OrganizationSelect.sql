--declare @organization_id int=null;
--declare @user_id nvarchar(128)=N'9796543-b903-48a6-9399-4840f6eac396';

declare @org int =case when @organization_id is null then -1 else @organization_id end;

select distinct [Positions].[organizations_id] [Id], [Organizations].short_name [name]
  from [Positions]
  inner join [Organizations] on [Positions].organizations_id=[Organizations].Id
  where [Positions].Id in
  (
  select [Positions].Id
  from [Positions] --inner join [PositionsHelpers] on ([Positions].Id=[PositionsHelpers].main_position_id or [Positions].Id=[PositionsHelpers].helper_position_id)
  where [programuser_id]=@user_id
  union 
  select [PositionsHelpers].[main_position_id]
  from [PositionsHelpers] inner join [Positions] on [PositionsHelpers].helper_position_id=[Positions].Id
  where [Positions].[programuser_id]=@user_id)
  and [Organizations].Id<>@org