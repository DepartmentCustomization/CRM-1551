declare @output1 table(Id int);
--declare @output2 table(Id int);

if @type_id=1
  begin
        insert into [CRM_1551_Analitics].[dbo].[PositionsHelpers]
        (
        [main_position_id]
            ,[helper_position_id]
            ,[edit_date]
            ,[user_id]
        )
        output [inserted].[Id] into @output1 (Id)
        select
        @main_position_id
            ,@helper_position_id
            ,getutcdate()
            ,@user_id
  end

  if @type_id=2
  begin
        insert into [CRM_1551_Analitics].[dbo].[PositionsHelpers]
        (
        [main_position_id]
            ,[helper_position_id]
            ,[edit_date]
            ,[user_id]
        )
        output [inserted].[Id] into @output1 (Id)
        select
        @helper_position_id
            ,@main_position_id
            ,getdate()
            ,@user_id
  end
  

exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @main_position_id, @user_id
exec [dbo].[Calc_OrganizationInResponsibilityRights_byPosition] @helper_position_id, @user_id

select Id from @output1
return;