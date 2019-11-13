
UPDATE  [dbo].[Complain]
set [complain_type_id]= @complain_type_id
           ,[culpritname]= @culpritname
           ,[guilty]= @guilty
           ,[text] = @text
    where Id = @Id