INSERT INTO
      [dbo].[LiveAddress] (
            [applicant_id],
            [building_id],
            [house_block],
            [entrance],
            [flat],
            [main],
            [active],
            [create_date],
            [user_id],
            [edit_date],
            [user_edit_id]
      ) --output [inserted].[applicant_id]
VALUES
      (
            @applicant_id,
            @building_address,
            @house_block,
            @entrance,
            @flat,
            @main,
            @active,
            GETUTCDATE(),
            @user_id,
            GETUTCDATE(),
            @user_id
      );