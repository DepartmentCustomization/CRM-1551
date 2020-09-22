--declare @Id int = 130

declare @HouseId int = (SELECT TOP (1) [HouseId] FROM [CRM_1551_SMS].[dbo].[mail_delivery_subscribers_sms_accounts] where [Id] = @Id)
declare @FlatId int = (SELECT TOP (1) [FlatId] FROM [CRM_1551_SMS].[dbo].[mail_delivery_subscribers_sms_accounts] where [Id] = @Id)
declare @StreetId int

if object_id('tempdb..#address_House') is not null drop table #address_House
create table #address_House(
[Id]   int,
[Name] nvarchar(2000),
[street_id] int
)
	declare @sql nvarchar(max)
	set @sql = 'select * from
	OPENQUERY([213.186.192.201,1433],
	''select * from OPENQUERY([ODS_KIEV],''''select houses.id as value, concat(houses.number,houses.letter) as label, street_id from houses
	where houses.id = '+convert(nvarchar(max),@HouseId)+'
	'''')'')'

insert into #address_House ([Id], [Name], [street_id])
exec sp_executesql @sql

set @StreetId = (select top 1 [street_id] from #address_House)

if object_id('tempdb..#address_Flat') is not null drop table #address_Flat
create table #address_Flat(
[Id]   int,
[Name] nvarchar(2000)
)
	declare @sql2 nvarchar(max)
	set @sql2 = 'select * from
	OPENQUERY([213.186.192.201,1433],
	''select * from OPENQUERY([ODS_KIEV],''''select flats.id as value, flats.name as label from flats
	where flats.id = '+convert(nvarchar(max),@FlatId)+'
	order by LENGTH(flats.name),flats.name '''')'')'

insert into #address_Flat ([Id], [Name])
exec sp_executesql @sql2



if object_id('tempdb..#address_Street') is not null drop table #address_Street
create table #address_Street(
[Id]   int,
[Name] nvarchar(2000)
)

declare @sql3 nvarchar(max)
	set @sql3 = 'select * from
	OPENQUERY([213.186.192.201,1433],
	''select * from OPENQUERY([ODS_KIEV],''''select distinct streets.id as value, streets.name as label 
	from streets
	where streets.id = '+convert(nvarchar(max),@StreetId)+' '''')'')'

insert into #address_Street ([Id], [Name])
exec sp_executesql @sql3



 SELECT TOP (1) [mail_delivery_subscribers_sms_accounts].[Id]
      ,[mail_delivery_subscribers_sms_accounts].[ContactId]
      ,[mail_delivery_subscribers_sms_accounts].[FlatId]
      ,[mail_delivery_subscribers_sms_accounts].[HouseId]
      ,[mail_delivery_subscribers_sms_accounts].[Name]
      ,[mail_delivery_subscribers_sms_accounts].[Phone]
      ,[mail_delivery_subscribers_sms_accounts].[CreatedAt_Gorodok]
      ,[mail_delivery_subscribers_sms_accounts].[UpdatedAt_Gorodok]
      ,[mail_delivery_subscribers_sms_accounts].[UpdatedAt]
      ,[mail_delivery_subscribers_sms_accounts].[ContactType]
      ,cast([mail_delivery_subscribers_sms_accounts].[SendClaims] as bit) as [SendClaims]
      ,[mail_delivery_subscribers_sms_accounts].[ChangedBy1557Web]
      ,[mail_delivery_subscribers_sms_accounts].[ChangedBy1551Web]
      ,[mail_delivery_subscribers_sms_accounts].[UpdatedAt_1551]
	  ,#address_Flat.[Name] as [FlatName]
	  ,isnull(#address_House.[Name],N'') as [HouseName]
	  ,#address_House.[street_id] as [StreetId]
	  ,#address_Street.[Name] as [StreetName]
  FROM [CRM_1551_SMS].[dbo].[mail_delivery_subscribers_sms_accounts]
  left join #address_Flat on #address_Flat.Id = [mail_delivery_subscribers_sms_accounts].[FlatId]
  left join #address_House on #address_House.Id = [mail_delivery_subscribers_sms_accounts].[HouseId]
  left join #address_Street on #address_Street.Id = #address_House.[street_id]
  where [mail_delivery_subscribers_sms_accounts].[Id] = @Id