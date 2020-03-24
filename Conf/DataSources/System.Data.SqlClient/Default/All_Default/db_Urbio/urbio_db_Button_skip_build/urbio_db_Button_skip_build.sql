--declare @Ids nvarchar(300)=N'53F7BCE4-371B-11E7-8000-000C29FF5864,A3E60438-4F51-11E7-8148-000C29FF5864,A3E9BFCE-4F51-11E7-816A-000C29FF5864';


update [CRM_1551_URBIO_Integrartion].[dbo].[addressObject]
  SET [is_done]='true'
	  ,[done_date]=getutcdate()
    ,[user_id]=@user_id
	  ,[comment]=@comment
  where convert(nvarchar(128),Id)=@Urbio_Id;

  DECLARE @table NVARCHAR(200)= N'addressObject';
  --declare @user_id nvarchar(123)=N'Вася';
  --DECLARE @urbio_id NVARCHAR(128)=@Urbio_Id;
  --declare @id_1551 int=13;
  --declare @comment nvarchar(123)=N'sdgss';
  --declare @operation_code nvarchar(23)=N'add'
  DECLARE @operation_code NVARCHAR(50)=CASE 
      WHEN @Operation=N'Додавання' THEN N'add'
      WHEN @Operation=N'Редагування' THEN N'change'
      WHEN @Operation=N'Видалення' THEN N'del'
      END;

 USE [CRM_1551_URBIO_Integrartion]

EXEC [dbo].[add_Urbio_Objects_History] @table, @user_id, @Urbio_Id, @Analitics_Id, @comment, @operation_code;