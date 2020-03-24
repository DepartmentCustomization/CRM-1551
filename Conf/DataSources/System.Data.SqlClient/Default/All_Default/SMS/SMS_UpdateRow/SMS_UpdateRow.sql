update [CRM_1551_SMS].[dbo].[mail_delivery_subscribers_sms_accounts]
set [FlatId] = @FlatId,
    [HouseId] = @HouseId,
    [UpdatedAt_1551] = getutcdate(),
    [ChangedBy1551Web] = 1,
    [SendClaims] = @SendClaims
where [Id] = @Id

