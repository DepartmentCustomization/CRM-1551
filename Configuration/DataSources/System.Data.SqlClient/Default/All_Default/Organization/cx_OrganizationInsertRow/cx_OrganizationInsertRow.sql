
declare @output table (Id int);


insert into [CRM_1551_Analitics].[dbo].[Organizations]
  ([parent_organization_id]
      ,[organization_type_id]
      ,[organization_code]
      ,[short_name]
      ,[name]
      ,[phone_number]
      ,[address]
      ,[head_name]
      ,[active]
      ,[population]
      ,[user_id]
      ,[edit_date]
      ,[user_edit_id]
      ,[programworker]
      ,[notes]
      ,[othercontacts])

 output [inserted].[Id] into @output (Id)

	  values
	  (@organization_id
      ,@organization_type_id
      ,@organization_code
      ,@short_name
      ,@name
      ,@phone_number
      ,@address
      ,@head_name
      ,@active
      ,@population
      ,@user_id
      ,getdate()
      ,@user_id
      ,@programworker
      ,@notes
      ,@othercontacts)


declare @org_id int = (select top 1 Id from @output)

insert into [CRM_1551_Analitics].[dbo].[OrganizationInResponsibility]
(
[position_id]
      ,[organization_id]
      ,[onform]
      ,[editable]
      ,[edit_date]
      ,[user_id]
)

select @positions_id, (select top 1 Id from @output), 1, 0, getutcdate(), @user_id;


exec [dbo].[Calc_OrganizationInResponsibilityRights_byOrganization]  @org_id, @user_id

if @active='true'
begin
declare @step nvarchar(50)=N'insert_organization';
exec [dbo].[ak_UpdateOrganizationsQuestionsTypeAndParent] @step, @org_id
end

 select @org_id as Id
 return;
