INSERT INTO
      [dbo].[ApplicantPhones] (
            [applicant_id],
            [phone_type_id],
            [phone_number],
            [CreatedAt],
            [user_id],
            [edit_date],
            [user_edit_id]
      ) output [inserted].[Id]
VALUES
      (
            @applicant_id,
            @phone_type_id,
            @phone_number,
            GETUTCDATE(),
            @user_id,
            GETUTCDATE(),
            @user_id
      );