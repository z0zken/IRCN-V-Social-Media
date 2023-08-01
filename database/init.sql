INSERT INTO dbo.Role
VALUES
(   'USER', 'User' ),
(   'ADMIN', 'Admin' ),
(   'MASTERADMIN', 'Master Admin' ),
(   'BUSINESSS', 'Business' );

INSERT INTO dbo.Privacy
VALUES
(   'PUBLIC', 'Public'),
(   'FRIEND', 'Friend'),
(   'PRIVATE', 'Private');

INSERT INTO dbo.InterFace
VALUES
(   'like', 'like', '<i class="fa-solid fa-thumbs-up"></i>'),
(   'love', 'love', '<i class="fa-solid fa-heart"></i>'),
(   'haha', 'haha','<i class="fa-solid fa-face-laugh-squint"></i>'),
(   'sad', 'sad', '<i class="fa-solid fa-face-sad-cry"></i>'),
(   'angry', 'angry', '<i class="fa-regular fa-face-nose-steam"></i>'),
(   'wow', 'wow', '<i class="fa-solid fa-face-explode"></i>'),
(   'none', 'none', '<i class="fa-regular fa-thumbs-up"></i>');

INSERT INTO dbo.Role
(
    RoleID,
    RoleName
)
VALUES
(   'Lock', -- RoleID - varchar(11)
    '1895'  -- RoleName - varchar(30)
    )
INSERT INTO dbo.Role
(
    RoleID,
    RoleName
)
VALUES
(   'DELETED', -- RoleID - varchar(11)
    '4489'  -- RoleName - varchar(30)
    )