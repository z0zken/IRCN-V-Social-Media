USE [SocialMedia]
GO
/****** Object:  Table [dbo].[POST]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POST](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PostID]  AS ('PID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[UserID] [varchar](11) NULL,
	[Content] [nvarchar](max) NULL,
	[ImagePost] [nvarchar](255) NULL,
	[TimePost] [datetime] NULL,
	[NumInterface] [int] NULL,
	[NumComment] [int] NULL,
	[NumShare] [int] NULL,
	[PrivacyID] [varchar](11) NULL,
PRIMARY KEY CLUSTERED 
(
	[PostID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POSTSHARE]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POSTSHARE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShareID]  AS ('SID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[UserID] [varchar](11) NULL,
	[PostID] [varchar](11) NULL,
	[Content] [nvarchar](max) NULL,
	[TimeShare] [datetime] NULL,
	[NumInterface] [int] NULL,
	[NumComment] [int] NULL,
	[PrivacyID] [varchar](11) NULL,
PRIMARY KEY CLUSTERED 
(
	[ShareID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[PostSummaryByMonth]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PostSummaryByMonth] AS
SELECT
    MONTH(TimePost) AS Month,
    YEAR(TimePost) AS Year,
    (
        (SELECT COUNT(*) FROM POST WHERE MONTH(TimePost) = MONTH(p.TimePost) AND YEAR(TimePost) = YEAR(p.TimePost)) +
        (SELECT COUNT(*) FROM POSTSHARE WHERE MONTH(TimeShare) = MONTH(p.TimePost) AND YEAR(TimeShare) = YEAR(p.TimePost))
    ) AS TotalPosts
FROM
    POST p
GROUP BY
    MONTH(TimePost),
    YEAR(TimePost);
GO
/****** Object:  Table [dbo].[ReportPost]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportPost](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID]  AS ('RPID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[PostID] [varchar](11) NULL,
	[UserID] [varchar](11) NULL,
	[UserID2] [varchar](11) NULL,
	[IsPost] [bit] NULL,
	[Status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ReportPostView]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ReportPostView] AS
SELECT 
    RP.PostID,
    RP.IsPost,
	MAX(CASE 
        WHEN RP.IsPost = 1 THEN P.ImagePost
        ELSE P2.ImagePost
    END) AS ImagePost,
    MAX(CASE 
        WHEN RP.IsPost = 1 THEN P.Content
        ELSE PS.Content
    END) AS Content,
	COUNT(RP.UserID) AS UserCount,
    MAX(CASE 
        WHEN RP.IsPost = 1 THEN P.TimePost
        ELSE PS.TimeShare
    END) AS TimePost,
	RP.UserID2 AS UserID,
	MAX(CAST(RP.Status AS INT)) AS Status
FROM 
    ReportPost RP
    LEFT JOIN POST P ON RP.PostID = P.PostID AND RP.IsPost = 1
    LEFT JOIN POSTSHARE PS ON RP.PostID = PS.ShareID AND RP.IsPost = 0
    LEFT JOIN POST P2 ON PS.PostID = P2.PostID
GROUP BY 
    RP.PostID,
    RP.IsPost,
	RP.UserID2;
GO
/****** Object:  Table [dbo].[ReportComment1686]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportComment1686](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID]  AS ('RPID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[CommentID] [varchar](11) NULL,
	[UserID] [varchar](11) NULL,
	[UserID2] [varchar](11) NULL,
	[IsPost] [bit] NULL,
	[Status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportUser1686]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportUser1686](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ReportID]  AS ('RPID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[UserID] [varchar](11) NULL,
	[UserIDRP] [varchar](11) NULL,
	[Status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserInfor]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInfor](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID]  AS ('UID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[Account] [varchar](155) NULL,
	[Password] [varchar](155) NULL,
	[FullName] [nvarchar](255) NULL,
	[Address] [nvarchar](255) NULL,
	[Mail] [varchar](255) NULL,
	[PhoneNumber] [varchar](15) NULL,
	[Dob] [date] NULL,
	[Gender] [bit] NULL,
	[Nation] [nvarchar](255) NULL,
	[ImageUser] [nvarchar](255) NULL,
	[ImageBackGround] [nvarchar](255) NULL,
	[NumFriend] [int] NULL,
	[NumPost] [int] NULL,
	[TimeCreate] [datetime] NULL,
	[RoleID] [varchar](11) NULL,
	[intro] [nvarchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[UserReportSummary]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UserReportSummary]
AS
SELECT
    u.UserID,
    u.ImageUser,
    u.FullName,
    u.Account,
    u.Mail,
    u.PhoneNumber,
    u.Address,
    (SELECT COUNT(*) FROM ReportComment1686 WHERE UserID2 = u.UserID) AS NumCommentReported,
    (SELECT COUNT(*) FROM ReportPost WHERE UserID2 = u.UserID) AS NumPostReported,
	(SELECT COUNT(DISTINCT UserIDRP) FROM ReportUser1686 WHERE UserID = u.UserID AND Status = 1) AS NumReportedByUsers
FROM
    UserInfor u
WHERE
    u.UserID IN (SELECT UserID FROM ReportUser1686 WHERE Status = 1);
GO
/****** Object:  View [dbo].[UserView]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UserView] AS
SELECT UserID, ImageUser, FullName, Address, Mail, Account, PhoneNumber, Dob, Nation, RoleID
FROM UserInfor;
GO
/****** Object:  Table [dbo].[COMMENT]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMMENT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CmtID]  AS ('CID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[UserID] [varchar](11) NULL,
	[PostID] [varchar](11) NULL,
	[Content] [nvarchar](max) NULL,
	[TimeComment] [datetime] NULL,
	[ImageComment] [varchar](255) NULL,
	[NumInterface] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CmtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COMMENTSHARE]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMMENTSHARE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CmtID]  AS ('CID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[UserID] [varchar](11) NULL,
	[ShareID] [varchar](11) NULL,
	[Content] [nvarchar](max) NULL,
	[TimeComment] [datetime] NULL,
	[ImageComment] [varchar](255) NULL,
	[NumInterface] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CmtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[ReportCommentView]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ReportCommentView] AS
SELECT 
    RP.CommentID,
    RP.IsPost,
	MAX(CASE 
        WHEN RP.IsPost = 1 THEN P.ImageComment
        ELSE PS.ImageComment
    END) AS ImageComment,
    MAX(CASE 
        WHEN RP.IsPost = 1 THEN P.Content
        ELSE PS.Content
    END) AS Content,
	COUNT(RP.UserID) AS UserCount,
    MAX(CASE 
        WHEN RP.IsPost = 1 THEN P.TimeComment
        ELSE PS.TimeComment
    END) AS TimeComment,
	RP.UserID2 AS UserID,
	MAX(CAST(RP.Status AS INT)) AS Status
FROM 
    dbo.ReportComment1686 RP
    LEFT JOIN dbo.COMMENT P ON RP.CommentID = P.CmtID AND RP.IsPost = 1
    LEFT JOIN dbo.COMMENTSHARE		 PS ON RP.CommentID = PS.CmtID AND RP.IsPost = 0
    LEFT JOIN COMMENT P2 ON PS.ShareID = P2.PostID
GROUP BY 
    RP.CommentID,
    RP.IsPost,
	RP.UserID2;
GO
/****** Object:  Table [dbo].[Active]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Active](
	[AdvertiserID] [varchar](11) NOT NULL,
	[dateShow] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AdvertiserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Advertisement]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Advertisement](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AdvertiserID]  AS ('AID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[BusinessID] [varchar](11) NULL,
	[Content] [nvarchar](max) NULL,
	[ImagePost] [nvarchar](255) NULL,
	[TimePost] [datetime] NULL,
	[NumInterface] [int] NULL,
	[NumComment] [int] NULL,
	[NumShare] [int] NULL,
	[NumOfShow] [int] NULL,
	[Quantity] [int] NULL,
	[Status] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[AdvertiserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Business]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Business](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessID]  AS ('BID'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[UserID] [varchar](11) NULL,
	[BrandName] [nvarchar](255) NOT NULL,
	[Address] [nvarchar](255) NULL,
	[Mail] [varchar](255) NULL,
	[PhoneNumber] [varchar](15) NULL,
	[ImageAvatar] [nvarchar](255) NULL,
	[ImageBackGround] [nvarchar](255) NULL,
	[NumFlow] [int] NULL,
	[intro] [nvarchar](max) NULL,
	[budget] [money] NULL,
	[TimeCreate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[BusinessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[COMMENTCHILD]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMMENTCHILD](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ChildID]  AS ('ILD'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[UserID] [varchar](11) NULL,
	[CmtID] [varchar](11) NULL,
	[Content] [nvarchar](max) NULL,
	[TimeComment] [datetime] NULL,
	[ImageComment] [varchar](255) NULL,
	[NumInterface] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ChildID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHATCONTENT]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHATCONTENT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ChatID]  AS ('ChatID'+right('000000000000'+CONVERT([varchar](12),[ID]),(12))) PERSISTED NOT NULL,
	[UserID1] [varchar](11) NULL,
	[UserID2] [varchar](11) NULL,
	[Mess] [nvarchar](500) NULL,
	[ofUser1] [bit] NULL,
	[CreateAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ChatID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InterFace]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterFace](
	[InterFaceID] [varchar](11) NOT NULL,
	[InterFaceName] [varchar](30) NULL,
	[InterFaceDiv] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[InterFaceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InterFaceObject]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterFaceObject](
	[UserID] [varchar](11) NOT NULL,
	[ObjectID] [varchar](11) NOT NULL,
	[InterFaceID] [varchar](11) NULL,
PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MAIL]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MAIL](
	[Mail] [varchar](255) NOT NULL,
	[code] [char](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[Mail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MonthlyUsage]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonthlyUsage](
	[MonthDate] [date] NOT NULL,
	[UsageTime] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[MonthDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NOTE_COMMENT]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NOTE_COMMENT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID]  AS ('NCM'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[ObjectID] [varchar](11) NULL,
	[UserID] [varchar](11) NOT NULL,
	[statusNote] [nvarchar](30) NULL,
	[TimeComment] [datetime] NULL,
	[isRead] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NOTE_COUNT]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NOTE_COUNT](
	[UserID] [varchar](11) NOT NULL,
	[NOTE] [int] NULL,
	[MESS] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NOTE_FRIEND]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NOTE_FRIEND](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID]  AS ('NFR'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[UserID] [varchar](11) NOT NULL,
	[UserIDRequest] [varchar](11) NOT NULL,
	[statusNote] [nvarchar](30) NULL,
	[TimeRequest] [datetime] NULL,
	[isRead] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NOTE_lIKE]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NOTE_lIKE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID]  AS ('NLI'+right('00000000'+CONVERT([varchar](8),[ID]),(8))) PERSISTED NOT NULL,
	[ObjectID] [varchar](11) NULL,
	[UserID] [varchar](11) NOT NULL,
	[statusNote] [nvarchar](30) NULL,
	[TimeComment] [datetime] NULL,
	[isRead] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[NoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Privacy]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Privacy](
	[PrivacyID] [varchar](11) NOT NULL,
	[PrivacyName] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[PrivacyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleID] [varchar](11) NOT NULL,
	[RoleName] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLock]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLock](
	[UserID] [varchar](11) NOT NULL,
	[LockTime] [datetime] NULL,
	[LockDurationDay] [int] NULL,
	[LockDurationHour] [int] NULL,
	[LockDurationMinute] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[USERRELATION]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USERRELATION](
	[UserID1] [varchar](11) NOT NULL,
	[UserID2] [varchar](11) NOT NULL,
	[U1RequestU2] [bit] NULL,
	[U2RequestU1] [bit] NULL,
	[isFriend] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID1] ASC,
	[UserID2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Active] ([AdvertiserID], [dateShow]) VALUES (N'AID00000002', CAST(N'2023-07-14T17:18:22.173' AS DateTime))
INSERT [dbo].[Active] ([AdvertiserID], [dateShow]) VALUES (N'AID00000015', CAST(N'2023-07-14T17:17:58.040' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Advertisement] ON 

INSERT [dbo].[Advertisement] ([ID], [BusinessID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [NumOfShow], [Quantity], [Status]) VALUES (2, N'BID00000001', N'Bet88   nhà cái hàng đầu việt nam', N'data/business/BID00000001/AID00000002/post/Facebook_Banner_GIF.gif', CAST(N'2023-07-10T19:51:15.320' AS DateTime), 1, 0, 0, 0, 89, N'ongoing')
INSERT [dbo].[Advertisement] ([ID], [BusinessID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [NumOfShow], [Quantity], [Status]) VALUES (9, N'BID00000006', N'hmm', N'data/business/BID00000006/AID00000009/post/maxresdefault.jpg', CAST(N'2023-07-12T21:34:28.640' AS DateTime), 0, 0, 0, 0, 100, N'inactive')
INSERT [dbo].[Advertisement] ([ID], [BusinessID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [NumOfShow], [Quantity], [Status]) VALUES (11, N'BID00000012', N'Trong cuộc sống, chúng ta luôn cần những phút giây đặc biệt bên người mình yêu thương. Và để tạo nên những kỷ niệm đáng nhớ, Vali Tình Yêu là người bạn đồng hành lý tưởng.



Quảng cáo "Vali Tình Yêu" không chỉ là một chiếc vali thời trang, mà là biểu tượng cho tình yêu và sự hướng về tương lai. Sự kết hợp giữa chất liệu chắc chắn và thiết kế tinh tế tạo nên một sản phẩm vừa đẹp mắt, vừa đáng tin cậy.



Một khi bạn mở nắp vali, bạn sẽ khám phá một thế giới đầy bất ngờ. Ngăn chứa lớn và thông minh được thiết kế để đựng đồ cá nhân của cả hai người, từ quần áo, phụ kiện, cho đến những món quà lưu niệm và kỷ niệm đáng nhớ. Mỗi lần cùng nhau mở vali, bạn cũng đang mở ra những kỷ niệm đáng trân quý.



Vali Tình Yêu không chỉ là người bạn đồng hành trong những chuyến đi lãng mạn, mà còn là biểu tượng của sự thấu hiểu và sự quan tâm tới những nguyện vọng của đối tác. Với tính năng tiện ích và bền bỉ, Vali Tình Yêu sẽ đi cùng bạn trong mọi chuyến du lịch, từ bãi biển nhiệt đới đến thành phố lãng mạn.



Hãy tặng Vali Tình Yêu cho người bạn đời của bạn, là món quà thể hiện tình yêu và sự quan tâm sâu sắc. Khám phá những hành trình tuyệt vời và chia sẻ những kỷ niệm đáng nhớ với Vali Tình Yêu - người bạn đồng hành trọn đời. 

https://shope.ee/99rekrjA0m', N'data/business/BID00000012/AID00000011/post/acffd4a3005418ce84c192cb82cf118f.jpg', CAST(N'2023-07-13T10:50:53.673' AS DateTime), 0, 0, 0, 0, 0, N'inactive')
INSERT [dbo].[Advertisement] ([ID], [BusinessID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [NumOfShow], [Quantity], [Status]) VALUES (12, N'BID00000014', N'aaaa', N'data/business/BID00000014/AID00000012/post/ava2.jpg', CAST(N'2023-07-13T15:52:21.560' AS DateTime), 0, 0, 0, 0, 8, N'inactive')
INSERT [dbo].[Advertisement] ([ID], [BusinessID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [NumOfShow], [Quantity], [Status]) VALUES (13, N'BID00000015', N'123', N'', CAST(N'2023-07-13T20:57:12.610' AS DateTime), 0, 0, 0, 0, 5, N'inactive')
INSERT [dbo].[Advertisement] ([ID], [BusinessID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [NumOfShow], [Quantity], [Status]) VALUES (14, N'BID00000016', N'111112334', N'', CAST(N'2023-07-13T21:12:22.123' AS DateTime), 0, 0, 0, 0, 0, N'inactive')
INSERT [dbo].[Advertisement] ([ID], [BusinessID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [NumOfShow], [Quantity], [Status]) VALUES (15, N'BID00000001', N'Buy this laptop', N'data/business/BID00000001/AID00000015/post/7IsD.jpg', CAST(N'2023-07-14T04:23:05.090' AS DateTime), 1, 0, 0, 0, 90, N'ongoing')
SET IDENTITY_INSERT [dbo].[Advertisement] OFF
GO
SET IDENTITY_INSERT [dbo].[Business] ON 

INSERT [dbo].[Business] ([ID], [UserID], [BrandName], [Address], [Mail], [PhoneNumber], [ImageAvatar], [ImageBackGround], [NumFlow], [intro], [budget], [TimeCreate]) VALUES (1, N'UID00000001', N'Pizza Hut Food', N'46 V� Ch� C�ng tp ?� N?ng', N'van123872000@gmail.com', N'0384859541', N'data/business/BID00000001/avatar/Screenshot 2023-07-12 002021.png', N'data/business/BID00000001/background/https://static.vecteezy.com/system/resources/previews/005/572/340/original/foggy-landscape-forest-in-the-morning-beautiful-sunrise-mist-cover-mountain-background-at-countryside-winter-free-photo.jpg', 0, N'Welcome to my Happy restaurant', 139.5500, CAST(N'2023-07-05T10:15:29.157' AS DateTime))
INSERT [dbo].[Business] ([ID], [UserID], [BrandName], [Address], [Mail], [PhoneNumber], [ImageAvatar], [ImageBackGround], [NumFlow], [intro], [budget], [TimeCreate]) VALUES (6, N'UID00000001', N'Nguyen Anh Viet', N'Quáº£ng NgÃ£i', N'van123872000@gmail.com', N'0384859541', N'data/business/BID00000006/avatar/3QeI.gif', N'data/business/BID00000006/background/qwerqwqwerqre', 0, N'', 2.6000, CAST(N'2023-07-12T19:19:27.407' AS DateTime))
INSERT [dbo].[Business] ([ID], [UserID], [BrandName], [Address], [Mail], [PhoneNumber], [ImageAvatar], [ImageBackGround], [NumFlow], [intro], [budget], [TimeCreate]) VALUES (12, N'UID00000012', N'Nguyen Anh Viet', N'Gia Lai', N'van123872000@gmail.com', N'1', N'data/business/BID00000012/avatar/Cosmic_Flight_Anivia_Wallpaper_LOL_1200x675-720x480.jpg', N'data/business/BID00000012/background/1', 0, N'', 999.5000, CAST(N'2023-07-13T10:49:10.500' AS DateTime))
INSERT [dbo].[Business] ([ID], [UserID], [BrandName], [Address], [Mail], [PhoneNumber], [ImageAvatar], [ImageBackGround], [NumFlow], [intro], [budget], [TimeCreate]) VALUES (13, N'UID00000012', N'z0zken', N'Gia Lai', N'duykhanh01092002@gmail.com', N'0339183224', N'data/business/BID00000013/avatar/zyro-image (2).png', N'data/business/BID00000013/background/siuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu', 0, N'', 0.0000, CAST(N'2023-07-13T10:57:38.667' AS DateTime))
INSERT [dbo].[Business] ([ID], [UserID], [BrandName], [Address], [Mail], [PhoneNumber], [ImageAvatar], [ImageBackGround], [NumFlow], [intro], [budget], [TimeCreate]) VALUES (14, N'UID00000009', N'a', N'Huáº¿', N'a', N'1', N'data/business/BID00000014/avatar/ava2.jpg', N'data/business/BID00000014/background/a', 0, N'', 4.6000, CAST(N'2023-07-13T15:51:25.450' AS DateTime))
INSERT [dbo].[Business] ([ID], [UserID], [BrandName], [Address], [Mail], [PhoneNumber], [ImageAvatar], [ImageBackGround], [NumFlow], [intro], [budget], [TimeCreate]) VALUES (15, N'UID00000022', N'd', N'null', N'thinh111190@gmail.com', N'0124531651', N'', N'data/business/BID00000015/background/qq', 0, N'', 9.7500, CAST(N'2023-07-13T20:52:26.460' AS DateTime))
INSERT [dbo].[Business] ([ID], [UserID], [BrandName], [Address], [Mail], [PhoneNumber], [ImageAvatar], [ImageBackGround], [NumFlow], [intro], [budget], [TimeCreate]) VALUES (16, N'UID00000023', N'1', N'xa táº­n chÃ¢n trá»i gáº§n ngay trÆ°á»c máº¯t', N'3', N'4', N'', N'data/business/BID00000016/background/124', 0, N'', 0.0000, CAST(N'2023-07-13T21:03:24.690' AS DateTime))
SET IDENTITY_INSERT [dbo].[Business] OFF
GO
SET IDENTITY_INSERT [dbo].[COMMENT] ON 

INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (1, N'UID00000001', N'PID00000006', NULL, CAST(N'2023-06-18T20:15:57.337' AS DateTime), NULL, 5)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (2, N'UID00000001', N'PID00000006', NULL, CAST(N'2023-06-18T20:17:45.503' AS DateTime), NULL, 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (3, N'UID00000001', N'PID00000006', NULL, CAST(N'2023-06-18T20:20:04.430' AS DateTime), NULL, 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (4, N'UID00000001', N'PID00000006', NULL, CAST(N'2023-06-18T20:22:19.320' AS DateTime), NULL, 2)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (5, N'UID00000001', N'PID00000006', NULL, CAST(N'2023-06-18T20:24:56.157' AS DateTime), NULL, 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (6, N'UID00000001', N'PID00000006', NULL, CAST(N'2023-06-18T20:27:56.727' AS DateTime), NULL, 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (7, N'UID00000001', N'PID00000006', NULL, CAST(N'2023-06-18T20:28:59.543' AS DateTime), NULL, 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (8, N'UID00000001', N'PID00000006', NULL, CAST(N'2023-06-18T20:35:38.610' AS DateTime), NULL, 2)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (9, N'UID00000001', N'PID00000006', NULL, CAST(N'2023-06-18T23:12:51.740' AS DateTime), NULL, 1)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (12, N'UID00000001', N'PID00000006', N'sdf', CAST(N'2023-06-19T22:16:40.490' AS DateTime), N'data/post/PID00000006/CID00000012/abc', 1)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (25, N'UID00000003', N'PID00000006', N'@Nguyen Anh Viet  ủa alo quen không', CAST(N'2023-06-21T09:25:04.663' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (26, N'UID00000003', N'PID00000007', N'là sao không hiểu', CAST(N'2023-06-21T09:26:55.567' AS DateTime), N'', 1)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (27, N'UID00000003', N'PID00000007', N'hi
', CAST(N'2023-06-21T09:29:56.350' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (28, N'UID00000003', N'PID00000007', N'hihi', CAST(N'2023-06-21T09:30:19.010' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (29, N'UID00000003', N'PID00000007', N'wow', CAST(N'2023-06-21T09:38:33.360' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (30, N'UID00000003', N'PID00000006', N'hgeloo', CAST(N'2023-06-21T11:03:55.157' AS DateTime), N'data/post/PID00000006/CID00000030/maxresdefault.jpg', 1)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (31, N'UID00000001', N'PID00000060', N'mèo của bạn dễ thương quá ', CAST(N'2023-06-21T13:46:10.180' AS DateTime), N'', 2)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (33, N'UID00000001', N'PID00000056', N'cảm động quá :(( bộ phim này đúng hay', CAST(N'2023-06-21T14:02:48.287' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (34, N'UID00000001', N'PID00000060', N'dfasasdf', CAST(N'2023-06-21T21:36:04.083' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (35, N'UID00000001', N'PID00000060', N'hello mọi người', CAST(N'2023-06-21T21:36:21.667' AS DateTime), N'', 1)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (37, N'UID00000012', N'PID00000024', N'm wibu af', CAST(N'2023-06-22T15:12:33.413' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (39, N'UID00000001', N'PID00000053', N'Xấu thật', CAST(N'2023-06-22T15:18:09.087' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (40, N'UID00000012', N'PID00000115', N'cool', CAST(N'2023-06-22T15:37:18.253' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (41, N'UID00000012', N'PID00000116', N'
siuuuuuuu', CAST(N'2023-06-22T15:38:18.503' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (42, N'UID00000012', N'PID00000116', N'
siuuuuuuu', CAST(N'2023-06-22T15:38:22.897' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (43, N'UID00000023', N'PID00000024', N'đề nghị bạn trưởng thành hơn =))
', CAST(N'2023-06-22T15:39:48.883' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (44, N'UID00000009', N'PID00000115', N'chắc đẹp
', CAST(N'2023-06-22T15:40:30.103' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (45, N'UID00000009', N'PID00000116', N'aa', CAST(N'2023-06-22T15:45:31.533' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (46, N'UID00000001', N'PID00000115', N'xấu', CAST(N'2023-06-23T11:01:25.980' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (47, N'UID00000001', N'PID00000115', N'hahah', CAST(N'2023-06-23T11:07:03.580' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (48, N'UID00000001', N'PID00000115', N'heheheheheh', CAST(N'2023-06-23T11:07:09.960' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (49, N'UID00000001', N'PID00000116', N'Xấu quá cậu ơi', CAST(N'2023-06-24T20:39:23.790' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (51, N'UID00000001', N'PID00000128', N'thật cảm động', CAST(N'2023-06-24T20:48:48.470' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (52, N'UID00000012', N'PID00000128', N'hay quá idol ơi', CAST(N'2023-06-24T20:48:54.520' AS DateTime), N'', 1)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (53, N'UID00000009', N'PID00000128', N'như shjt z', CAST(N'2023-06-24T20:49:33.783' AS DateTime), N'data/post/PID00000128/CID00000053/315071043_838980177445795_5847445369727898209_n.jpg', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (54, N'UID00000012', N'PID00000128', N'siuuuuuu', CAST(N'2023-06-24T20:49:48.627' AS DateTime), N'data/post/PID00000128/CID00000054/image.png', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (55, N'UID00000001', N'PID00000130', N'', CAST(N'2023-06-24T20:55:50.473' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (56, N'UID00000001', N'PID00000130', N'mình tình cờ đi chung xe, chung siêu thị, chung tuyến đường, chung gian hàng, chung thang máy á', CAST(N'2023-06-24T20:56:31.503' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (57, N'UID00000012', N'PID00000130', N'muchas gracias afición esto es para vosotros
siuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu
', CAST(N'2023-06-24T20:57:11.083' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (58, N'UID00000012', N'PID00000130', N'               
', CAST(N'2023-06-24T20:57:22.860' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (59, N'UID00000012', N'PID00000130', N'               
', CAST(N'2023-06-24T20:57:25.923' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (60, N'UID00000012', N'PID00000130', N'               
', CAST(N'2023-06-24T20:57:27.670' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (61, N'UID00000012', N'PID00000133', N'muchas gracias afición esto es para vosotros  siuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu', CAST(N'2023-06-24T21:19:41.857' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (62, N'UID00000001', N'PID00000132', N'chắc có mình tôi thấy bài viết này như ...', CAST(N'2023-06-24T22:25:10.680' AS DateTime), N'data/post/PID00000132/CID00000062/t?i xu?ng.jpg', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (66, N'UID00000001', N'PID00000133', N'cậu yêu trường thế', CAST(N'2023-06-28T09:35:08.340' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (79, N'UID00000001', N'PID00000130', N'Mình là best anivia thông thạo 7', CAST(N'2023-07-02T11:17:51.900' AS DateTime), N'data/post/PID00000130/CID00000079/Cosmic_Flight_Anivia_Wallpaper_LOL_1200x675-720x480.jpg', 1)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (80, N'UID00000001', N'PID00000130', N'hmmm', CAST(N'2023-07-03T13:40:07.320' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (81, N'UID00000024', N'PID00000060', N'CAC

', CAST(N'2023-07-10T21:08:29.323' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (82, N'UID00000024', N'PID00000060', N'CAC

', CAST(N'2023-07-10T21:08:30.000' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (83, N'UID00000024', N'PID00000127', N'GAY VL', CAST(N'2023-07-10T21:12:52.973' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (84, N'UID00000001', N'PID00000127', N'vai', CAST(N'2023-07-12T10:17:51.147' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (111, N'UID00000001', N'PID00000115', N'sdaf', CAST(N'2023-07-12T10:43:07.557' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (115, N'UID00000023', N'PID00000024', N'qq', CAST(N'2023-07-13T19:34:39.133' AS DateTime), N'', 0)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (116, N'UID00000023', N'PID00000024', N'qq', CAST(N'2023-07-13T19:34:39.450' AS DateTime), N'', 1)
INSERT [dbo].[COMMENT] ([ID], [UserID], [PostID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (118, N'UID00000002', N'PID00000050', N'', CAST(N'2023-07-13T20:23:55.160' AS DateTime), N'', 0)
SET IDENTITY_INSERT [dbo].[COMMENT] OFF
GO
SET IDENTITY_INSERT [dbo].[COMMENTCHILD] ON 

INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (3, N'UID00000001', N'CID00000001', N'erqqwer', CAST(N'2023-06-18T20:34:17.553' AS DateTime), NULL, -13)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (4, N'UID00000001', N'CID00000001', NULL, CAST(N'2023-06-18T23:13:14.570' AS DateTime), NULL, 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (5, N'UID00000001', N'CID00000012', NULL, CAST(N'2023-06-19T22:17:35.050' AS DateTime), N'data/post/PID00000006/CID00000012/ILD00000005/data/post/PID00000006/CID00000012/ILD00000005/data/post/PID00000006/CID00000012/ILD00000005/data/post/PID00000006/CID00000012/ILD00000005/data/post/PID00000006/CID00000012/ILD00000005/abcd', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (6, N'UID00000001', N'CID00000012', NULL, CAST(N'2023-06-19T22:22:28.037' AS DateTime), N'data/post/PID00000006/CID00000012/ILD00000006/data/post/PID00000006/CID00000012/ILD00000006/data/post/PID00000006/CID00000012/ILD00000006/data/post/PID00000006/CID00000012/ILD00000006/data/post/PID00000006/CID00000012/ILD00000006/abcd', 1)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (7, N'UID00000001', N'CID00000012', NULL, CAST(N'2023-06-19T22:22:31.960' AS DateTime), N'data/post/PID00000006/CID00000012/ILD00000007/data/post/PID00000006/CID00000012/ILD00000007/data/post/PID00000006/CID00000012/ILD00000007/data/post/PID00000006/CID00000012/ILD00000007/data/post/PID00000006/CID00000012/ILD00000007/abcwerd', 1)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (9, N'UID00000001', N'CID00000001', NULL, CAST(N'2023-06-21T00:03:03.010' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (10, N'UID00000003', N'CID00000012', N'@Nguyen Anh Viet @Nguyen Anh Viet ', CAST(N'2023-06-21T09:09:00.427' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (11, N'UID00000003', N'CID00000012', N'@Nguyen Anh Viet @Nguyen Anh Viet ', CAST(N'2023-06-21T09:09:00.590' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (12, N'UID00000003', N'CID00000012', N'@Nguyen Anh Viet @Nguyen Anh Viet ', CAST(N'2023-06-21T09:09:00.760' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (13, N'UID00000003', N'CID00000012', N'@Nguyen Anh Viet @Nguyen Anh Viet ', CAST(N'2023-06-21T09:10:09.813' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (35, N'UID00000003', N'CID00000028', N'@Nguyễn Hồ Ngọc Ấn hay quá', CAST(N'2023-06-21T09:35:19.613' AS DateTime), N'', 3)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (36, N'UID00000003', N'CID00000028', N'@Nguyễn Hồ Ngọc Ấn wow', CAST(N'2023-06-21T09:38:38.283' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (37, N'UID00000003', N'CID00000027', N'@Nguyễn Hồ Ngọc Ấn wow', CAST(N'2023-06-21T09:38:48.830' AS DateTime), N'', 5)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (38, N'UID00000003', N'CID00000029', N'@Nguyễn Hồ Ngọc Ấn ư', CAST(N'2023-06-21T09:39:01.927' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (39, N'UID00000003', N'CID00000026', N'@Nguyễn Hồ Ngọc Ấn là như vậy đó má', CAST(N'2023-06-21T09:39:36.330' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (40, N'UID00000003', N'CID00000026', N'@Nguyễn Hồ Ngọc Ấn vẫn không hiểu à
', CAST(N'2023-06-21T09:39:53.223' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (41, N'UID00000003', N'CID00000026', N'@Nguyễn Hồ Ngọc Ấn gà', CAST(N'2023-06-21T09:40:05.613' AS DateTime), N'', 9)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (42, N'UID00000003', N'CID00000026', N'@Nguyễn Hồ Ngọc Ấn ', CAST(N'2023-06-21T09:44:31.110' AS DateTime), N'', 6)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (43, N'UID00000003', N'CID00000026', N'@Nguyễn Hồ Ngọc Ấn dfafdafd', CAST(N'2023-06-21T09:44:56.953' AS DateTime), N'', 8)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (44, N'UID00000003', N'CID00000025', N'@Nguyễn Hồ Ngọc Ấn cậu thích tớ không', CAST(N'2023-06-21T10:43:31.297' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (51, N'UID00000003', N'CID00000025', N'không á', CAST(N'2023-06-21T10:44:16.640' AS DateTime), N'', 1)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (53, N'UID00000003', N'CID00000007', N'@Nguyen Anh Viet vì sao', CAST(N'2023-06-21T10:44:39.533' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (54, N'UID00000003', N'CID00000008', N'@Nguyen Anh Viet hehe', CAST(N'2023-06-21T10:44:45.390' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (55, N'UID00000003', N'CID00000008', N'@Nguyen Anh Viet @Nguyen Anh Viet hehe', CAST(N'2023-06-21T10:44:51.823' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (56, N'UID00000003', N'CID00000008', N'@Nguyen Anh Viet dfsaasdf', CAST(N'2023-06-21T10:45:00.420' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (57, N'UID00000003', N'CID00000025', N'@Nguyễn Hồ Ngọc Ấn ', CAST(N'2023-06-21T11:04:13.910' AS DateTime), N'data/post/PID00000006/CID00000025/ILD00000057/data/post/PID00000006/CID00000025/ILD00000057/Sharingan_17_08_2016_5.jpg', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (58, N'UID00000003', N'CID00000030', N'@Nguyễn Hồ Ngọc Ấn this is image', CAST(N'2023-06-21T11:04:40.557' AS DateTime), N'data/post/PID00000006/CID00000030/ILD00000058/maxresdefault.jpg', 1)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (59, N'UID00000003', N'CID00000025', N'@Nguyễn Hồ Ngọc Ấn wow', CAST(N'2023-06-21T11:10:08.163' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (60, N'UID00000001', N'CID00000031', N'@Nguyen Anh Viet dsfa', CAST(N'2023-06-21T21:35:59.223' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (61, N'UID00000001', N'CID00000034', N'@Nguyen Anh Viet  dá', CAST(N'2023-06-21T21:36:08.340' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (62, N'UID00000001', N'CID00000035', N'@Nguyen Anh Viet vẫn tiếp tục hello', CAST(N'2023-06-21T21:36:32.287' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (63, N'UID00000001', N'CID00000031', N'@Nguyen Anh Viet hi', CAST(N'2023-06-22T12:42:26.347' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (64, N'UID00000012', N'CID00000037', N'@Nguyễn Duy Khánh wibu', CAST(N'2023-06-22T15:12:42.153' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (65, N'UID00000012', N'CID00000037', N'', CAST(N'2023-06-22T15:12:52.373' AS DateTime), N'data/post/PID00000024/CID00000037/ILD00000065/data/post/PID00000024/CID00000037/ILD00000065/phương-pháp-swe.docx', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (66, N'UID00000001', N'CID00000037', N'@Nguyễn Duy Khánh đúng rồi đó', CAST(N'2023-06-22T15:12:54.473' AS DateTime), N'', 1)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (67, N'UID00000009', N'CID00000042', N'@Nguyễn Duy Khánh đây là cá mèo mập', CAST(N'2023-06-22T15:38:50.123' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (68, N'UID00000012', N'CID00000042', N'@Nguyễn Hồ Ngọc Ấn phải cá mập mèo không hay dị hợp', CAST(N'2023-06-22T15:39:28.380' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (71, N'UID00000009', N'CID00000056', N'@Nguyen Anh Viet mình đã tìm được thằng tội phạm đầu tiên rồi mọi người ạ. Mọi người giúp mình tìm 2 thằng còn lại nhé', CAST(N'2023-06-24T20:57:01.760' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (72, N'UID00000009', N'CID00000057', N'@Nguyễn Duy Khánh thằng này chắc người nước ngoài mọi người ạ. Nhưng mà nước ngoài mà phạm tội thì cũng nên xích lại. Mọi người tìm giúp mình thằng còn lại nha', CAST(N'2023-06-24T20:58:24.233' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (73, N'UID00000009', N'CID00000057', N'@Nguyễn Duy Khánh thằng này chắc người nước ngoài mọi người ạ. Nhưng mà nước ngoài mà phạm tội thì cũng nên xích lại. Mọi người tìm giúp mình thằng còn lại nha', CAST(N'2023-06-24T20:58:24.457' AS DateTime), N'', 1)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (74, N'UID00000001', N'CID00000056', N'@Nguyen Anh Viet abcd', CAST(N'2023-06-28T08:20:16.843' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (75, N'UID00000001', N'CID00000060', N'@Nguyễn Duy Khánh woww', CAST(N'2023-06-28T08:20:39.590' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (77, N'UID00000001', N'CID00000056', N'@Nguyễn Hồ Ngọc Ấn abc', CAST(N'2023-06-28T08:26:10.523' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (78, N'UID00000001', N'CID00000056', N'@Nguyễn Hồ Ngọc Ấn ', CAST(N'2023-06-28T08:26:27.890' AS DateTime), N'data/post/PID00000130/CID00000056/ILD00000078/data/post/PID00000130/CID00000056/ILD00000078/taixuong.jpg', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (79, N'UID00000001', N'CID00000056', N'@Nguyen Anh Viet ', CAST(N'2023-06-28T08:33:09.030' AS DateTime), N'data/post/PID00000130/CID00000056/ILD00000079/maxresdefault.jpg', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (84, N'UID00000012', N'CID00000066', N'@Nguyen Anh Viet chả thế', CAST(N'2023-06-29T20:54:47.260' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (166, N'UID00000001', N'CID00000058', N'@Nguyễn Duy Khánh fa', CAST(N'2023-07-02T08:51:42.700' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (167, N'UID00000002', N'CID00000058', N'@Nguyen Anh Viet abcd', CAST(N'2023-07-02T08:52:21.850' AS DateTime), N'', 0)
INSERT [dbo].[COMMENTCHILD] ([ID], [UserID], [CmtID], [Content], [TimeComment], [ImageComment], [NumInterface]) VALUES (182, N'UID00000001', N'CID00000061', N'@Nguyễn Duy Khánh uk', CAST(N'2023-07-02T17:11:40.747' AS DateTime), N'', 0)
SET IDENTITY_INSERT [dbo].[COMMENTCHILD] OFF
GO
SET IDENTITY_INSERT [dbo].[CHATCONTENT] ON 

INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (13, N'UID00000003', N'UID00000001', N'hjkugk', 0, CAST(N'2023-06-13T13:48:09.890' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (14, N'UID00000003', N'UID00000001', N'asdfg', 0, CAST(N'2023-06-13T13:48:50.737' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (15, N'UID00000010', N'UID00000001', N'xxxxxxxx', 1, CAST(N'2023-06-17T14:33:05.557' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (16, N'UID00000010', N'UID00000001', N'hello lĩnh', 0, CAST(N'2023-06-17T14:33:11.910' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (17, N'UID00000010', N'UID00000001', N'xxxxxxxxxxxxxx', 1, CAST(N'2023-06-17T14:33:12.130' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (18, N'UID00000010', N'UID00000001', N'ẻ', 0, CAST(N'2023-06-17T14:33:18.967' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (19, N'UID00000010', N'UID00000001', N'fdadsaf', 0, CAST(N'2023-06-17T14:33:23.677' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (20, N'UID00000010', N'UID00000001', N'xxxxxx', 1, CAST(N'2023-06-17T14:33:27.800' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (21, N'UID00000010', N'UID00000001', N'adsfafds', 0, CAST(N'2023-06-17T14:33:34.720' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (22, N'UID00000009', N'UID00000001', N'chào cậu', 1, CAST(N'2023-06-17T14:34:57.203' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (23, N'UID00000009', N'UID00000001', N'nó đéo hiện', 1, CAST(N'2023-06-17T14:35:04.550' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (24, N'UID00000010', N'UID00000001', N'fff', 0, CAST(N'2023-06-17T14:35:32.340' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (25, N'UID00000012', N'UID00000009', N'hihihihi', 0, CAST(N'2023-06-17T14:37:17.773' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (26, N'UID00000012', N'UID00000009', N'hi', 1, CAST(N'2023-06-17T14:40:01.130' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (27, N'UID00000010', N'UID00000001', N'ewrwq', 0, CAST(N'2023-06-17T14:40:29.383' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (28, N'UID00000010', N'UID00000001', N'efrev', 0, CAST(N'2023-06-17T14:40:31.790' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (29, N'UID00000012', N'UID00000009', N'chao cau', 1, CAST(N'2023-06-17T14:40:48.503' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (30, N'UID00000010', N'UID00000001', N'a', 1, CAST(N'2023-06-17T14:42:30.467' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (31, N'UID00000010', N'UID00000001', N'aaaaaaa', 1, CAST(N'2023-06-17T14:42:50.787' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (32, N'UID00000010', N'UID00000001', N'z', 1, CAST(N'2023-06-17T14:43:11.270' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (33, N'UID00000012', N'UID00000001', N'fuck you''', 1, CAST(N'2023-06-17T14:44:16.283' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (34, N'UID00000012', N'UID00000001', N'chuiwr cc', 0, CAST(N'2023-06-17T15:47:21.507' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (35, N'UID00000012', N'UID00000001', N'sao cậu lại chửi mình', 0, CAST(N'2023-06-17T15:48:41.720' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (36, N'UID00000012', N'UID00000001', N'heheh', 0, CAST(N'2023-06-17T15:50:46.543' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (37, N'UID00000012', N'UID00000001', N'gh', 0, CAST(N'2023-06-17T15:55:19.800' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (38, N'UID00000012', N'UID00000001', N'rteqe', 0, CAST(N'2023-06-17T15:55:22.863' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (39, N'UID00000009', N'UID00000001', N'chào cậu', 0, CAST(N'2023-06-17T15:57:39.110' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (40, N'UID00000009', N'UID00000001', N'nó hiện được chưa á', 0, CAST(N'2023-06-17T15:57:43.010' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (41, N'UID00000010', N'UID00000001', N'chèo bẹn', 0, CAST(N'2023-06-17T15:58:17.153' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (42, N'UID00000010', N'UID00000001', N'bẹn nay khỏe hôm', 0, CAST(N'2023-06-17T15:58:21.317' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (43, N'UID00000010', N'UID00000001', N'Được ko', 1, CAST(N'2023-06-17T15:58:38.973' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (44, N'UID00000010', N'UID00000001', N'được rồi', 0, CAST(N'2023-06-17T15:59:01.340' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (45, N'UID00000010', N'UID00000001', N'cậu khi nào đi', 0, CAST(N'2023-06-17T15:59:14.057' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (46, N'UID00000010', N'UID00000001', N'đi qua dì á', 0, CAST(N'2023-06-17T15:59:17.360' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (47, N'UID00000010', N'UID00000001', N'là từ hôm nay qua dì luôn à', 0, CAST(N'2023-06-17T15:59:24.797' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (48, N'UID00000009', N'UID00000001', N'câu nói bậy quá', 0, CAST(N'2023-06-17T15:59:44.573' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (49, N'UID00000009', N'UID00000001', N'mình k thích đâu', 0, CAST(N'2023-06-17T15:59:47.900' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (50, N'UID00000010', N'UID00000001', N'Test', 1, CAST(N'2023-06-17T16:00:17.507' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (51, N'UID00000010', N'UID00000001', N'được', 0, CAST(N'2023-06-17T16:00:34.280' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (52, N'UID00000010', N'UID00000001', N'nhận đc', 0, CAST(N'2023-06-17T16:00:36.303' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (53, N'UID00000010', N'UID00000001', N'test đc k emn', 0, CAST(N'2023-06-17T16:00:45.073' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (54, N'UID00000009', N'UID00000001', N'chaof cau', 1, CAST(N'2023-06-17T16:01:02.070' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (55, N'UID00000009', N'UID00000001', N'no hien r', 1, CAST(N'2023-06-17T16:01:04.720' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (56, N'UID00000010', N'UID00000001', N'Xxxx', 1, CAST(N'2023-06-17T16:01:07.567' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (57, N'UID00000009', N'UID00000001', N'cau co thay tin nhan ko z', 1, CAST(N'2023-06-17T16:01:12.057' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (58, N'UID00000010', N'UID00000001', N'đc nè', 0, CAST(N'2023-06-17T16:01:15.690' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (59, N'UID00000009', N'UID00000001', N'có á', 0, CAST(N'2023-06-17T16:01:31.940' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (60, N'UID00000009', N'UID00000001', N'thay ko', 1, CAST(N'2023-06-17T16:01:42.390' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (61, N'UID00000009', N'UID00000001', N'thấy', 0, CAST(N'2023-06-17T16:01:45.403' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (62, N'UID00000009', N'UID00000001', N'oke', 1, CAST(N'2023-06-17T16:01:47.983' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (63, N'UID00000009', N'UID00000001', N'làm xí k', 0, CAST(N'2023-06-17T16:01:48.830' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (64, N'UID00000009', N'UID00000001', N'cậu ơi', 0, CAST(N'2023-06-17T16:02:35.230' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (65, N'UID00000009', N'UID00000001', N'làm xí nhỉ', 0, CAST(N'2023-06-17T16:02:38.257' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (66, N'UID00000009', N'UID00000001', N'ê bé', 0, CAST(N'2023-06-17T16:03:10.240' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (67, N'UID00000009', N'UID00000001', N'lơ anh à', 0, CAST(N'2023-06-17T16:03:14.270' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (68, N'UID00000009', N'UID00000001', N'day', 1, CAST(N'2023-06-17T16:03:17.480' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (69, N'UID00000009', N'UID00000001', N'làm xí chứ', 0, CAST(N'2023-06-17T16:03:23.583' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (70, N'UID00000009', N'UID00000001', N'dang noi chuyen thi nhan tin cc a`', 1, CAST(N'2023-06-17T16:03:24.000' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (71, N'UID00000009', N'UID00000001', N'oke be', 1, CAST(N'2023-06-17T16:03:27.630' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (72, N'UID00000009', N'UID00000001', N'để rủ vinh tạo tk', 0, CAST(N'2023-06-17T16:03:28.407' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (73, N'UID00000009', N'UID00000001', N'nhắn trong này', 0, CAST(N'2023-06-17T16:03:30.793' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (74, N'UID00000009', N'UID00000001', N'chac vinh ko xai dau', 1, CAST(N'2023-06-17T16:06:27.577' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (75, N'UID00000009', N'UID00000001', N':))', 1, CAST(N'2023-06-17T16:06:28.737' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (76, N'UID00000009', N'UID00000001', N'nói đi', 0, CAST(N'2023-06-17T16:06:51.073' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (77, N'UID00000009', N'UID00000001', N'cậu', 0, CAST(N'2023-06-17T16:08:01.787' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (78, N'UID00000009', N'UID00000001', N'sao v cau', 1, CAST(N'2023-06-17T16:08:05.143' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (79, N'UID00000009', N'UID00000001', N'đi ad hay sp', 0, CAST(N'2023-06-17T16:08:05.950' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (80, N'UID00000009', N'UID00000001', N'cần mình đi sp', 0, CAST(N'2023-06-17T16:08:11.897' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (81, N'UID00000009', N'UID00000001', N'k', 0, CAST(N'2023-06-17T16:08:13.083' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (82, N'UID00000009', N'UID00000001', N'ko cau', 1, CAST(N'2023-06-17T16:08:19.867' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (83, N'UID00000013', N'UID00000001', N'chào câu', 0, CAST(N'2023-06-17T16:17:32.897' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (84, N'UID00000013', N'UID00000001', N'chào phúc nhé', 0, CAST(N'2023-06-17T16:17:38.517' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (86, N'UID00000013', N'UID00000001', N'moe', 1, CAST(N'2023-06-17T16:19:21.737' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (87, N'UID00000013', N'UID00000001', N'ditmemay', 1, CAST(N'2023-06-17T16:19:26.903' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (88, N'UID00000013', N'UID00000001', N'sấdfasdfs', 1, CAST(N'2023-06-17T16:20:05.733' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (89, N'UID00000013', N'UID00000001', N'duma đc rồi', 1, CAST(N'2023-06-17T16:20:13.590' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (90, N'UID00000013', N'UID00000001', N'mọe mày', 1, CAST(N'2023-06-17T16:20:19.287' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (91, N'UID00000013', N'UID00000001', N'phắc du', 1, CAST(N'2023-06-17T16:20:23.273' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (92, N'UID00000013', N'UID00000001', N'yêu Phúc', 0, CAST(N'2023-06-17T16:21:10.717' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (93, N'UID00000013', N'UID00000001', N'ditconmemay', 1, CAST(N'2023-06-17T16:21:36.720' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (94, N'UID00000013', N'UID00000001', N'duma', 1, CAST(N'2023-06-17T16:21:50.427' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (95, N'UID00000013', N'UID00000001', N'cc', 0, CAST(N'2023-06-17T16:21:52.637' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (96, N'UID00000013', N'UID00000001', N'móa', 1, CAST(N'2023-06-17T16:21:53.927' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (97, N'UID00000013', N'UID00000001', N'chửi cc à', 0, CAST(N'2023-06-17T16:21:54.810' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (98, N'UID00000013', N'UID00000001', N'móa cc', 0, CAST(N'2023-06-17T16:21:57.540' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (99, N'UID00000013', N'UID00000001', N'đừng nói tục', 0, CAST(N'2023-06-17T16:22:00.320' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (100, N'UID00000013', N'UID00000001', N'cô chửi h', 0, CAST(N'2023-06-17T16:22:02.330' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (101, N'UID00000013', N'UID00000001', N':))', 0, CAST(N'2023-06-17T16:22:03.780' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (102, N'UID00000013', N'UID00000001', N'th zô zăn hóa', 0, CAST(N'2023-06-17T16:22:14.703' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (103, N'UID00000013', N'UID00000001', N':)))', 1, CAST(N'2023-06-17T16:22:29.277' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (104, N'UID00000013', N'UID00000001', N'chào bạn', 1, CAST(N'2023-06-17T16:22:57.597' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (105, N'UID00000013', N'UID00000001', N'bạn cho mình làm quen', 1, CAST(N'2023-06-17T16:23:03.230' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (106, N'UID00000013', N'UID00000001', N'bạn ăn cơm chưa', 1, CAST(N'2023-06-17T16:23:07.920' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (107, N'UID00000020', N'UID00000001', N'helo vinh', 0, CAST(N'2023-06-18T02:40:28.387' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (108, N'UID00000020', N'UID00000001', N'yêu vinh', 0, CAST(N'2023-06-18T02:40:30.720' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (109, N'UID00000020', N'UID00000001', N'vinh không yêu việt', 0, CAST(N'2023-06-18T02:40:34.577' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (111, N'UID00000020', N'UID00000001', N'Khánh sẽ cho vinh 1 cái ôm và 1 cái hun', 0, CAST(N'2023-06-18T02:40:53.740' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (112, N'UID00000009', N'UID00000001', N'ấn không kết bạn với Việt :((', 0, CAST(N'2023-06-19T21:47:35.387' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (113, N'UID00000009', N'UID00000001', N'buồn ấn lắm', 0, CAST(N'2023-06-19T21:47:40.380' AS DateTime))
GO
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (114, N'UID00000023', N'UID00000003', N'chào bạn', 1, CAST(N'2023-06-22T15:42:38.360' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (115, N'UID00000012', N'UID00000009', N'cậu có khi nào thích tớ không', 0, CAST(N'2023-06-22T16:47:00.190' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (116, N'UID00000012', N'UID00000009', N'hi cậu', 1, CAST(N'2023-06-24T20:09:41.813' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (117, N'UID00000012', N'UID00000001', N'hi cậu', 1, CAST(N'2023-06-24T20:09:53.330' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (118, N'UID00000012', N'UID00000001', N'con cac viet', 1, CAST(N'2023-06-24T20:41:12.977' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (119, N'UID00000012', N'UID00000001', N'khánh đổi ảnh đại diện chi kì á', 0, CAST(N'2023-06-29T21:14:34.047' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (120, N'UID00000022', N'UID00000001', N'a', 1, CAST(N'2023-07-07T13:07:22.137' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (121, N'UID00000022', N'UID00000001', N'b', 1, CAST(N'2023-07-07T13:16:29.610' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (122, N'UID00000022', N'UID00000001', N'c', 1, CAST(N'2023-07-07T13:16:30.253' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (123, N'UID00000022', N'UID00000001', N'd', 1, CAST(N'2023-07-07T13:16:31.057' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (124, N'UID00000024', N'UID00000022', N'Chào Em', 0, CAST(N'2023-07-10T21:04:44.940' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (125, N'UID00000024', N'UID00000022', N'Buonf nam', 0, CAST(N'2023-07-10T21:05:09.877' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (126, N'UID00000024', N'UID00000022', N'CAC', 1, CAST(N'2023-07-10T21:05:10.467' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (127, N'UID00000022', N'UID00000001', N'ê', 0, CAST(N'2023-07-10T21:05:39.540' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (128, N'UID00000022', N'UID00000001', N'nó qua được không', 0, CAST(N'2023-07-10T21:05:42.690' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (129, N'UID00000024', N'UID00000022', N'xxx', 0, CAST(N'2023-07-10T21:05:50.730' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (130, N'UID00000024', N'UID00000022', N'CAC', 1, CAST(N'2023-07-10T21:05:57.853' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (131, N'UID00000024', N'UID00000022', N'xxxxxxx', 0, CAST(N'2023-07-10T21:06:09.690' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (132, N'UID00000024', N'UID00000022', N'buon', 0, CAST(N'2023-07-10T21:06:17.140' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (133, N'UID00000022', N'UID00000001', N'im em ik', 1, CAST(N'2023-07-10T21:06:33.210' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (134, N'UID00000012', N'UID00000001', N'-.-', 1, CAST(N'2023-07-10T22:04:52.387' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (135, N'UID00000012', N'UID00000001', N'kệ tao m', 1, CAST(N'2023-07-10T22:04:57.367' AS DateTime))
INSERT [dbo].[CHATCONTENT] ([ID], [UserID1], [UserID2], [Mess], [ofUser1], [CreateAt]) VALUES (136, N'UID00000022', N'UID00000001', N'ik ăn việt ơi', 1, CAST(N'2023-07-13T11:01:44.623' AS DateTime))
SET IDENTITY_INSERT [dbo].[CHATCONTENT] OFF
GO
INSERT [dbo].[InterFace] ([InterFaceID], [InterFaceName], [InterFaceDiv]) VALUES (N'angry', N'angry', N'<i class=''fa-regular fa-face-nose-steam''></i><span>Angry</span>')
INSERT [dbo].[InterFace] ([InterFaceID], [InterFaceName], [InterFaceDiv]) VALUES (N'haha', N'haha', N'<i class=''fa-solid fa-face-laugh-ssteam''></i><span>Haha</span>')
INSERT [dbo].[InterFace] ([InterFaceID], [InterFaceName], [InterFaceDiv]) VALUES (N'like', N'like', N'<i class=''fa-solid fa-thumbs-up''></i><span>Like</span>')
INSERT [dbo].[InterFace] ([InterFaceID], [InterFaceName], [InterFaceDiv]) VALUES (N'love', N'love', N'<i class=''fa-solid fa-heart''></i><span>Love</span>')
INSERT [dbo].[InterFace] ([InterFaceID], [InterFaceName], [InterFaceDiv]) VALUES (N'none', N'none', N'<i class=''fa-regular fa-thumbs-up''></i><span>Like</span>')
INSERT [dbo].[InterFace] ([InterFaceID], [InterFaceName], [InterFaceDiv]) VALUES (N'sad', N'sad', N'<i class=''fa-solid fa-face-sad-cry''></i> <span>Sad</span>')
INSERT [dbo].[InterFace] ([InterFaceID], [InterFaceName], [InterFaceDiv]) VALUES (N'wow', N'wow', N'<i class=''fa-solid fa-face-explcry''></i> <span>Wow</span>')
GO
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'AID00000001', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'AID00000002', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'AID00000002', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'AID00000002', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'AID00000002', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'AID00000009', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'AID00000010', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'AID00000011', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'AID00000011', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'AID00000011', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'AID00000011', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000022', N'AID00000011', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'AID00000011', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000025', N'AID00000011', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'AID00000015', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000001', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000004', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000006', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000007', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000008', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000008', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000009', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000009', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000012', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000012', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000013', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000014', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000015', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000016', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000017', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000018', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000019', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000020', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000021', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000022', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000023', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000024', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000025', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000025', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000026', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000026', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000027', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000027', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000028', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000028', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000029', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000029', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000030', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'CID00000030', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000031', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'CID00000031', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'CID00000031', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000032', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000033', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000034', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'CID00000034', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000035', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'CID00000035', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000036', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000037', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000037', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'CID00000037', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000038', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000039', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000040', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000040', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000040', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000041', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000041', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000041', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000042', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000042', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000042', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000043', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'CID00000043', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000044', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000044', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000044', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000045', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000045', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000046', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000046', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000047', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000047', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000048', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000048', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000049', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000050', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000050', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000051', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000051', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000052', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000052', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000052', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000053', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000053', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000054', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000054', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000055', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000055', N'none')
GO
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000055', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000056', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000056', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000056', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000058', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000058', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000058', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000061', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000061', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000062', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000062', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000063', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000063', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000064', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000064', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000065', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'CID00000065', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000066', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'CID00000066', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000067', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000068', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000069', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000070', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000071', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000072', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000073', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000074', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000075', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000076', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000077', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000078', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000079', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000080', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'CID00000081', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'CID00000082', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000083', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'CID00000083', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000084', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000106', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000107', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000111', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000114', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000115', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'CID00000115', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000116', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'CID00000116', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000117', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'CID00000117', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000118', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'CID00000118', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000119', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'CID00000119', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'CID00000120', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'CID00000120', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000003', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000005', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000006', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000007', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000007', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000010', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000010', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000011', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000011', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000012', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000012', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000013', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000013', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000035', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000035', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000036', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000036', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000037', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000037', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000038', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000038', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000039', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000039', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000040', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000040', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000041', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000041', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000042', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000042', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000043', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000043', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000044', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000044', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000051', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000051', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000053', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000054', N'none')
GO
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000054', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000055', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000055', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000056', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000056', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000058', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000058', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'ILD00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'ILD00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000061', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'ILD00000061', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000062', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'ILD00000062', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000063', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'ILD00000063', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000064', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'ILD00000064', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'ILD00000064', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000065', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'ILD00000065', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'ILD00000065', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000066', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'ILD00000066', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000067', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000067', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'ILD00000067', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000068', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000068', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'ILD00000068', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000069', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000069', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000070', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000070', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000071', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000071', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000072', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000072', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000073', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000073', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000074', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000075', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000075', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000076', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000076', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000077', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000078', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000079', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000080', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000080', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000081', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000081', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000082', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000082', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000083', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'ILD00000083', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000084', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'ILD00000084', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000085', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000093', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000107', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000116', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000117', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000118', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000119', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000120', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000121', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000122', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000158', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000159', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000160', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000166', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000167', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000169', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000170', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000171', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000172', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000173', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000174', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000175', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000176', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000177', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000178', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000179', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000180', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000181', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000182', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'ILD00000183', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'ILD00000183', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000005', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000005', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000005', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000006', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000006', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000006', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000007', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000007', N'none')
GO
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000007', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000008', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000008', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000008', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000023', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000023', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000023', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000024', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000024', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000024', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000024', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000022', N'PID00000024', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'PID00000024', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000025', N'PID00000024', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000025', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000025', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000025', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000034', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000045', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000048', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000048', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000050', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000050', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000051', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000051', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000052', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000052', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000053', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000053', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000053', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000053', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000054', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000054', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000054', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000056', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000056', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000056', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000004', N'PID00000056', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000008', N'PID00000056', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000056', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000056', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'PID00000056', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000057', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000057', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000008', N'PID00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000058', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000058', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000058', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000008', N'PID00000058', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000008', N'PID00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000060', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000060', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000008', N'PID00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'PID00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000061', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000064', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000065', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000066', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000067', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000068', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000069', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000070', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000071', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000072', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000073', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000074', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000075', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000076', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000076', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000077', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000077', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000077', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000078', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000078', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000078', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000079', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000079', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000080', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000080', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000080', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000081', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000081', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000082', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000082', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000083', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000083', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000084', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000084', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000085', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000085', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000086', N'none')
GO
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000086', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000087', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000087', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000087', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000088', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000089', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000090', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000092', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000093', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000093', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000093', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000094', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000094', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000095', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'PID00000096', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000025', N'PID00000096', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000097', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000097', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000098', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000098', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000099', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000099', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000100', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000100', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000101', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000101', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000102', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000102', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000103', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000103', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000104', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000104', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000105', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000105', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000106', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000106', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000106', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000107', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000107', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000107', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000108', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000108', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000108', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000109', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000109', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000109', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000110', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000110', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000110', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000111', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000111', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000111', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000112', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000112', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000112', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000113', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000113', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000113', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000114', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000114', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000114', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000115', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000115', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000115', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000116', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000116', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000116', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000116', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000117', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000118', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000119', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000120', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000121', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000122', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000123', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000125', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000125', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000125', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000126', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000126', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000126', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000126', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000127', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000127', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000127', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'PID00000127', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000128', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000128', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000128', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000129', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000129', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000129', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000130', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000130', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000130', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000130', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000131', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000131', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000132', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'PID00000132', N'none')
GO
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000132', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000132', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000133', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000133', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000133', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000134', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000134', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000134', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'PID00000135', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'PID00000136', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000137', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000138', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000139', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000140', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000141', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000142', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000143', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000144', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000145', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000146', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000147', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000148', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000149', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000150', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000151', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000152', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000153', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000154', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000155', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000156', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000157', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000158', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000159', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000159', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000024', N'PID00000159', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000160', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000160', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000161', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000162', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000163', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000164', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000164', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000166', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000166', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000166', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000167', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000168', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'PID00000168', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'PID00000168', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000022', N'PID00000169', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000172', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000172', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'PID00000173', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'PID00000173', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000008', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'SID00000008', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000019', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000019', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000020', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000020', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000021', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000021', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000022', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000022', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000023', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000023', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000024', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000024', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000027', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'SID00000027', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'SID00000027', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'SID00000027', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000028', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000028', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000003', N'SID00000028', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000008', N'SID00000028', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'SID00000028', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'SID00000028', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000029', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000030', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000031', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000032', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000033', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000034', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000035', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000036', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000037', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000038', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000039', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000040', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000041', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000042', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000043', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000044', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000045', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'SID00000045', N'like')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'SID00000045', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'SID00000045', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000046', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000047', N'none')
GO
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000048', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000049', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000050', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'SID00000050', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'SID00000050', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'SID00000051', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000025', N'SID00000051', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000052', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000053', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000054', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000023', N'SID00000054', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000055', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000056', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000057', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000058', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000059', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000060', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000061', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000062', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000063', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000064', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000066', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000066', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000009', N'SID00000066', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000012', N'SID00000066', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000067', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000067', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000068', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000068', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000069', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000069', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000001', N'SID00000070', N'none')
INSERT [dbo].[InterFaceObject] ([UserID], [ObjectID], [InterFaceID]) VALUES (N'UID00000002', N'SID00000070', N'none')
GO
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'a@a', N'7003525   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'admin123@gmail.com', N'8395397   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'hoangyen25012005@gmail.com', N'6790348   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'khanhndde160504@fpt.edu.vn', N'9188771   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'lantoaniemvui1@gmail.com', N'1266112   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'linh04082002@gmail.com', N'6074790   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'maivantam1978@gmail.com', N'9742722   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'ngocan2002@gmail.com', N'4311645   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'pgxnguyen54@gmail.com', N'0652111   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'phamthevinh955@gmail.com', N'6936331   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N's', N'8273532   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'thinh111190@gmail.com', N'0634196   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'v', N'1379094   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'van123872000@gmail.com', N'0006688   ')
INSERT [dbo].[MAIL] ([Mail], [code]) VALUES (N'vinhptde160443@fpt.edu.vn', N'7284288   ')
GO
INSERT [dbo].[MonthlyUsage] ([MonthDate], [UsageTime]) VALUES (CAST(N'2023-06-01' AS Date), 65825801)
INSERT [dbo].[MonthlyUsage] ([MonthDate], [UsageTime]) VALUES (CAST(N'2023-07-01' AS Date), 236878257)
GO
SET IDENTITY_INSERT [dbo].[NOTE_COMMENT] ON 

INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (1, N'PID00000006', N'UID00000003', N'post', CAST(N'2023-06-21T11:03:55.180' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (2, N'PID00000006', N'UID00000001', N'comment', CAST(N'2023-06-18T23:13:14.580' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (3, N'CID00000012', N'UID00000001', N'comment', CAST(N'2023-06-21T09:10:09.823' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (5, N'CID00000001', N'UID00000001', N'comment', CAST(N'2023-06-21T00:03:03.020' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (6, N'PID00000007', N'UID00000003', N'post', CAST(N'2023-06-21T09:38:33.363' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (7, N'CID00000028', N'UID00000003', N'comment', CAST(N'2023-06-21T09:38:38.287' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (8, N'CID00000027', N'UID00000003', N'comment', CAST(N'2023-06-21T09:38:48.830' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (9, N'CID00000029', N'UID00000003', N'comment', CAST(N'2023-06-21T09:39:01.927' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (10, N'CID00000026', N'UID00000003', N'comment', CAST(N'2023-06-21T09:44:56.953' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (11, N'CID00000025', N'UID00000003', N'comment', CAST(N'2023-06-21T11:10:08.173' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (12, N'CID00000007', N'UID00000001', N'comment', CAST(N'2023-06-21T10:44:39.540' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (13, N'CID00000008', N'UID00000001', N'comment', CAST(N'2023-06-21T10:45:00.420' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (14, N'CID00000030', N'UID00000003', N'comment', CAST(N'2023-06-21T11:04:40.560' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (15, N'PID00000060', N'UID00000001', N'post', CAST(N'2023-07-10T21:08:30.000' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (16, N'PID00000057', N'UID00000001', N'post', CAST(N'2023-06-21T13:54:27.960' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (17, N'PID00000056', N'UID00000001', N'post', CAST(N'2023-06-21T14:02:48.303' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (18, N'CID00000031', N'UID00000001', N'comment', CAST(N'2023-06-22T12:42:26.357' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (19, N'CID00000034', N'UID00000001', N'comment', CAST(N'2023-06-21T21:36:08.340' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (20, N'CID00000035', N'UID00000001', N'comment', CAST(N'2023-06-21T21:36:32.287' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (21, N'PID00000064', N'UID00000001', N'post', CAST(N'2023-06-22T12:10:43.860' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (22, N'PID00000024', N'UID00000003', N'post', CAST(N'2023-07-13T19:34:39.453' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (23, N'CID00000037', N'UID00000012', N'comment', CAST(N'2023-06-22T15:12:54.473' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (24, N'PID00000093', N'UID00000001', N'post', CAST(N'2023-06-22T15:13:58.890' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (25, N'PID00000053', N'UID00000009', N'post', CAST(N'2023-06-22T15:18:09.107' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (26, N'PID00000115', N'UID00000012', N'post', CAST(N'2023-07-12T10:43:07.580' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (27, N'PID00000116', N'UID00000009', N'post', CAST(N'2023-06-24T20:39:23.817' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (28, N'CID00000042', N'UID00000012', N'comment', CAST(N'2023-06-22T15:39:28.387' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (29, N'PID00000126', N'UID00000009', N'post', CAST(N'2023-06-24T20:44:10.083' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (30, N'CID00000050', N'UID00000001', N'comment', CAST(N'2023-06-24T20:45:23.893' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (31, N'PID00000128', N'UID00000012', N'post', CAST(N'2023-06-24T20:49:48.627' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (32, N'PID00000130', N'UID00000009', N'post', CAST(N'2023-07-03T13:40:07.347' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (33, N'CID00000056', N'UID00000001', N'comment', CAST(N'2023-06-28T08:33:09.040' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (34, N'CID00000057', N'UID00000012', N'comment', CAST(N'2023-06-24T20:58:24.460' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (35, N'PID00000133', N'UID00000012', N'post', CAST(N'2023-07-13T19:32:22.440' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (36, N'PID00000132', N'UID00000009', N'post', CAST(N'2023-06-24T22:25:43.433' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (37, N'CID00000060', N'UID00000012', N'comment', CAST(N'2023-06-28T08:20:45.547' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (38, N'CID00000065', N'UID00000001', N'comment', CAST(N'2023-07-02T07:21:11.660' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (39, N'CID00000066', N'UID00000001', N'comment', CAST(N'2023-06-29T20:54:47.270' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (40, N'CID00000064', N'UID00000001', N'comment', CAST(N'2023-07-02T07:22:42.047' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (41, N'CID00000067', N'UID00000001', N'comment', CAST(N'2023-07-02T08:28:35.210' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (42, N'CID00000058', N'UID00000012', N'comment', CAST(N'2023-07-02T08:52:21.860' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (43, N'CID00000077', N'UID00000001', N'comment', CAST(N'2023-07-02T09:03:07.990' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (44, N'CID00000078', N'UID00000001', N'comment', CAST(N'2023-07-02T11:14:56.483' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (45, N'CID00000061', N'UID00000012', N'comment', CAST(N'2023-07-02T17:11:40.757' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (46, N'PID00000127', N'UID00000001', N'post', CAST(N'2023-07-12T10:17:51.180' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (57, N'PID00000050', N'UID00000002', N'post', CAST(N'2023-07-13T20:24:55.163' AS DateTime), 0)
INSERT [dbo].[NOTE_COMMENT] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (58, N'CID00000120', N'UID00000002', N'comment', CAST(N'2023-07-13T20:24:58.297' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[NOTE_COMMENT] OFF
GO
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000001', 2, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000002', 0, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000003', 8, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000004', 4, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000008', 2, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000009', 0, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000010', 0, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000012', 5, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000013', 0, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000020', 0, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000021', 0, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000022', 0, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000023', 5, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000024', 0, 0)
INSERT [dbo].[NOTE_COUNT] ([UserID], [NOTE], [MESS]) VALUES (N'UID00000025', 0, 0)
GO
SET IDENTITY_INSERT [dbo].[NOTE_FRIEND] ON 

INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (7, N'UID00000002', N'UID00000001', N'isFriend', CAST(N'2023-07-13T19:58:09.440' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (8, N'UID00000001', N'UID00000002', N'accepted', CAST(N'2023-07-13T19:58:09.440' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (9, N'UID00000003', N'UID00000001', N'accepted', CAST(N'2023-06-21T08:35:27.443' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (10, N'UID00000001', N'UID00000003', N'isFriend', CAST(N'2023-06-21T08:35:27.447' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (11, N'UID00000008', N'UID00000001', N'sent', CAST(N'2023-07-13T16:29:49.317' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (12, N'UID00000001', N'UID00000008', N'request', CAST(N'2023-07-13T16:29:49.317' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (13, N'UID00000012', N'UID00000001', N'sent', CAST(N'2023-07-14T17:17:40.553' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (14, N'UID00000001', N'UID00000012', N'request', CAST(N'2023-07-14T17:17:40.553' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (15, N'UID00000004', N'UID00000001', N'sent', CAST(N'2023-06-20T11:36:34.797' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (16, N'UID00000001', N'UID00000004', N'request', CAST(N'2023-06-20T11:36:34.800' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (17, N'UID00000009', N'UID00000001', N'isFriend', CAST(N'2023-06-22T14:30:50.167' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (18, N'UID00000001', N'UID00000009', N'accepted', CAST(N'2023-06-22T14:30:50.170' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (19, N'UID00000012', N'UID00000009', N'accepted', CAST(N'2023-06-22T15:38:01.340' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (20, N'UID00000009', N'UID00000012', N'isFriend', CAST(N'2023-06-22T15:38:01.340' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (21, N'UID00000023', N'UID00000001', N'request', CAST(N'2023-07-13T18:34:52.860' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (22, N'UID00000001', N'UID00000023', N'sent', CAST(N'2023-07-13T18:34:52.863' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (23, N'UID00000023', N'UID00000003', N'request', CAST(N'2023-06-22T15:39:24.830' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (24, N'UID00000003', N'UID00000023', N'sent', CAST(N'2023-06-22T15:39:24.830' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (25, N'UID00000009', N'UID00000003', N'isFriend', CAST(N'2023-06-24T21:17:26.153' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (26, N'UID00000003', N'UID00000009', N'accepted', CAST(N'2023-06-24T21:17:26.157' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (27, N'UID00000024', N'UID00000022', N'isFriend', CAST(N'2023-07-10T21:07:40.903' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (28, N'UID00000022', N'UID00000024', N'accepted', CAST(N'2023-07-10T21:07:40.907' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (29, N'UID00000024', N'UID00000001', N'isFriend', CAST(N'2023-07-10T21:07:35.420' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (30, N'UID00000001', N'UID00000024', N'accepted', CAST(N'2023-07-10T21:07:35.423' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (31, N'UID00000025', N'UID00000023', N'isFriend', CAST(N'2023-07-13T18:43:41.553' AS DateTime), 0)
INSERT [dbo].[NOTE_FRIEND] ([ID], [UserID], [UserIDRequest], [statusNote], [TimeRequest], [isRead]) VALUES (32, N'UID00000023', N'UID00000025', N'accepted', CAST(N'2023-07-13T18:43:41.557' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[NOTE_FRIEND] OFF
GO
SET IDENTITY_INSERT [dbo].[NOTE_lIKE] ON 

INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (1, N'CID00000004', N'UID00000001', N'comment', CAST(N'2023-06-18T23:09:16.120' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (2, N'SID00000024', N'UID00000001', N'post', CAST(N'2023-06-18T23:46:57.603' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (3, N'PID00000051', N'UID00000002', N'post', CAST(N'2023-06-19T12:35:32.017' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (4, N'PID00000056', N'UID00000001', N'post', CAST(N'2023-07-02T17:57:47.163' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (5, N'PID00000057', N'UID00000001', N'post', CAST(N'2023-06-19T20:30:51.643' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (6, N'PID00000050', N'UID00000002', N'post', CAST(N'2023-06-19T20:34:09.350' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (7, N'SID00000028', N'UID00000001', N'post', CAST(N'2023-06-20T20:39:47.170' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (8, N'ILD00000003', N'UID00000001', N'comment', CAST(N'2023-06-21T06:47:50.153' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (9, N'CID00000001', N'UID00000001', N'comment', CAST(N'2023-06-21T06:41:25.600' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (10, N'CID00000012', N'UID00000001', N'comment', CAST(N'2023-06-21T11:03:46.820' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (11, N'ILD00000007', N'UID00000001', N'comment', CAST(N'2023-06-21T10:33:24.313' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (12, N'ILD00000006', N'UID00000001', N'comment', CAST(N'2023-06-21T08:50:59.503' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (13, N'CID00000009', N'UID00000001', N'comment', CAST(N'2023-06-21T10:42:56.450' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (14, N'CID00000008', N'UID00000001', N'comment', CAST(N'2023-06-21T10:43:11.003' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (15, N'ILD00000041', N'UID00000003', N'comment', CAST(N'2023-06-21T09:40:23.470' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (16, N'PID00000007', N'UID00000003', N'post', CAST(N'2023-06-21T09:41:25.313' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (17, N'ILD00000042', N'UID00000003', N'comment', CAST(N'2023-06-21T09:44:40.370' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (18, N'ILD00000043', N'UID00000003', N'comment', CAST(N'2023-06-21T10:06:34.267' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (19, N'ILD00000037', N'UID00000003', N'comment', CAST(N'2023-06-21T09:46:46.193' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (20, N'ILD00000035', N'UID00000003', N'comment', CAST(N'2023-06-21T10:00:59.240' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (21, N'ILD00000036', N'UID00000003', N'comment', CAST(N'2023-06-21T09:47:35.930' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (22, N'CID00000028', N'UID00000003', N'comment', CAST(N'2023-06-21T09:47:47.583' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (23, N'CID00000029', N'UID00000003', N'comment', CAST(N'2023-06-21T10:06:41.840' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (24, N'CID00000026', N'UID00000003', N'comment', CAST(N'2023-06-21T10:06:36.380' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (25, N'CID00000025', N'UID00000003', N'comment', CAST(N'2023-06-21T10:43:02.050' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (26, N'ILD00000012', N'UID00000003', N'comment', CAST(N'2023-06-21T10:42:54.527' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (27, N'CID00000007', N'UID00000001', N'comment', CAST(N'2023-06-21T10:42:58.223' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (28, N'ILD00000058', N'UID00000003', N'comment', CAST(N'2023-06-21T11:09:58.137' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (29, N'CID00000030', N'UID00000003', N'comment', CAST(N'2023-06-21T11:09:59.467' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (30, N'ILD00000051', N'UID00000003', N'comment', CAST(N'2023-06-21T11:10:01.740' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (31, N'PID00000025', N'UID00000003', N'post', CAST(N'2023-06-21T12:59:33.473' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (32, N'PID00000060', N'UID00000001', N'post', CAST(N'2023-06-21T19:28:37.080' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (33, N'CID00000031', N'UID00000001', N'comment', CAST(N'2023-06-21T20:16:19.133' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (34, N'CID00000035', N'UID00000001', N'comment', CAST(N'2023-06-22T08:29:28.650' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (35, N'PID00000024', N'UID00000003', N'post', CAST(N'2023-07-13T19:26:09.117' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (36, N'PID00000115', N'UID00000012', N'post', CAST(N'2023-06-22T16:36:52.683' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (37, N'SID00000045', N'UID00000012', N'post', CAST(N'2023-07-12T09:21:11.513' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (38, N'CID00000044', N'UID00000009', N'comment', CAST(N'2023-06-22T15:59:59.853' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (39, N'CID00000040', N'UID00000012', N'comment', CAST(N'2023-06-22T16:00:02.890' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (40, N'PID00000116', N'UID00000009', N'post', CAST(N'2023-06-23T09:28:20.233' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (41, N'PID00000114', N'UID00000012', N'post', CAST(N'2023-06-22T16:36:54.220' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (42, N'PID00000113', N'UID00000012', N'post', CAST(N'2023-06-22T16:36:55.557' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (43, N'PID00000123', N'UID00000001', N'post', CAST(N'2023-06-23T09:53:43.553' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (44, N'PID00000053', N'UID00000009', N'post', CAST(N'2023-06-23T10:59:34.967' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (45, N'SID00000027', N'UID00000012', N'post', CAST(N'2023-06-23T11:07:50.120' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (46, N'PID00000126', N'UID00000009', N'post', CAST(N'2023-06-24T20:43:59.977' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (47, N'ILD00000069', N'UID00000009', N'comment', CAST(N'2023-06-24T20:45:25.277' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (48, N'PID00000128', N'UID00000012', N'post', CAST(N'2023-06-24T20:48:38.590' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (49, N'CID00000052', N'UID00000012', N'comment', CAST(N'2023-06-24T20:49:03.517' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (50, N'PID00000130', N'UID00000009', N'post', CAST(N'2023-06-24T22:14:36.663' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (51, N'PID00000133', N'UID00000012', N'post', CAST(N'2023-06-29T20:24:08.430' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (52, N'PID00000134', N'UID00000001', N'post', CAST(N'2023-06-24T21:19:18.820' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (53, N'CID00000078', N'UID00000001', N'comment', CAST(N'2023-07-02T20:23:11.050' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (54, N'CID00000079', N'UID00000001', N'comment', CAST(N'2023-07-02T20:23:14.410' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (55, N'ILD00000073', N'UID00000009', N'comment', CAST(N'2023-07-02T20:23:22.133' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (56, N'PID00000132', N'UID00000009', N'post', CAST(N'2023-07-10T21:33:12.810' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (58, N'PID00000166', N'UID00000012', N'post', CAST(N'2023-07-12T09:21:18.440' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (60, N'AID00000002', N'UID00000001', N'post', CAST(N'2023-07-14T04:28:16.297' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (61, N'AID00000001', N'UID00000001', N'post', CAST(N'2023-07-12T13:26:03.490' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (62, N'PID00000168', N'UID00000001', N'post', CAST(N'2023-07-13T02:55:17.270' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (63, N'AID00000011', N'UID00000012', NULL, CAST(N'2023-07-13T11:00:57.750' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (64, N'AID00000011', N'UID00000001', NULL, CAST(N'2023-07-13T10:54:08.340' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (65, N'AID00000002', N'UID00000009', NULL, CAST(N'2023-07-13T10:59:25.183' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (66, N'PID00000111', N'UID00000012', N'post', CAST(N'2023-07-13T10:58:39.203' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (67, N'AID00000011', N'UID00000009', NULL, CAST(N'2023-07-13T10:59:35.007' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (68, N'SID00000066', N'UID00000001', N'post', CAST(N'2023-07-13T11:06:24.937' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (69, N'ILD00000066', N'UID00000001', N'comment', CAST(N'2023-07-13T19:45:45.803' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (70, N'CID00000116', N'UID00000023', N'comment', CAST(N'2023-07-13T19:45:18.487' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (71, N'CID00000115', N'UID00000023', N'comment', CAST(N'2023-07-13T19:45:20.013' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (72, N'ILD00000064', N'UID00000012', N'comment', CAST(N'2023-07-13T19:45:28.523' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (73, N'AID00000015', N'UID00000001', NULL, CAST(N'2023-07-14T04:28:10.867' AS DateTime), 0)
INSERT [dbo].[NOTE_lIKE] ([ID], [ObjectID], [UserID], [statusNote], [TimeComment], [isRead]) VALUES (74, N'PID00000110', N'UID00000012', N'post', CAST(N'2023-07-14T04:28:17.590' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[NOTE_lIKE] OFF
GO
SET IDENTITY_INSERT [dbo].[POST] ON 

INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (5, N'UID00000003', N'', N'data/post/PID00000005/Sharingan_17_08_2016_5.jpg', CAST(N'2023-06-10T09:45:28.490' AS DateTime), 2, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (6, N'UID00000003', N'', N'data/post/PID00000006/Sharingan_17_08_2016_5.jpg', CAST(N'2023-06-10T09:45:33.883' AS DateTime), 5, 12, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (7, N'UID00000003', N'', N'data/post/PID00000007/ai-image-enlarger-1-after-2.jpg', CAST(N'2023-06-10T09:45:40.710' AS DateTime), 5, 4, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (8, N'UID00000003', N'', N'data/post/PID00000008/Hinh-anh-background-de-thuong-chu-tho-va-cau-vong.jpg', CAST(N'2023-06-10T09:45:47.197' AS DateTime), 1, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (23, N'UID00000003', N'', N'', CAST(N'2023-06-10T10:43:43.400' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (24, N'UID00000003', N'', N'data/post/PID00000024/Sharingan_17_08_2016_5.jpg', CAST(N'2023-06-10T10:43:48.183' AS DateTime), 5, 4, 1, N'PUBLIC')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (25, N'UID00000003', N'', N'data/post/PID00000025/hinh-anh-cute.jpg', CAST(N'2023-06-10T12:50:26.563' AS DateTime), 2, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (34, N'UID00000003', N'', N'data/post/PID00000034/Nam.png', CAST(N'2023-06-11T21:40:59.947' AS DateTime), 0, 0, 0, N'PRIVATE')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (50, N'UID00000002', N'', N'', CAST(N'2023-06-12T12:04:48.320' AS DateTime), 3, 1, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (53, N'UID00000009', N'ahihi', N'data/post/PID00000053/ava3.jpg', CAST(N'2023-06-17T14:32:34.013' AS DateTime), 2, 1, 1, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (54, N'UID00000012', N'dep', N'data/post/PID00000054/one-piece-samurai-roronoa-zoro-wallpaper-960x600_1.jpg', CAST(N'2023-06-17T14:39:36.550' AS DateTime), 2, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (56, N'UID00000001', N'BoJack Horseman là một bộ phim truyền hình trực tuyến hài-chính kịch đen hoạt hình dành cho người lớn của Hoa Kỳ được sáng tạo bởi Raphael Bob-Waksberg. Phim có sự tham gia lồng tiếng của dàn diễn viên thực lực bao gồm Will Arnett, Amy Sedaris, Alison Brie, Paul F. Tompkins và Aaron Paul.', N'data/post/PID00000056/bojack_horseman_s06e01_0m19s463f.webp', CAST(N'2023-06-19T08:00:11.670' AS DateTime), 5, 1, 1, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (96, N'UID00000023', N'không anh chứ ai đố em tìm được ai giống anh thứ 2', N'data/post/PID00000096/tải xuống.jpg', CAST(N'2023-06-22T15:23:30.903' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (97, N'UID00000012', N'', N'data/post/PID00000097/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:26.177' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (98, N'UID00000012', N'', N'data/post/PID00000098/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:27.433' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (99, N'UID00000012', N'', N'data/post/PID00000099/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:27.850' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (100, N'UID00000012', N'', N'data/post/PID00000100/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:27.957' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (101, N'UID00000012', N'', N'data/post/PID00000101/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:28.103' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (102, N'UID00000012', N'', N'data/post/PID00000102/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:28.277' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (103, N'UID00000012', N'', N'data/post/PID00000103/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:28.390' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (104, N'UID00000012', N'', N'data/post/PID00000104/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:28.580' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (105, N'UID00000012', N'', N'data/post/PID00000105/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:28.720' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (106, N'UID00000012', N'', N'data/post/PID00000106/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:28.870' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (107, N'UID00000012', N'', N'data/post/PID00000107/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:29.023' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (108, N'UID00000012', N'', N'data/post/PID00000108/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:29.237' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (110, N'UID00000012', N'', N'data/post/PID00000110/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:29.560' AS DateTime), 1, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (111, N'UID00000012', N'', N'data/post/PID00000111/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:29.713' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (112, N'UID00000012', N'', N'data/post/PID00000112/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:29.890' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (113, N'UID00000012', N'', N'data/post/PID00000113/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:30.067' AS DateTime), 1, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (115, N'UID00000012', N'', N'data/post/PID00000115/355176573_1058594965549550_5947632610555889368_n.jpg', CAST(N'2023-06-22T15:36:30.457' AS DateTime), 2, 6, 1, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (116, N'UID00000009', N'cá mập mèo', N'data/post/PID00000116/355442160_629710562429350_2037000583623077674_n.jpg', CAST(N'2023-06-22T15:37:05.260' AS DateTime), 2, 4, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (125, N'UID00000012', N'hello everyone', N'data/post/PID00000125/one-piece-samurai-roronoa-zoro-wallpaper-960x600_1.jpg', CAST(N'2023-06-24T20:40:16.513' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (130, N'UID00000009', N'gayyyyyyyyyyyyyyyyyyy', N'data/post/PID00000130/292965147_5246409925454588_4370988743364239490_n.png', CAST(N'2023-06-24T20:55:10.510' AS DateTime), 1, 8, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (132, N'UID00000009', N'Chuyện là hôm thứ 5 vừa rồi tôi có đi siêu thị. Vào khoảng tầm 8h15, khi tôi đang đi dạo quanh siêu thị thì thấy 1 nhóm người khả nghi đứng sau cứ nhìn vào tôi. Lúc đầu tôi chỉ nghĩ đó là tình cờ. Nhưng không, tôi đi đến đâu thì họ lại theo đến đấy. Và vào khoảng 8h30, khi tôi đang đi thang máy xuống tầng 1 để đi về thì tôi vẫn thấy họ ở phía sau. Tôi đã nhanh trí chụp lại những gương mặt có tố chất phạm tội này. Tôi hy vọng mọi người hãy cẩn thận để đừng gặp trường hợp như tôi. Nếu có thể thì mọi người báo công an để bắt tụi nó luôn nhé', N'data/post/PID00000132/353677244_735674244975581_6957621185721467017_n.jpg', CAST(N'2023-06-24T21:02:03.797' AS DateTime), 1, 1, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (133, N'UID00000012', N'Xin chào!

Tôi là một sinh viên FPT, và tôi tự hào rằng mình là một phần của cộng đồng trường này. Từ khi gia nhập FPT, tôi đã trót yêu trường và tận hưởng những trải nghiệm học tập và rèn luyện tại đây.

FPT là một trong những trường đại học hàng đầu tại Việt Nam với chất lượng giáo dục cao cùng với môi trường học tập đầy phấn khích. Tôi đã được học tập từ những giảng viên có kinh nghiệm và nhiệt huyết, luôn sẵn sàng hỗ trợ và chia sẻ kiến thức để giúp sinh viên phát triển tối đa tiềm năng của mình.

Ngoài việc được tiếp xúc với kiến thức chuyên ngành, FPT còn tạo điều kiện cho sinh viên tham gia vào các hoạt động ngoại khóa phong phú. Tôi đã có cơ hội tham gia vào các câu lạc bộ, tổ chức sinh viên và các dự án nghiên cứu. Nhờ đó, tôi đã có cơ hội rèn kỹ năng mềm, mở rộng mạng lưới quan hệ và trải nghiệm thực tế trong lĩnh vực mình quan tâm.

Sinh viên FPT không chỉ được khuyến khích học tập mà còn được trau dồi kỹ năng lãnh đạo và sáng tạo. Trường đã tạo ra môi trường thân thiện và sáng tạo, tạo điều kiện cho sinh viên thể hiện ý tưởng và phát triển khả năng sáng tạo của mình.

Tôi tin rằng việc học tại FPT sẽ mang lại cho tôi một nền tảng vững chắc để đạt được thành công trong tương lai. Tôi cảm thấy tự hào khi nói rằng tôi là một sinh viên FPT và hy vọng có thể đóng góp tích cực cho cộng đồng trường và xã hội.

Cảm ơn đã đọc về tôi và tình yêu của tôi dành cho trường FPT!', N'', CAST(N'2023-06-24T21:17:38.597' AS DateTime), 2, 2, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (166, N'UID00000012', N'Gia Lai là một tỉnh nằm ở miền Trung Việt Nam, mang trong mình một vẻ đẹp tự nhiên hoang sơ và văn hóa đậm đà dân tộc. Đất nước Gia Lai tựa như một bức tranh sắc màu, hòa quyện giữa những ngọn đồi xanh ngút ngàn, những dòng sông uốn lượn và những cánh đồng mênh mông bạt ngàn.

Gia Lai nổi tiếng với vùng đất Tây Nguyên, nơi có cảnh quan hùng vĩ và thổ nhưỡng phong phú. Vùng đất này chứa đựng những rừng tràm, những cánh đồng lúa chín rợp trời và những thác nước hoang sơ tuyệt đẹp. Các dãy núi cao ngất ngưởng cùng những thảo nguyên bát ngát tạo nên một bức tranh thiên nhiên tuyệt vời, khiến cho du khách không thể rời mắt.

Không chỉ với cảnh quan thiên nhiên đẹp mắt, Gia Lai còn có di sản văn hóa phong phú của các dân tộc thiểu số. Tại đây, du khách có thể khám phá và trải nghiệm nét văn hóa đa dạng của các dân tộc như Gia Rai, Bahnar, J''rai và Xơ Đăng. Những nét văn hóa truyền thống, những bài hát và điệu múa đặc sắc mang đậm tính bản sắc dân tộc sẽ làm say lòng bất kỳ ai tới thăm.

Ngoài ra, Gia Lai còn có thành phố Pleiku - trung tâm hành chính và kinh tế của tỉnh. Thành phố này là một điểm đến hấp dẫn với các công trình kiến trúc độc đáo như Nhà thờ Đức Mẹ Fatima, Nhà thờ Thánh Anthony và hồ Pleiku rực rỡ sắc màu. Nơi đây cũng có thị trấn Kon Tum, nằm ven sông Đăk Bla và nổi tiếng với những ngôi nhà gỗ cổ kính, những ngôi chùa đậm chất tâm linh và sự yên bình của đồng quê miền Trung.

Đất nước Gia Lai, với cảnh quan hùng vĩ và văn hóa đa dạng, là một điểm đến lý tưởng cho du khách muốn tìm hiểu về vẻ đẹp tự nhiên và sự đa dạng văn hóa của Việt Nam. Hãy đến và khám phá Gia Lai, nơi bạn sẽ được chìm đắm trong một thế giới đầy màu sắc và kỷ niệm khó quên.', N'', CAST(N'2023-07-10T22:07:33.700' AS DateTime), 1, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (169, N'UID00000022', N'Blue-Eyes White Dragon''s Roar: Kamen Rider Blue-Eyes White Dragon phát ra một tiếng gầm mạnh mẽ từ hơi thở của nó, tạo ra một làn sóng năng lượng mạnh mẽ tấn công kẻ thù.
Burst Stream of Destruction: Kamen Rider Blue-Eyes White Dragon phun ra một luồng tia năng lượng màu xanh dương từ miệng, tạo ra một cơn bão hủy diệt cháy xanh xung quanh kẻ địch.
White Lightning: Kamen Rider Blue-Eyes White Dragon phóng ra một loạt tia sét màu trắng từ cánh tay, gây sát thương điện và làm tê liệt đối thủ.
Blue-Eyes Ultimate Destruction: Kamen Rider Blue-Eyes White Dragon hợp thể với Blue-Eyes Ultimate Dragon, tăng cường sức mạnh và tạo ra một cú đánh tấn công tối đa với sự hủy diệt toàn diện.
Azure-Eyes Silver Dragon''s Protection: Kamen Rider Blue-Eyes White Dragon triệu hồi Azure-Eyes Silver Dragon để bảo vệ bản thân và đồng đội khỏi các tác động xấu.
Return of the Dragon Lords: Kamen Rider Blue-Eyes White Dragon triệu hồi lại các vị thần rồng để bảo vệ mình và hồi phục sức mạnh.
Melody of Awakening Dragon: Kamen Rider Blue-Eyes White Dragon chơi một giai điệu cổ điển truyền thống để triệu hồi các con rồng từ tay hay bộ giáp của anh ta.
Dragon''s Mirror: Kamen Rider Blue-Eyes White Dragon sử dụng gương rồng để hợp thể với các rồng khác và tạo ra một dạng hợp thể mới với sức mạnh vượt trội.
White Stone of Legend''s Wisdom: Kamen Rider Blue-Eyes White Dragon sử dụng trí tuệ của White Stone of Legend để tăng cường khả năng chiến đấu và đọc hiểu tình huống chiến đấu.
Dragon Spirit of White''s Purification: Kamen Rider Blue-Eyes White Dragon triệu hồi Dragon Spirit of White để tinh lọc và tiêu diệt các thực thể tà ác.
Silver''s Cry: Kamen Rider Blue-Eyes White Dragon sử dụng nước mắt của Silver''s Cry để hồi sinh và cung cấp sức mạnh cho mình và đồng đội.
Sage with Eyes of Blue''s Guidance: Kamen Rider Blue-Eyes White Dragon nhờ sự chỉ dẫn của Sage with Eyes of Blue để tìm ra điểm yếu của đối thủ và tấn công một cách chính xác.
Blue-Eyes Alternative White Dragon''s Evolution: Kamen Rider Blue-Eyes White Dragon tiến hóa thành Blue-Eyes Alternative White Dragon, tăng cường sức mạnh và tốc độ đánh đối thủ.
Dragon Shrine''s Connection: Kamen Rider Blue-Eyes White Dragon sử dụng Dragon Shrine để thiết lập liên kết với linh hồn của các rồng khác và chia sẻ sức mạnh với họ.
Maiden with Eyes of Blue''s Protection: Kamen Rider Blue-Eyes White Dragon triệu hồi Maiden with Eyes of Blue để bảo vệ mình và đồng đội khỏi các tác động xấu.
Dragon Ravine''s Destruction: Kamen Rider Blue-Eyes White Dragon sử dụng Dragon Ravine để tạo ra một cảnh quan hỗn loạn, làm rối loạn đối thủ và giảm sức mạnh của họ.
Master with Eyes of Blue''s Wisdom: Kamen Rider Blue-Eyes White Dragon nhờ sự khôn ngoan của Master with Eyes of Blue để tìm ra điểm yếu và chiến thuật tốt nhất để đánh bại kẻ thù.
Beacon of White: Kamen Rider Blue-Eyes White Dragon phát ra một tia sáng mạnh mẽ từ ngực, tạo ra một điểm nhấn cho đồng đội và cung cấp sức mạnh tinh thần.
Trade-In: Kamen Rider Blue-Eyes White Dragon sử dụng Trade-In để đổi các lá bài không cần thiết để tìm ra những lá bài quan trọng và mạnh mẽ hơn.
Silver''s Edge: Kamen Rider Blue-Eyes White Dragon sử dụng Silver''s Edge, một vũ khí lưỡi cưa mạnh mẽ, để tấn công và đánh đối thủ.
Burst Rebirth: Kamen Rider Blue-Eyes White Dragon sử dụng Burst Rebirth để hồi sinh sau khi bị hạ gục và tiếp tục chiến đấu với năng lượng tái sinh mới mạnh mẽ hơn.
Return of the Dragon Lords'' Protection: Kamen Rider Blue-Eyes White Dragon triệu hồi các vị thần rồng để bảo vệ mình và đồng đội khỏi các tác động xấu.
White Night Dragon''s Light: Kamen Rider Blue-Eyes White Dragon triệu hồi White Night Dragon để tạo ra một vùng ánh sáng mạnh mẽ, làm mất tầm nhìn của đối thủ.
Blue-Eyes Twin Burst Dragon''s Combination: Kamen Rider Blue-Eyes White Dragon hợp thể với Blue-Eyes Twin Burst Dragon, tăng cường sức mạnh và tạo ra một cú đánh tấn công đôi đặc biệt.
Dragon Revival Rhapsody: Kamen Rider Blue-Eyes White Dragon sử dụng Dragon Revival Rhapsody để triệu hồi lại các rồng đã bị tiêu diệt và mang lại sức mạnh cho đồng đội.
The White Stone of Ancients'' Ancient Knowledge: Kamen Rider Blue-Eyes White Dragon sử dụng tri thức cổ xưa từ The White Stone of Ancients để tìm hiểu về kẻ thù và tìm ra điểm yếu của họ.
Blue-Eyes Chaos Dragon''s Chaos Power: Kamen Rider Blue-Eyes White Dragon triệu hồi Blue-Eyes Chaos Dragon để sử dụng sức mạnh hỗn loạn và tạo ra những cuộc tấn công mạnh mẽ và khó đoán.
Deep-Eyes White Dragon''s Gaze: Kamen Rider Blue-Eyes White Dragon sử dụng ánh mắt của Deep-Eyes White Dragon để xuyên thấu và phát hiện các điểm yếu ẩn của đối thủ.
Dragon Shrine''s Connection: Kamen Rider Blue-Eyes White Dragon sử dụng Dragon Shrine để thiết lập liên kết với linh hồn của các rồng khác và chia sẻ sức mạnh với họ.
Ancient Rules: Kamen Rider Blue-Eyes White Dragon sử dụng Ancient Rules để triệu hồi Blue-Eyes White Dragon từ tay hay bộ giáp của mình trực tiếp lên chiến trường.
Burst Breath: Kamen Rider Blue-Eyes White Dragon phun ra một luồng hơi thở mạnh mẽ từ miệng, tạo ra một cơn bão lửa xanh xung quanh kẻ địch.
Majesty with Eyes of Blue''s Authority: Kamen Rider Blue-Eyes White Dragon nhờ sự uy quyền của Majesty with Eyes of Blue để tăng cường khả năng chiến đấu và lãnh đạo.
Blue-Eyes Chaos MAX Dragon''s Absolute Destruction: Kamen Rider Blue-Eyes White Dragon triệu hồi Blue-Eyes Chaos MAX Dragon để tạo ra một cú đánh tấn công tuyệt đối với sức mạnh hủy diệt vô cùng.
Shining Draw: Kamen Rider Blue-Eyes White Dragon sử dụng Shining Draw để rút thêm lá bài và tăng khả năng tấn công trong trận đấu.
Dragon Shrine''s Blessing: Kamen Rider Blue-Eyes White Dragon sử dụng Dragon Shrine để nhận được sự ban phước từ các linh hồn rồng và tăng cường sức mạnh của mình.
Burst Stream of Destruction: Kamen Rider Blue-Eyes White Dragon phun ra một dòng tấn công mạnh mẽ từ miệng, tạo ra một luồng nước sôi chảy tới đối thủ và gây ra sự tàn phá.
Chaos Form Transformation: Kamen Rider Blue-Eyes White Dragon chuyển đổi sang dạng Chaos Form, tăng cường sức mạnh và tốc độ đánh đối thủ.
Burst Rebirth: Kamen Rider Blue-Eyes White Dragon sử dụng Burst Rebirth để hồi sinh sau khi bị hạ gục và tiếp tục chiến đấu với năng lượng tái sinh mới mạnh mẽ hơn.
Blue-Eyes Alternative Ultimate Dragon''s Fusion: Kamen Rider Blue-Eyes White Dragon hợp thể với Blue-Eyes Alternative Ultimate Dragon, tạo ra một sức mạnh tuyệt đối và đánh đối thủ một cách không thể tránh được.
Azure-Eyes Silver Dragon''s Protection: Kamen Rider Blue-Eyes White Dragon triệu hồi Azure-Eyes Silver Dragon để bảo vệ mình và đồng đội khỏi các tác động xấu và tấn công từ đối thủ.
Chaos Emperor Dragon - Envoy of the End''s Judgment: Kamen Rider Blue-Eyes White Dragon triệu hồi Chaos Emperor Dragon - Envoy of the End để tạo ra một cú đánh tuyệt đối và đưa kẻ thù vào sự hủy diệt tuyệt đối.
Melody of Awakening Dragon: Kamen Rider Blue-Eyes White Dragon sử dụng Melody of Awakening Dragon để triệu hồi các rồng mạnh mẽ khác từ tay hay bộ giáp của mình trực tiếp lên chiến trường.
Silver''s Cry: Kamen Rider Blue-Eyes White Dragon sử dụng nước mắt của Silver''s Cry để hồi sinh và cung cấp sức mạnh cho mình và đồng đội.
Chaos End Ruler - Ruler of the Beginning and the End''s Dominion: Kamen Rider Blue-Eyes White Dragon triệu hồi Chaos End Ruler - Ruler of the Beginning and the End để kiểm soát và sử dụng sức mạnh của cả khởi đầu và kết thúc, đảo lộn tình thế chiến đấu.
Dragon Spirit of White''s Spirit Control: Kamen Rider Blue-Eyes White Dragon sử dụng Dragon Spirit of White để kiểm soát tinh thần và linh hồn của các rồng trắng, sử dụng sức mạnh của chúng trong trận đấu.
Blue-Eyes Ultimate Dragon''s Fusion: Kamen Rider Blue-Eyes White Dragon hợp thể với Blue-Eyes Ultimate Dragon, tạo ra một sinh vật siêu mạnh có sức tấn công và phòng thủ vượt trội.
Chaos End Master - Master of the Chaos'' Manipulation: Kamen Rider Blue-Eyes White Dragon triệu hồi Chaos End Master - Master of the Chaos để kiểm soát và điều khiển sức mạnh hỗn loạn và tạo ra những hiệu ứng không thể dự đoán trong trận đấu.
Sage with Eyes of Blue''s Wisdom: Kamen Rider Blue-Eyes White Dragon sử dụng Sage with Eyes of Blue để nhận được sự hỗ trợ và lời khuyên thông minh từ người học trò của mình, nâng cao khả năng tư duy và chiến thuật.
Dragon Shrine''s Resonance: Kamen Rider Blue-Eyes White Dragon sử dụng Dragon Shrine để thiết lập liên kết với các linh hồn rồng khác và tạo ra một sự tương tác mạnh mẽ giữa các rồng trong trận đấu.
Blue-Eyes Spirit Dragon''s Sealing Power: Kamen Rider Blue-Eyes White Dragon triệu hồi Blue-Eyes Spirit Dragon để sử dụng sức mạnh phong ấn và khóa chặt các kỹ năng và sức mạnh của đối thủ.
Burst Return: Kamen Rider Blue-Eyes White Dragon sử dụng Burst Return để trở về vị trí ban đầu sau một đòn tấn công và lập tức phản công đối thủ.
Ultimate Dragon Formation: Kamen Rider Blue-Eyes White Dragon sử dụng Ultimate Dragon Formation để hợp thể với tất cả các dạng và biến thể của Blue-Eyes White Dragon, tạo ra một sức mạnh tuyệt đối không thể đối phó.
', N'', CAST(N'2023-07-13T11:03:12.147' AS DateTime), 0, 0, 0, N'FRIEND')
INSERT [dbo].[POST] ([ID], [UserID], [Content], [ImagePost], [TimePost], [NumInterface], [NumComment], [NumShare], [PrivacyID]) VALUES (171, N'UID00000025', N'chào mừng bạn đến với chúng tôi', N'data/post/PID00000171/tải xuống.jpg', CAST(N'2023-07-13T19:06:43.900' AS DateTime), 0, 0, 0, N'FRIEND')
SET IDENTITY_INSERT [dbo].[POST] OFF
GO
SET IDENTITY_INSERT [dbo].[POSTSHARE] ON 

INSERT [dbo].[POSTSHARE] ([ID], [UserID], [PostID], [Content], [TimeShare], [NumInterface], [NumComment], [PrivacyID]) VALUES (27, N'UID00000012', N'PID00000053', N'xau qua', CAST(N'2023-06-17T14:37:25.887' AS DateTime), 2, 1, N'PUBLIC')
INSERT [dbo].[POSTSHARE] ([ID], [UserID], [PostID], [Content], [TimeShare], [NumInterface], [NumComment], [PrivacyID]) VALUES (45, N'UID00000012', N'PID00000115', N'cool', CAST(N'2023-06-22T15:37:33.750' AS DateTime), 1, 6, N'PUBLIC')
INSERT [dbo].[POSTSHARE] ([ID], [UserID], [PostID], [Content], [TimeShare], [NumInterface], [NumComment], [PrivacyID]) VALUES (51, N'UID00000023', N'PID00000024', N'i like this', CAST(N'2023-06-29T20:43:33.973' AS DateTime), 0, 2, N'FRIEND')
INSERT [dbo].[POSTSHARE] ([ID], [UserID], [PostID], [Content], [TimeShare], [NumInterface], [NumComment], [PrivacyID]) VALUES (66, N'UID00000001', N'PID00000056', N'BoJack Horseman là một bộ phim tuyệt vời!!! quàooo', CAST(N'2023-07-13T02:34:05.817' AS DateTime), 2, 0, N'FRIEND')
SET IDENTITY_INSERT [dbo].[POSTSHARE] OFF
GO
INSERT [dbo].[Privacy] ([PrivacyID], [PrivacyName]) VALUES (N'FRIEND', N'Friend')
INSERT [dbo].[Privacy] ([PrivacyID], [PrivacyName]) VALUES (N'PRIVATE', N'Private')
INSERT [dbo].[Privacy] ([PrivacyID], [PrivacyName]) VALUES (N'PUBLIC', N'Public')
GO
SET IDENTITY_INSERT [dbo].[ReportComment1686] ON 

INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (1, N'CID00000035', N'UID00000001', N'UID00000001', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (29, N'CID00000034', N'UID00000001', N'UID00000001', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (45, N'CID00000031', N'UID00000001', N'UID00000001', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (54, N'CID00000041', N'UID00000001', N'UID00000012', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (55, N'CID00000044', N'UID00000012', N'UID00000009', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (56, N'CID00000040', N'UID00000012', N'UID00000012', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (57, N'CID00000045', N'UID00000001', N'UID00000009', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (58, N'CID00000061', N'UID00000001', N'UID00000012', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (59, N'CID00000079', N'UID00000001', N'UID00000001', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (60, N'CID00000057', N'UID00000001', N'UID00000012', 1, 0)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (62, N'ILD00000073', N'UID00000001', NULL, 1, 0)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (65, N'ILD00000084', N'UID00000001', NULL, 1, 0)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (66, N'CID00000054', N'UID00000001', N'UID00000012', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (67, N'CID00000053', N'UID00000001', N'UID00000009', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (68, N'CID00000052', N'UID00000001', N'UID00000012', 1, 1)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (69, N'CID00000117', N'UID00000001', N'UID00000002', 1, 0)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (70, N'CID00000119', N'UID00000001', N'UID00000002', 1, 0)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (71, N'ILD00000183', N'UID00000001', N'UID00000002', 1, 0)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (76, N'ILD00000183', N'UID00000001', N'UID00000002', 0, 0)
INSERT [dbo].[ReportComment1686] ([ID], [CommentID], [UserID], [UserID2], [IsPost], [Status]) VALUES (77, N'CID00000120', N'UID00000001', N'UID00000002', 1, 0)
SET IDENTITY_INSERT [dbo].[ReportComment1686] OFF
GO
SET IDENTITY_INSERT [dbo].[ReportPost] ON 

INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (40, N'PID00000132', N'UID00000001', N'UID00000009', 1, 1)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (41, N'PID00000159', N'UID00000012', N'UID00000001', 1, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (42, N'PID00000094', N'UID00000001', N'UID00000012', 1, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (43, N'PID00000114', N'UID00000001', N'UID00000012', 1, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (44, N'PID00000115', N'UID00000001', N'UID00000012', 1, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (45, N'PID00000128', N'UID00000001', N'UID00000012', 1, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (46, N'SID00000045', N'UID00000001', N'UID00000012', 0, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (50, N'PID00000109', N'UID00000001', N'UID00000012', 1, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (51, N'PID00000051', N'UID00000001', N'UID00000002', 1, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (52, N'SID00000068', N'UID00000001', N'UID00000002', 0, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (53, N'SID00000069', N'UID00000001', N'UID00000002', 0, 0)
INSERT [dbo].[ReportPost] ([ID], [PostID], [UserID], [UserID2], [IsPost], [Status]) VALUES (54, N'SID00000070', N'UID00000001', N'UID00000002', 0, 0)
SET IDENTITY_INSERT [dbo].[ReportPost] OFF
GO
SET IDENTITY_INSERT [dbo].[ReportUser1686] ON 

INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (1, N'UID00000002', N'UID00000001', 0)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (2, N'UID00000009', N'UID00000001', 1)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (6, N'UID00000003', N'UID00000004', 0)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (11, N'UID00000008', N'UID00000001', 0)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (12, N'UID00000020', N'UID00000001', 0)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (13, N'UID00000009', N'UID00000012', 0)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (14, N'UID00000012', N'UID00000001', 1)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (15, N'UID00000001', N'UID00000012', 0)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (16, N'UID00000001', N'UID00000024', 0)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (18, N'UID00000022', N'UID00000024', 0)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (19, N'UID00000024', N'UID00000001', 0)
INSERT [dbo].[ReportUser1686] ([ID], [UserID], [UserIDRP], [Status]) VALUES (26, N'UID00000001', N'UID00000004', 1)
SET IDENTITY_INSERT [dbo].[ReportUser1686] OFF
GO
INSERT [dbo].[Role] ([RoleID], [RoleName]) VALUES (N'ADMIN', N'Admin')
INSERT [dbo].[Role] ([RoleID], [RoleName]) VALUES (N'DELETED', N'4489')
INSERT [dbo].[Role] ([RoleID], [RoleName]) VALUES (N'Lock', N'1895')
INSERT [dbo].[Role] ([RoleID], [RoleName]) VALUES (N'MASTERADMIN', N'Master Admin')
INSERT [dbo].[Role] ([RoleID], [RoleName]) VALUES (N'USER', N'User')
GO
SET IDENTITY_INSERT [dbo].[UserInfor] ON 

INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (1, N'viet080702', N'$argon2i$v=19$m=65536,t=28,p=1$2UXy45Qt9NKGsPv42ip9kQ$4Z6V4GNiHfMddAxnNTI2sHJ5cX2UKZBvFC+79ZkQuy8', N'Nguyen Anh Viet', N'Quảng Ngãi', N'van123872000@gmail.com', N'0384859541     ', CAST(N'2002-07-08' AS Date), 1, N'Việt Nam       ', N'data/user/UID00000001/avatar/3QeI.gif', N'data/user/UID00000001/background/gigachad.jpg', 3, 1, CAST(N'2023-06-09T22:37:10.447' AS DateTime), N'ADMIN', N'<strong>Xin chào mọi người, </strong>
<br>
<span>Tôi xin được giới thiệu là một sinh viên đến từ trường FPT University. Tôi hết sức tự hào khi là một phần của cộng đồng sinh viên tại trường này, nơi tôi có cơ hội nhận được một giáo dục chất lượng và trải nghiệm học tập thú vị.</span>')
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (2, N'viet0807022', N'$argon2i$v=19$m=65536,t=28,p=1$65ULD/C8Z9YTpy+oo6T/fw$Y1oxAc8qQ5q3kzAQYYbuOhUH5hLmvZNygZZDGlwyC00', N'Nguyen Duy Khanh', N'null', N'van123872000@gmail.com', N'null ', CAST(N'2023-06-05' AS Date), 1, N'null ', N'data/user/UID00000002/avatar/Sharingan_17_08_2016_5.jpg', NULL, 4, 1, CAST(N'2023-06-09T22:38:39.540' AS DateTime), N'USER', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (3, N'viet08070222', N'$argon2i$v=19$m=65536,t=28,p=1$FK61Fb+dvCmjpF0z7Ckb/g$I06y13EQjm9duFcxw1E16qkotisHsjlAMfl6DlCt5Gc', N'Nguyễn Hồ Ngọc Ấn', N'null', N'van123872000@gmail.com', N'null  ', CAST(N'2023-05-29' AS Date), 1, N'null  ', N'data/user/UID00000003/avatar/hinh-anh-cute.jpg', N'data/user/UID00000003/background/MV5BYWQwMDNkM2MtODU4OS00OTY3LTgwOTItNjE2Yzc0MzRkMDllXkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_.jpg', 3, 8, CAST(N'2023-06-09T22:45:49.233' AS DateTime), N'USER', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (4, N'viet080702222', N'$argon2i$v=19$m=65536,t=28,p=1$ynKePYe2t3pRYEiw6dnGOQ$PBz0UD3eXc4/Eg0+oGAUEjx2FxYadOaNARAgUeOb+ag', N'Nguyễn Hồng Lĩnh', NULL, N'van123872000@gmail.com', NULL, CAST(N'2023-05-31' AS Date), 1, NULL, NULL, NULL, 1, 0, CAST(N'2023-06-09T22:47:16.583' AS DateTime), N'USER', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (8, N'viet0807022222', N'$argon2i$v=19$m=65536,t=28,p=1$X2u7XgIbBKeHfpdOKovm9g$kgNEeoKzCaHk2NOpdP7O9lNVsS5TWu5R/PC6AxAHbqw', N'Nguyen Cong Thinh', NULL, N'van123872000@gmail.com', NULL, CAST(N'2023-05-30' AS Date), 1, NULL, NULL, NULL, 0, 0, CAST(N'2023-06-17T14:26:54.377' AS DateTime), N'USER', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (9, N'ngocan0212', N'$argon2i$v=19$m=65536,t=28,p=1$anHiRfyC1Z5SuiUtZCopfw$dZ7srEQnzHuitlMuZSG73aZSuY+CXbJEsjBx+0+g6Ik', N'Nguyễn Hồ Ngọc Ấn', N'Huế', N'ngocan2002@gmail.com', N'null     ', CAST(N'2002-02-12' AS Date), 1, N'ahihihihi', N'data/user/UID00000009/avatar/ava2.jpg', NULL, 4, 4, CAST(N'2023-06-17T14:31:03.537' AS DateTime), N'USER', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (10, N'lioooo0000', N'$argon2i$v=19$m=65536,t=28,p=1$oCDRWwYBW0DksV2781eX/w$VtMMA3KxdBMe5JBKg56qWdbcEXgspOCYzzNY93CY+eE', N'xxxxxxx', NULL, N'linh04082002@gmail.com', NULL, CAST(N'2023-06-01' AS Date), 1, NULL, NULL, NULL, 1, 0, CAST(N'2023-06-17T14:31:05.477' AS DateTime), N'ADMIN', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (12, N'khanhdesu', N'$argon2i$v=19$m=65536,t=28,p=1$fiUaw2cIyYg+hBSd+6MTMw$kv3A26QUrVRFCM+Rnd81GMoFPxkteOPcCle938j2s6I', N'Nguyễn Duy Khánh', N'Gia Lai', N'khanhndde160504@fpt.edu.vn', N'null    ', CAST(N'2002-01-09' AS Date), 1, N'siuuuuuuuuuuuuuuu', N'data/user/UID00000012/avatar/unnamed.gif', N'data/user/UID00000012/background/one-piece-samurai-roronoa-zoro-wallpaper-960x600_1.jpg', 3, 21, CAST(N'2023-06-17T14:35:35.133' AS DateTime), N'USER', N'<b>I have no enemies</b>')
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (13, N'Stupiddog', N'$argon2i$v=19$m=65536,t=28,p=1$ExNRjJ4p57tnZkiUotKGsw$lR5LlZw5OLnIc2K1CCMWxv0onesQHnrKDZC2o3poBLo', N'Hoang Phuc', N'null', N'pgxnguyen54@gmail.com', N'null ', CAST(N'2002-03-23' AS Date), 1, N'null ', N'data/user/UID00000013/avatar/332140491_927426728429755_9035967389534729418_n.jpg', NULL, 1, 0, CAST(N'2023-06-17T16:14:07.263' AS DateTime), N'USER', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (20, N'Vinh đ?p trai', N'$argon2i$v=19$m=65536,t=28,p=1$6tu+VSr1wycAA2JKTZQUTA$6B8NlnQqLAIBZdrnecEus1EtQVOj4tSvfXUoP7DnM/s', N'Phạm Thế Vinh', N'null', N'phamthevinh955@gmail.com', N'null ', CAST(N'2002-11-23' AS Date), 1, N'null ', N'data/user/UID00000020/avatar/inbound3863246773064251410.jpg', N'data/user/UID00000020/background/inbound2525189753145427668.jpg', 1, 0, CAST(N'2023-06-18T02:37:02.580' AS DateTime), N'LOCK', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (21, N'viet08070222222', N'$argon2i$v=19$m=65536,t=28,p=1$DuQ0F6MnpRgzykH3V1uokg$LT44KB3AuWFMMeDwJC5HBFTODL0qDfX25CnqXCIdsBk', N'Ngô Thị Anh', NULL, N'van123872000@gmail.com', NULL, CAST(N'2002-07-08' AS Date), 1, NULL, NULL, NULL, 0, 0, CAST(N'2023-06-21T20:33:52.597' AS DateTime), N'USER', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (22, N'masteradmin', N'$argon2i$v=19$m=65536,t=28,p=1$pe8vPuBnWAMtYcj6M9Argg$HWdN38Oo8D9feFnfrZLjRrYTFhJ9QohPV6P56NXzo1E', N'Nguyen Anh Admin', NULL, N'van123872000@gmail.com', NULL, CAST(N'2023-05-29' AS Date), 1, NULL, NULL, NULL, 1, 1, CAST(N'2023-06-22T12:26:50.790' AS DateTime), N'MASTERADMIN', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (23, N'heyloser', N'$argon2i$v=19$m=65536,t=28,p=1$d4dSy6E2My1Nd5eNR9/C3A$qNPuRbZiuLEq7y6CfSx1YHJz/aHZzGfvmuSEfry1HFQ', N'Đẹp trai số 1', N'xa tận chân trời gần ngay trước mắt', N'thinh111190@gmail.com', N'02145112515', CAST(N'2002-10-12' AS Date), 0, N'kế bên bạn', N'data/user/UID00000023/avatar/—Pngtree—speed light effect abstract technology_7644651.png', N'data/user/UID00000023/background/—Pngtree—speed light effect abstract technology_7644651.png', 0, 1, CAST(N'2023-06-22T15:22:09.760' AS DateTime), N'USER', N'kế bên bạn')
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (24, N'vietngu', N'$argon2i$v=19$m=65536,t=28,p=1$fS6vXihw0ccf5wRUvMXNGQ$WNnlVJ3t1s5OajsOcEGEwfm3M3a19cLqk2ZQZkJOYmQ', N'honglinh', NULL, N'lantoaniemvui1@gmail.com', NULL, CAST(N'2002-02-11' AS Date), 1, NULL, NULL, NULL, 2, 0, CAST(N'2023-07-10T21:03:16.377' AS DateTime), N'LOCK', NULL)
INSERT [dbo].[UserInfor] ([ID], [Account], [Password], [FullName], [Address], [Mail], [PhoneNumber], [Dob], [Gender], [Nation], [ImageUser], [ImageBackGround], [NumFriend], [NumPost], [TimeCreate], [RoleID], [intro]) VALUES (25, N'thinh111190', N'$argon2i$v=19$m=65536,t=28,p=1$6iH+g3PFdglZr0D+nKPw1Q$BqvHAVOHKyTX9Iv0Lqw/cq5kQ/SfGf1KkQbB0HQV7k4', N'd', NULL, N'thinh111190@gmail.com', NULL, CAST(N'2009-05-15' AS Date), 0, NULL, NULL, NULL, 0, 1, CAST(N'2023-07-13T15:21:04.163' AS DateTime), N'USER', NULL)
SET IDENTITY_INSERT [dbo].[UserInfor] OFF
GO
INSERT [dbo].[UserLock] ([UserID], [LockTime], [LockDurationDay], [LockDurationHour], [LockDurationMinute]) VALUES (N'UID00000020', CAST(N'2023-07-07T14:07:04.793' AS DateTime), 0, 0, 0)
INSERT [dbo].[UserLock] ([UserID], [LockTime], [LockDurationDay], [LockDurationHour], [LockDurationMinute]) VALUES (N'UID00000024', CAST(N'2023-07-13T10:17:32.373' AS DateTime), 2, 0, 0)
GO
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000002', N'UID00000001', 0, 0, 1)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000003', N'UID00000001', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000003', N'UID00000002', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000004', N'UID00000001', 0, 1, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000008', N'UID00000001', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000009', N'UID00000001', 0, 0, 1)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000009', N'UID00000003', 0, 0, 1)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000012', N'UID00000001', 0, 1, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000012', N'UID00000003', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000012', N'UID00000009', 0, 0, 1)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000020', N'UID00000001', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000022', N'UID00000001', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000022', N'UID00000003', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000022', N'UID00000009', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000023', N'UID00000001', 1, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000023', N'UID00000002', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000023', N'UID00000003', 1, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000023', N'UID00000012', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000024', N'UID00000001', 0, 0, 1)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000024', N'UID00000022', 0, 0, 1)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000025', N'UID00000001', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000025', N'UID00000003', 0, 0, 0)
INSERT [dbo].[USERRELATION] ([UserID1], [UserID2], [U1RequestU2], [U2RequestU1], [isFriend]) VALUES (N'UID00000025', N'UID00000023', 0, 0, 0)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uc_UserID_NoteID]    Script Date: 7/15/2023 2:27:24 PM ******/
ALTER TABLE [dbo].[NOTE_COMMENT] ADD  CONSTRAINT [uc_UserID_NoteID] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[NoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uc_UserID_UserIDRequest]    Script Date: 7/15/2023 2:27:24 PM ******/
ALTER TABLE [dbo].[NOTE_FRIEND] ADD  CONSTRAINT [uc_UserID_UserIDRequest] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[UserIDRequest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [uc_UserID_ObjectID]    Script Date: 7/15/2023 2:27:24 PM ******/
ALTER TABLE [dbo].[NOTE_lIKE] ADD  CONSTRAINT [uc_UserID_ObjectID] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[ObjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Comment_User]    Script Date: 7/15/2023 2:27:24 PM ******/
ALTER TABLE [dbo].[ReportComment1686] ADD  CONSTRAINT [UQ_Comment_User] UNIQUE NONCLUSTERED 
(
	[CommentID] ASC,
	[UserID] ASC,
	[IsPost] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Post_User]    Script Date: 7/15/2023 2:27:24 PM ******/
ALTER TABLE [dbo].[ReportPost] ADD  CONSTRAINT [UQ_Post_User] UNIQUE NONCLUSTERED 
(
	[PostID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_User_User]    Script Date: 7/15/2023 2:27:24 PM ******/
ALTER TABLE [dbo].[ReportUser1686] ADD  CONSTRAINT [UQ_User_User] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[UserIDRP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__UserInfo__B0C3AC46250DA686]    Script Date: 7/15/2023 2:27:24 PM ******/
ALTER TABLE [dbo].[UserInfor] ADD UNIQUE NONCLUSTERED 
(
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__UserInfo__B0C3AC46F2E3602D]    Script Date: 7/15/2023 2:27:24 PM ******/
ALTER TABLE [dbo].[UserInfor] ADD UNIQUE NONCLUSTERED 
(
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Active] ADD  DEFAULT (getdate()) FOR [dateShow]
GO
ALTER TABLE [dbo].[Advertisement] ADD  DEFAULT (getdate()) FOR [TimePost]
GO
ALTER TABLE [dbo].[Advertisement] ADD  DEFAULT ((0)) FOR [NumInterface]
GO
ALTER TABLE [dbo].[Advertisement] ADD  DEFAULT ((0)) FOR [NumComment]
GO
ALTER TABLE [dbo].[Advertisement] ADD  DEFAULT ((0)) FOR [NumShare]
GO
ALTER TABLE [dbo].[Advertisement] ADD  DEFAULT ((0)) FOR [NumOfShow]
GO
ALTER TABLE [dbo].[Advertisement] ADD  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[Business] ADD  DEFAULT ((0)) FOR [NumFlow]
GO
ALTER TABLE [dbo].[Business] ADD  DEFAULT ((0)) FOR [budget]
GO
ALTER TABLE [dbo].[Business] ADD  DEFAULT (getdate()) FOR [TimeCreate]
GO
ALTER TABLE [dbo].[COMMENT] ADD  DEFAULT (getdate()) FOR [TimeComment]
GO
ALTER TABLE [dbo].[COMMENT] ADD  DEFAULT ((0)) FOR [NumInterface]
GO
ALTER TABLE [dbo].[COMMENTCHILD] ADD  DEFAULT (getdate()) FOR [TimeComment]
GO
ALTER TABLE [dbo].[COMMENTCHILD] ADD  DEFAULT ((0)) FOR [NumInterface]
GO
ALTER TABLE [dbo].[COMMENTSHARE] ADD  DEFAULT (getdate()) FOR [TimeComment]
GO
ALTER TABLE [dbo].[COMMENTSHARE] ADD  DEFAULT ((0)) FOR [NumInterface]
GO
ALTER TABLE [dbo].[CHATCONTENT] ADD  DEFAULT (getdate()) FOR [CreateAt]
GO
ALTER TABLE [dbo].[InterFaceObject] ADD  DEFAULT ('none') FOR [InterFaceID]
GO
ALTER TABLE [dbo].[NOTE_COMMENT] ADD  DEFAULT (getdate()) FOR [TimeComment]
GO
ALTER TABLE [dbo].[NOTE_COMMENT] ADD  DEFAULT ((0)) FOR [isRead]
GO
ALTER TABLE [dbo].[NOTE_FRIEND] ADD  DEFAULT (getdate()) FOR [TimeRequest]
GO
ALTER TABLE [dbo].[NOTE_FRIEND] ADD  DEFAULT ((0)) FOR [isRead]
GO
ALTER TABLE [dbo].[NOTE_lIKE] ADD  DEFAULT (getdate()) FOR [TimeComment]
GO
ALTER TABLE [dbo].[NOTE_lIKE] ADD  DEFAULT ((0)) FOR [isRead]
GO
ALTER TABLE [dbo].[POST] ADD  DEFAULT (getdate()) FOR [TimePost]
GO
ALTER TABLE [dbo].[POST] ADD  DEFAULT ((0)) FOR [NumInterface]
GO
ALTER TABLE [dbo].[POST] ADD  DEFAULT ((0)) FOR [NumComment]
GO
ALTER TABLE [dbo].[POST] ADD  DEFAULT ((0)) FOR [NumShare]
GO
ALTER TABLE [dbo].[POST] ADD  DEFAULT ('PUBLIC') FOR [PrivacyID]
GO
ALTER TABLE [dbo].[POSTSHARE] ADD  DEFAULT (getdate()) FOR [TimeShare]
GO
ALTER TABLE [dbo].[POSTSHARE] ADD  DEFAULT ((0)) FOR [NumInterface]
GO
ALTER TABLE [dbo].[POSTSHARE] ADD  DEFAULT ((0)) FOR [NumComment]
GO
ALTER TABLE [dbo].[POSTSHARE] ADD  DEFAULT ('PUBLIC') FOR [PrivacyID]
GO
ALTER TABLE [dbo].[ReportComment1686] ADD  DEFAULT ((1)) FOR [IsPost]
GO
ALTER TABLE [dbo].[ReportComment1686] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[ReportPost] ADD  DEFAULT ((1)) FOR [IsPost]
GO
ALTER TABLE [dbo].[ReportPost] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[ReportUser1686] ADD  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[UserInfor] ADD  DEFAULT ((0)) FOR [NumFriend]
GO
ALTER TABLE [dbo].[UserInfor] ADD  DEFAULT ((0)) FOR [NumPost]
GO
ALTER TABLE [dbo].[UserInfor] ADD  DEFAULT (getdate()) FOR [TimeCreate]
GO
ALTER TABLE [dbo].[UserInfor] ADD  DEFAULT ('USER') FOR [RoleID]
GO
ALTER TABLE [dbo].[USERRELATION] ADD  DEFAULT ((0)) FOR [U1RequestU2]
GO
ALTER TABLE [dbo].[USERRELATION] ADD  DEFAULT ((0)) FOR [U2RequestU1]
GO
ALTER TABLE [dbo].[USERRELATION] ADD  DEFAULT ((0)) FOR [isFriend]
GO
ALTER TABLE [dbo].[Active]  WITH CHECK ADD  CONSTRAINT [fk_AdvertiserID_dboactive] FOREIGN KEY([AdvertiserID])
REFERENCES [dbo].[Advertisement] ([AdvertiserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Active] CHECK CONSTRAINT [fk_AdvertiserID_dboactive]
GO
ALTER TABLE [dbo].[Advertisement]  WITH CHECK ADD  CONSTRAINT [fk_BusinessID_dboAdvertisement] FOREIGN KEY([BusinessID])
REFERENCES [dbo].[Business] ([BusinessID])
GO
ALTER TABLE [dbo].[Advertisement] CHECK CONSTRAINT [fk_BusinessID_dboAdvertisement]
GO
ALTER TABLE [dbo].[Business]  WITH CHECK ADD  CONSTRAINT [fk_user_id_dboBusiness] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[Business] CHECK CONSTRAINT [fk_user_id_dboBusiness]
GO
ALTER TABLE [dbo].[COMMENT]  WITH CHECK ADD  CONSTRAINT [fk_user_id_dboCOMMENT] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[COMMENT] CHECK CONSTRAINT [fk_user_id_dboCOMMENT]
GO
ALTER TABLE [dbo].[COMMENTCHILD]  WITH CHECK ADD  CONSTRAINT [fk_post_id_dboCOMMENTCHILD] FOREIGN KEY([CmtID])
REFERENCES [dbo].[COMMENT] ([CmtID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[COMMENTCHILD] CHECK CONSTRAINT [fk_post_id_dboCOMMENTCHILD]
GO
ALTER TABLE [dbo].[COMMENTCHILD]  WITH CHECK ADD  CONSTRAINT [fk_user_id_dboCOMMENTCHILD] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[COMMENTCHILD] CHECK CONSTRAINT [fk_user_id_dboCOMMENTCHILD]
GO
ALTER TABLE [dbo].[COMMENTSHARE]  WITH CHECK ADD  CONSTRAINT [fk_user_id_dboCOMMENTSHARE] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[COMMENTSHARE] CHECK CONSTRAINT [fk_user_id_dboCOMMENTSHARE]
GO
ALTER TABLE [dbo].[CHATCONTENT]  WITH CHECK ADD  CONSTRAINT [fk_user_id1_dboCHATCONTENT] FOREIGN KEY([UserID1])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[CHATCONTENT] CHECK CONSTRAINT [fk_user_id1_dboCHATCONTENT]
GO
ALTER TABLE [dbo].[CHATCONTENT]  WITH CHECK ADD  CONSTRAINT [fk_user_id2_dboCHATCONTENT] FOREIGN KEY([UserID2])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[CHATCONTENT] CHECK CONSTRAINT [fk_user_id2_dboCHATCONTENT]
GO
ALTER TABLE [dbo].[InterFaceObject]  WITH CHECK ADD  CONSTRAINT [fk_InterFaceID_InterFaceObject] FOREIGN KEY([InterFaceID])
REFERENCES [dbo].[InterFace] ([InterFaceID])
GO
ALTER TABLE [dbo].[InterFaceObject] CHECK CONSTRAINT [fk_InterFaceID_InterFaceObject]
GO
ALTER TABLE [dbo].[InterFaceObject]  WITH CHECK ADD  CONSTRAINT [fk_user_id_InterFaceObject] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[InterFaceObject] CHECK CONSTRAINT [fk_user_id_InterFaceObject]
GO
ALTER TABLE [dbo].[NOTE_COMMENT]  WITH CHECK ADD  CONSTRAINT [fk_user_id_NOTE_COMMENT] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[NOTE_COMMENT] CHECK CONSTRAINT [fk_user_id_NOTE_COMMENT]
GO
ALTER TABLE [dbo].[NOTE_FRIEND]  WITH CHECK ADD  CONSTRAINT [fk_user_id_Notificate] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[NOTE_FRIEND] CHECK CONSTRAINT [fk_user_id_Notificate]
GO
ALTER TABLE [dbo].[NOTE_FRIEND]  WITH CHECK ADD  CONSTRAINT [fk_UserIDRequest_Notificate] FOREIGN KEY([UserIDRequest])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[NOTE_FRIEND] CHECK CONSTRAINT [fk_UserIDRequest_Notificate]
GO
ALTER TABLE [dbo].[NOTE_lIKE]  WITH CHECK ADD  CONSTRAINT [fk_user_id_NOTE_lIKE] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[NOTE_lIKE] CHECK CONSTRAINT [fk_user_id_NOTE_lIKE]
GO
ALTER TABLE [dbo].[POST]  WITH CHECK ADD  CONSTRAINT [fk_PrivacyID_POST] FOREIGN KEY([PrivacyID])
REFERENCES [dbo].[Privacy] ([PrivacyID])
GO
ALTER TABLE [dbo].[POST] CHECK CONSTRAINT [fk_PrivacyID_POST]
GO
ALTER TABLE [dbo].[POST]  WITH CHECK ADD  CONSTRAINT [fk_user_id_dboPOST] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[POST] CHECK CONSTRAINT [fk_user_id_dboPOST]
GO
ALTER TABLE [dbo].[POSTSHARE]  WITH CHECK ADD  CONSTRAINT [fk_post_id_dboPOSTSHARE] FOREIGN KEY([PostID])
REFERENCES [dbo].[POST] ([PostID])
GO
ALTER TABLE [dbo].[POSTSHARE] CHECK CONSTRAINT [fk_post_id_dboPOSTSHARE]
GO
ALTER TABLE [dbo].[POSTSHARE]  WITH CHECK ADD  CONSTRAINT [fk_PrivacyID_POSTSHARE] FOREIGN KEY([PrivacyID])
REFERENCES [dbo].[Privacy] ([PrivacyID])
GO
ALTER TABLE [dbo].[POSTSHARE] CHECK CONSTRAINT [fk_PrivacyID_POSTSHARE]
GO
ALTER TABLE [dbo].[POSTSHARE]  WITH CHECK ADD  CONSTRAINT [fk_user_id_dboPOSTSHARE] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[POSTSHARE] CHECK CONSTRAINT [fk_user_id_dboPOSTSHARE]
GO
ALTER TABLE [dbo].[ReportComment1686]  WITH CHECK ADD  CONSTRAINT [FK_ReportComment_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[ReportComment1686] CHECK CONSTRAINT [FK_ReportComment_User]
GO
ALTER TABLE [dbo].[ReportComment1686]  WITH CHECK ADD  CONSTRAINT [FK_ReportComment_User2] FOREIGN KEY([UserID2])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[ReportComment1686] CHECK CONSTRAINT [FK_ReportComment_User2]
GO
ALTER TABLE [dbo].[ReportPost]  WITH CHECK ADD  CONSTRAINT [FK_ReportPost_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[ReportPost] CHECK CONSTRAINT [FK_ReportPost_User]
GO
ALTER TABLE [dbo].[ReportPost]  WITH CHECK ADD  CONSTRAINT [FK_ReportPost_User2] FOREIGN KEY([UserID2])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[ReportPost] CHECK CONSTRAINT [FK_ReportPost_User2]
GO
ALTER TABLE [dbo].[ReportUser1686]  WITH CHECK ADD  CONSTRAINT [FK_ReportUser_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[ReportUser1686] CHECK CONSTRAINT [FK_ReportUser_User]
GO
ALTER TABLE [dbo].[ReportUser1686]  WITH CHECK ADD  CONSTRAINT [FK_ReportUser_User2] FOREIGN KEY([UserIDRP])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[ReportUser1686] CHECK CONSTRAINT [FK_ReportUser_User2]
GO
ALTER TABLE [dbo].[UserInfor]  WITH CHECK ADD  CONSTRAINT [fk_RoleID_UserInfor] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[UserInfor] CHECK CONSTRAINT [fk_RoleID_UserInfor]
GO
ALTER TABLE [dbo].[UserLock]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[UserLock]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[UserLock]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[UserLock]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[UserLock]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[USERRELATION]  WITH CHECK ADD  CONSTRAINT [fk_user_id1_dboUSERRELATION] FOREIGN KEY([UserID1])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[USERRELATION] CHECK CONSTRAINT [fk_user_id1_dboUSERRELATION]
GO
ALTER TABLE [dbo].[USERRELATION]  WITH CHECK ADD  CONSTRAINT [fk_user_id2_dboUSERRELATION] FOREIGN KEY([UserID2])
REFERENCES [dbo].[UserInfor] ([UserID])
GO
ALTER TABLE [dbo].[USERRELATION] CHECK CONSTRAINT [fk_user_id2_dboUSERRELATION]
GO
ALTER TABLE [dbo].[CHATCONTENT]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
ALTER TABLE [dbo].[CHATCONTENT]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
ALTER TABLE [dbo].[CHATCONTENT]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
ALTER TABLE [dbo].[CHATCONTENT]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
ALTER TABLE [dbo].[CHATCONTENT]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
ALTER TABLE [dbo].[USERRELATION]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
ALTER TABLE [dbo].[USERRELATION]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
ALTER TABLE [dbo].[USERRELATION]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
ALTER TABLE [dbo].[USERRELATION]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
ALTER TABLE [dbo].[USERRELATION]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
/****** Object:  Trigger [dbo].[Active_Advertisement]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[Active_Advertisement]
	ON [dbo].[Active] AFTER INSERT
	AS
	BEGIN
		UPDATE dbo.Advertisement
		SET Status= 'ongoing'
		WHERE AdvertiserID= (SELECT AdvertiserID FROM Inserted)
	END
GO
ALTER TABLE [dbo].[Active] ENABLE TRIGGER [Active_Advertisement]
GO
/****** Object:  Trigger [dbo].[InActive_Advertisement]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[InActive_Advertisement]
	ON [dbo].[Active] AFTER DELETE
	AS
	BEGIN
		UPDATE dbo.Advertisement
		SET Status= 'inactive'
		WHERE AdvertiserID= (SELECT AdvertiserID FROM Deleted)
	END
GO
ALTER TABLE [dbo].[Active] ENABLE TRIGGER [InActive_Advertisement]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_Advertise_INSERT]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Add_Path_For_Advertise_INSERT]
	ON [dbo].[Advertisement] AFTER INSERT
	AS
	BEGIN
		UPDATE dbo.Advertisement
		SET ImagePost= CASE
			WHEN ImagePost= '' THEN ''
			else
			ImagePost
			end
		WHERE AdvertiserID= (SELECT AdvertiserID FROM INSERTed)
	END
	
GO
ALTER TABLE [dbo].[Advertisement] ENABLE TRIGGER [Add_Path_For_Advertise_INSERT]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_Advertise_UPDATE]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Add_Path_For_Advertise_UPDATE]
	ON [dbo].[Advertisement] AFTER UPDATE
	AS
	BEGIN
		IF UPDATE(ImagePost) 
		BEGIN
			UPDATE p
			SET p.ImagePost = CASE
					WHEN p.ImagePost = '' THEN ''
					ELSE 'data/business/'+p.BusinessID+'/' + p.AdvertiserID+'/post/'+p.ImagePost
				END
			FROM dbo.Advertisement p
			INNER JOIN INSERTED i ON p.AdvertiserID = i.AdvertiserID
		END
		IF UPDATE(Quantity) 
		BEGIN
			UPDATE p
				SET p.Status= 'inactive'
			FROM dbo.Advertisement p
			INNER JOIN INSERTED i ON p.AdvertiserID = i.AdvertiserID
			WHERE p.Quantity= 0
			DELETE dbo.Active
			WHERE AdvertiserID= (SELECT TOP (1)AdvertiserID FROM dbo.Advertisement WHERE Quantity= 0)
		END 
	END
GO
ALTER TABLE [dbo].[Advertisement] ENABLE TRIGGER [Add_Path_For_Advertise_UPDATE]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_Bussiness_INSERT]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    CREATE TRIGGER [dbo].[Add_Path_For_Bussiness_INSERT]
	ON [dbo].[Business] AFTER INSERT
	AS
	BEGIN
		UPDATE dbo.Business
		SET ImageAvatar= CASE
			WHEN ImageAvatar= '' THEN ''
			else
			ImageAvatar
			end
		WHERE BusinessID= (SELECT BusinessID FROM INSERTed);

		UPDATE dbo.Business
		SET ImageBackGround= CASE
			WHEN ImageBackGround= '' THEN ''
			else
			ImageBackGround
			end
		WHERE BusinessID= (SELECT BusinessID FROM INSERTed);
	END
GO
ALTER TABLE [dbo].[Business] ENABLE TRIGGER [Add_Path_For_Bussiness_INSERT]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_Bussiness_UPDATE]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE TRIGGER [dbo].[Add_Path_For_Bussiness_UPDATE]
	ON [dbo].[Business] AFTER UPDATE
	AS
	BEGIN
		IF UPDATE(ImageAvatar) 
		BEGIN
			UPDATE p
			SET p.ImageAvatar = CASE
					WHEN p.ImageAvatar = '' THEN ''
					ELSE 'data/business/'+p.BusinessID+'/avatar/'+p.ImageAvatar
				END
			FROM dbo.Business p
			INNER JOIN INSERTED i ON p.BusinessID = i.BusinessID
		END
		IF UPDATE(ImageBackGround) 
		BEGIN
			UPDATE p
			SET p.ImageBackGround = CASE
					WHEN p.ImageBackGround = '' THEN ''
					ELSE 'data/business/'+p.BusinessID+'/background/'+p.ImageBackGround
				END
			FROM dbo.Business p
			INNER JOIN INSERTED i ON p.BusinessID = i.BusinessID
		END
	END

GO
ALTER TABLE [dbo].[Business] ENABLE TRIGGER [Add_Path_For_Bussiness_UPDATE]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_INSERT_Comment]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Add_Path_For_INSERT_Comment]
	ON [dbo].[COMMENT] AFTER INSERT
	AS
	BEGIN
		
		UPDATE dbo.COMMENT
		SET ImageComment= CASE
            WHEN ImageComment= '' THEN ''
			else
			ImageComment
			end
		WHERE CmtID= (SELECT CmtID FROM INSERTed)
	END
GO
ALTER TABLE [dbo].[COMMENT] ENABLE TRIGGER [Add_Path_For_INSERT_Comment]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_UPDATE_Comment]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Add_Path_For_UPDATE_Comment]
	ON [dbo].[COMMENT] AFTER UPDATE
	AS
	BEGIN
		IF UPDATE(ImageComment) 
			BEGIN
			UPDATE p
			SET p.ImageComment = CASE
					WHEN p.ImageComment = '' THEN ''
					ELSE 'data/post/'+p.PostID+'/'+p.CmtID+'/'+p.ImageComment
				END
			FROM dbo.COMMENT p
			INNER JOIN INSERTED i ON p.CmtID = i.CmtID
		END
	END
GO
ALTER TABLE [dbo].[COMMENT] ENABLE TRIGGER [Add_Path_For_UPDATE_Comment]
GO
/****** Object:  Trigger [dbo].[delete_comment_of_post]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[delete_comment_of_post]
	ON [dbo].[COMMENT] AFTER DELETE
	as
	BEGIN
		UPDATE dbo.POST
		SET NumComment= NumComment -1
		WHERE PostID= (SELECT PostID FROM Deleted)
		UPDATE dbo.PostShare
		SET NumComment= NumComment -1
		WHERE PostID= (SELECT PostID FROM Deleted)
		UPDATE dbo.Advertisement
		SET NumComment= NumComment -1
		WHERE AdvertiserID= (SELECT PostID FROM Deleted)
	END;
GO
ALTER TABLE [dbo].[COMMENT] ENABLE TRIGGER [delete_comment_of_post]
GO
/****** Object:  Trigger [dbo].[insert_comment_of_post]    Script Date: 7/15/2023 2:27:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[insert_comment_of_post]
	ON [dbo].[COMMENT] AFTER INSERT 
	as
	BEGIN
		UPDATE dbo.POST
		SET NumComment= NumComment +1
		WHERE PostID= (SELECT PostID FROM Inserted)
		UPDATE dbo.PostShare
		SET NumComment= NumComment +1
		WHERE PostID= (SELECT PostID FROM Inserted)
		UPDATE dbo.Advertisement
		SET NumComment= NumComment +1
		WHERE AdvertiserID= (SELECT PostID FROM Inserted)
	END;
GO
ALTER TABLE [dbo].[COMMENT] ENABLE TRIGGER [insert_comment_of_post]
GO
/****** Object:  Trigger [dbo].[UseForNOTE_COMMENT]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[UseForNOTE_COMMENT]
	ON [dbo].[COMMENT] AFTER INSERT
	AS
	BEGIN
			-- Khai báo các biến
		DECLARE @UserID VARCHAR(11)  
		DECLARE @ObjectID VARCHAR(11)  
		DECLARE @Content VARCHAR(11)
		DECLARE @TimeComment VARCHAR(11)
		-- Khởi tạo CURSOR để duyệt qua từng hàng trong bảng inserted
		DECLARE curRows CURSOR FOR
			SELECT (SELECT TOP(1) UserID FROM dbo.POST WHERE PostID= Inserted.PostID),Inserted.PostID , Inserted.Content, Inserted.TimeComment
			FROM inserted;
		-- Mở CURSOR
		OPEN curRows;

		-- Lấy hàng đầu tiên
		FETCH NEXT FROM curRows INTO @UserID, @ObjectID, @Content, @TimeComment;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Thực hiện câu lệnh cập nhật cho hàng hiện tại
			-- Ví dụ: Cập nhật cột Column3 dựa trên giá trị của cột Column1
			IF NOT EXISTS( SELECT *
			FROM dbo.NOTE_COMMENT
			WHERE UserID= @UserID AND ObjectID= @ObjectID)
				BEGIN
					INSERT INTO dbo.NOTE_COMMENT
					(
					    ObjectID,
					    UserID,
					    statusNote,
					    TimeComment,
					    isRead
					)
					VALUES
					(   @ObjectID,    -- CmtID - varchar(11)
					    @UserID,      -- UserID - varchar(11)
					    'post',    -- statusNote - nvarchar(30)
					    DEFAULT, -- TimeComment - datetime
					    DEFAULT     -- isRead - bit
					    )
				END
				ELSE
				BEGIN
					UPDATE dbo.NOTE_COMMENT
					SET TimeComment= GETDATE(), isRead= 0
					WHERE UserID= @UserID AND ObjectID= @ObjectID
				END
			
		 -- post :là bình luậnt của bài dang
		-- comment: la binh luan tra loi comment

			-- Lấy hàng tiếp theo
			FETCH NEXT FROM curRows INTO  @UserID, @ObjectID, @Content, @TimeComment;
		
		END;
		-- Đóng CURSOR
		CLOSE curRows;
		DEALLOCATE curRows;
	END;
GO
ALTER TABLE [dbo].[COMMENT] ENABLE TRIGGER [UseForNOTE_COMMENT]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_INSERT_CommentChild]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE TRIGGER [dbo].[Add_Path_For_INSERT_CommentChild]
	ON [dbo].[COMMENTCHILD] AFTER INSERT
	AS
	BEGIN
		
		UPDATE dbo.COMMENTCHILD
		SET ImageComment= CASE
            WHEN ImageComment= '' THEN ''
			else
			ImageComment
			end
		WHERE CmtID= (SELECT Inserted.CmtID FROM INSERTed)
	END
GO
ALTER TABLE [dbo].[COMMENTCHILD] ENABLE TRIGGER [Add_Path_For_INSERT_CommentChild]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_UPDATE_CommentChild]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Add_Path_For_UPDATE_CommentChild]
	ON [dbo].[COMMENTCHILD] AFTER UPDATE
	AS
	BEGIN
		IF UPDATE(ImageComment) 
			BEGIN
			UPDATE p
			SET p.ImageComment = CASE
					WHEN p.ImageComment = '' THEN ''
					ELSE 'data/post/'+(SELECT TOP(1) PostID FROM dbo.COMMENT WHERE p.CmtID= dbo.COMMENT.CmtID)+'/'+p.CmtID+'/'+p.ChildID+'/'+p.ImageComment
				END
			FROM dbo.COMMENTCHILD p
			INNER JOIN INSERTED i ON p.ChildID= i.ChildID
		END
	END
GO
ALTER TABLE [dbo].[COMMENTCHILD] ENABLE TRIGGER [Add_Path_For_UPDATE_CommentChild]
GO
/****** Object:  Trigger [dbo].[UseForNOTE_COMMENTByComment]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[UseForNOTE_COMMENTByComment]
	ON [dbo].[COMMENTCHILD] AFTER INSERT
	AS
	BEGIN
			-- Khai báo các biến
		DECLARE @UserID VARCHAR(11)  
		DECLARE @ObjectID VARCHAR(11)  
		DECLARE @Content VARCHAR(11)
		DECLARE @TimeComment VARCHAR(11)
		-- Khởi tạo CURSOR để duyệt qua từng hàng trong bảng inserted
		DECLARE curRows_UseForNOTE_COMMENTByComment CURSOR FOR
			SELECT (SELECT TOP(1) UserID FROM dbo.COMMENT WHERE dbo.COMMENT.CmtID= Inserted.CmtID),Inserted.CmtID , Inserted.Content, Inserted.TimeComment
			FROM inserted;
		-- Mở CURSOR
		OPEN curRows_UseForNOTE_COMMENTByComment;

		-- Lấy hàng đầu tiên
		FETCH NEXT FROM curRows_UseForNOTE_COMMENTByComment INTO @UserID, @ObjectID, @Content, @TimeComment;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Thực hiện câu lệnh cập nhật cho hàng hiện tại
			-- Ví dụ: Cập nhật cột Column3 dựa trên giá trị của cột Column1
			IF NOT EXISTS( SELECT *
			FROM dbo.NOTE_COMMENT
			WHERE UserID= @UserID AND ObjectID= @ObjectID)
				BEGIN
					INSERT INTO dbo.NOTE_COMMENT
					(
					    ObjectID,
					    UserID,
					    statusNote,
					    TimeComment,
					    isRead
					)
					VALUES
					(   @ObjectID,    -- CmtID - varchar(11)
					    @UserID,      -- UserID - varchar(11)
					    'comment',    -- statusNote - nvarchar(30)
					    DEFAULT, -- TimeComment - datetime
					    DEFAULT     -- isRead - bit
					    )
				END
				ELSE
				BEGIN
					UPDATE dbo.NOTE_COMMENT
					SET TimeComment= GETDATE(), isRead= 0
					WHERE UserID= @UserID AND ObjectID= @ObjectID
				END
			
		 -- post :là bình luậnt của bài dang
		-- comment: la binh luan tra loi comment

			-- Lấy hàng tiếp theo
			FETCH NEXT FROM curRows_UseForNOTE_COMMENTByComment INTO  @UserID, @ObjectID, @Content, @TimeComment;
		
		END;
		-- Đóng CURSOR
		CLOSE curRows_UseForNOTE_COMMENTByComment;
		DEALLOCATE curRows_UseForNOTE_COMMENTByComment;
	END;
GO
ALTER TABLE [dbo].[COMMENTCHILD] ENABLE TRIGGER [UseForNOTE_COMMENTByComment]
GO
/****** Object:  Trigger [dbo].[delete_comment_of_POSTSHARE]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[delete_comment_of_POSTSHARE]
	ON [dbo].[COMMENTSHARE] AFTER DELETE
	as
	BEGIN
		UPDATE dbo.POSTSHARE
		SET NumComment= NumComment -1
		WHERE ShareID= (SELECT ShareID FROM Deleted)
	END;
GO
ALTER TABLE [dbo].[COMMENTSHARE] ENABLE TRIGGER [delete_comment_of_POSTSHARE]
GO
/****** Object:  Trigger [dbo].[insert_comment_of_POSTSHARE]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE TRIGGER [dbo].[insert_comment_of_POSTSHARE]
	ON [dbo].[COMMENTSHARE] AFTER INSERT 
	AS
	BEGIN
		UPDATE dbo.POSTSHARE
		SET NumComment= NumComment +1
		WHERE ShareID= (SELECT ShareID FROM Inserted)
	END;
-- new path for image
	
GO
ALTER TABLE [dbo].[COMMENTSHARE] ENABLE TRIGGER [insert_comment_of_POSTSHARE]
GO
/****** Object:  Trigger [dbo].[UpDate_Object_Inteface]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    CREATE  TRIGGER [dbo].[UpDate_Object_Inteface]
	ON [dbo].[InterFaceObject] AFTER UPDATE 
	AS
	BEGIN
			-- Khai báo các biến
		DECLARE @ObjectID VARCHAR(11)
		DECLARE @UserID VARCHAR(11)
		DECLARE @InterFaceID VARCHAR(11)

		-- Khởi tạo CURSOR để duyệt qua từng hàng trong bảng inserted
		DECLARE curRows_UpDate_Object_Inteface CURSOR FOR
			SELECT Inserted.ObjectID, Inserted.UserID,Inserted.InterFaceID
			FROM inserted;

		-- Mở CURSOR
		OPEN curRows_UpDate_Object_Inteface;

		-- Lấy hàng đầu tiên
		FETCH NEXT FROM curRows_UpDate_Object_Inteface INTO @ObjectID, @UserID, @InterFaceID;

		-- Duyệt qua từng hàng và thực hiện các câu lệnh tương ứng
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Thực hiện câu lệnh cập nhật cho hàng hiện tại
			-- Ví dụ: Cập nhật cột Column3 dựa trên giá trị của cột Column1
			IF(@ObjectID LIKE 'PID%')
				BEGIN
					UPDATE dbo.POST
					SET NumInterface= CASE 
								WHEN @InterFaceID= 'none' THEN  NumInterface-1
								ELSE NumInterface + 1
							END
					WHERE PostID= @ObjectID
				END
			ELSE IF (@ObjectID LIKE 'SID%')
				BEGIN
					UPDATE dbo.POSTSHARE
					SET NumInterface= CASE 
								WHEN @InterFaceID= 'none' THEN  NumInterface-1
								ELSE NumInterface + 1
							END
					WHERE ShareID= @ObjectID
				END
			ELSE IF (@ObjectID LIKE 'CID%')
				BEGIN
					UPDATE dbo.COMMENT
					SET NumInterface= CASE 
								WHEN @InterFaceID= 'none' THEN  NumInterface-1
								ELSE NumInterface + 1
							END
					WHERE CmtID= @ObjectID
				END
			ELSE IF (@ObjectID LIKE 'ILD%')
				BEGIN
					UPDATE dbo.COMMENTCHILD
					SET NumInterface= CASE 
								WHEN @InterFaceID= 'none' THEN  NumInterface-1
								ELSE NumInterface + 1
							END
					WHERE ChildID= @ObjectID
				END
			ELSE IF (@ObjectID LIKE 'AID%')
				BEGIN
					UPDATE dbo.Advertisement
					SET NumInterface= CASE 
								WHEN @InterFaceID= 'none' THEN  NumInterface-1
								ELSE NumInterface + 1
							END
					WHERE AdvertiserID= @ObjectID
				END

			-- Lấy hàng tiếp theo
			FETCH NEXT FROM curRows_UpDate_Object_Inteface INTO @ObjectID, @UserID, @InterFaceID;
		END;

		-- Đóng CURSOR
		CLOSE curRows_UpDate_Object_Inteface;
		DEALLOCATE curRows_UpDate_Object_Inteface;
	END
GO
ALTER TABLE [dbo].[InterFaceObject] ENABLE TRIGGER [UpDate_Object_Inteface]
GO
/****** Object:  Trigger [dbo].[UseForNOTE_COMMENTByLike]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[UseForNOTE_COMMENTByLike]
	ON [dbo].[InterFaceObject] AFTER INSERT, UPDATE
	AS
	BEGIN		
				-- Khai báo các biến
			DECLARE @UserID VARCHAR(11)  
			DECLARE @ObjectID VARCHAR(11)  
			DECLARE @InterFaceID VARCHAR(11)
			DECLARE @statusNote nvarchar(30)
			-- Khởi tạo CURSOR để duyệt qua từng hàng trong bảng inserted
			DECLARE curRows_NOTE_COMMENTByLike CURSOR FOR
				SELECT Inserted.UserID ,Inserted.ObjectID , Inserted.InterFaceID
				FROM inserted;
			-- Mở CURSOR
			OPEN curRows_NOTE_COMMENTByLike;

			-- Lấy hàng đầu tiên
			FETCH NEXT FROM curRows_NOTE_COMMENTByLike INTO @UserID, @ObjectID, @InterFaceID;
		IF( @InterFaceID NOT LIKE 'none')
		BEGIN
			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- post (PID and SID) :là thong bao cho bai viet post va sharepost
		 -- comment (CID, ILD): là thong bao tuong tac cho binh luan post va sharepost
			IF(@ObjectID LIKE 'PID%')
				BEGIN
					SET @UserID= (SELECT TOP(1) UserID FROM dbo.POST WHERE PostID= @ObjectID);
					SET @statusNote= 'post';
				END
			ELSE IF(@ObjectID LIKE 'SID%')
				BEGIN
					SET @UserID= (SELECT TOP(1) UserID FROM dbo.POSTSHARE WHERE ShareID= @ObjectID);
					SET @statusNote= 'post';
				END
			ELSE IF(@ObjectID LIKE 'CID%')
				BEGIN
					SET @UserID= (SELECT TOP(1) UserID FROM dbo.COMMENT WHERE CmtID= @ObjectID);
					SET @statusNote= 'comment';
				END
			ELSE IF(@ObjectID LIKE 'ILD%')
				BEGIN
					SET @UserID= (SELECT TOP(1) UserID FROM dbo.COMMENTCHILD WHERE ChildID= @ObjectID);
					SET @statusNote= 'comment';
				END
		
				IF NOT EXISTS( SELECT *
				FROM dbo.NOTE_lIKE
				WHERE UserID= @UserID AND ObjectID= @ObjectID)
					BEGIN
						INSERT INTO dbo.NOTE_lIKE
						(
							ObjectID,
							UserID,
							statusNote,
							TimeComment,
							isRead
						)
						VALUES
						(   @ObjectID,    -- ObjectID - varchar(11)
							@UserID,      -- UserID - varchar(11)
							@statusNote,    -- statusNote - nvarchar(30)
							DEFAULT, -- TimeComment - datetime
							DEFAULT  -- isRead - bit
							)
					END
					ELSE
					BEGIN
						UPDATE dbo.NOTE_lIKE
						SET TimeComment= GETDATE(), isRead= 0
						WHERE UserID= @UserID AND ObjectID= @ObjectID
					END
			
				-- post (PID and SID) :là thong bao cho bai viet post va sharepost
		 -- comment (CID, ILD): là thong bao tuong tac cho binh luan post va sharepost

				-- Lấy hàng tiếp theo
				FETCH NEXT FROM curRows_NOTE_COMMENTByLike INTO   @UserID, @ObjectID, @InterFaceID;
		
			END;
			
		END
		-- Đóng CURSOR
			CLOSE curRows_NOTE_COMMENTByLike;
			DEALLOCATE curRows_NOTE_COMMENTByLike;
	END;
GO
ALTER TABLE [dbo].[InterFaceObject] ENABLE TRIGGER [UseForNOTE_COMMENTByLike]
GO
/****** Object:  Trigger [dbo].[UseForNOTE_COUNT_NOTE_COMMENT]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[UseForNOTE_COUNT_NOTE_COMMENT]
	ON [dbo].[NOTE_COMMENT] AFTER INSERT, UPDATE
	AS
	BEGIN
			-- Khai báo các biến
		DECLARE @UserID VARCHAR(11)  
		-- Khởi tạo CURSOR để duyệt qua từng hàng trong bảng inserted
		DECLARE curRows_UseForNOTE_COUNT_NOTE_COMMENT CURSOR FOR
			SELECT Inserted.UserID
			FROM inserted;
		-- Mở CURSOR
		OPEN curRows_UseForNOTE_COUNT_NOTE_COMMENT;

		-- Lấy hàng đầu tiên
		FETCH NEXT FROM curRows_UseForNOTE_COUNT_NOTE_COMMENT INTO @UserID;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Thực hiện câu lệnh cập nhật cho hàng hiện tại
			-- Ví dụ: Cập nhật cột Column3 dựa trên giá trị của cột Column1
			UPDATE dbo.NOTE_COUNT
			SET NOTE=  NOTE + 1
			WHERE UserID= @UserID	
		 -- post :là bình luậnt của bài dang
		-- comment: la binh luan tra loi comment
			-- Lấy hàng tiếp theo
			FETCH NEXT FROM curRows_UseForNOTE_COUNT_NOTE_COMMENT INTO  @UserID;
		END;
		-- Đóng CURSOR
		CLOSE curRows_UseForNOTE_COUNT_NOTE_COMMENT;
		DEALLOCATE curRows_UseForNOTE_COUNT_NOTE_COMMENT;
	END;
GO
ALTER TABLE [dbo].[NOTE_COMMENT] ENABLE TRIGGER [UseForNOTE_COUNT_NOTE_COMMENT]
GO
/****** Object:  Trigger [dbo].[UseForNOTE_COUNT_NOTE_FRIEND]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[UseForNOTE_COUNT_NOTE_FRIEND]
	ON [dbo].[NOTE_FRIEND] AFTER INSERT, UPDATE
	AS
	BEGIN
			-- Khai báo các biến
		DECLARE @UserID VARCHAR(11)  
		-- Khởi tạo CURSOR để duyệt qua từng hàng trong bảng inserted
		DECLARE curRows_UseForNOTE_COUNT_NOTE_FRIEND CURSOR FOR
			SELECT Inserted.UserID
			FROM inserted;
		-- Mở CURSOR
		OPEN curRows_UseForNOTE_COUNT_NOTE_FRIEND;

		-- Lấy hàng đầu tiên
		FETCH NEXT FROM curRows_UseForNOTE_COUNT_NOTE_FRIEND INTO @UserID;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Thực hiện câu lệnh cập nhật cho hàng hiện tại
			-- Ví dụ: Cập nhật cột Column3 dựa trên giá trị của cột Column1
			UPDATE dbo.NOTE_COUNT
			SET NOTE=  NOTE + 1
			WHERE UserID= @UserID	
		 -- post :là bình luậnt của bài dang
		-- comment: la binh luan tra loi comment
			-- Lấy hàng tiếp theo
			FETCH NEXT FROM curRows_UseForNOTE_COUNT_NOTE_FRIEND INTO  @UserID;
		END;
		-- Đóng CURSOR
		CLOSE curRows_UseForNOTE_COUNT_NOTE_FRIEND;
		DEALLOCATE curRows_UseForNOTE_COUNT_NOTE_FRIEND;
	END;
GO
ALTER TABLE [dbo].[NOTE_FRIEND] ENABLE TRIGGER [UseForNOTE_COUNT_NOTE_FRIEND]
GO
/****** Object:  Trigger [dbo].[UseForNOTE_COUNT_NOTE_lIKE]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  TRIGGER [dbo].[UseForNOTE_COUNT_NOTE_lIKE]
	ON [dbo].[NOTE_lIKE] AFTER INSERT, UPDATE
	AS
	BEGIN
			-- Khai báo các biến
		DECLARE @UserID VARCHAR(11)  
		-- Khởi tạo CURSOR để duyệt qua từng hàng trong bảng inserted
		DECLARE curRows_UseForNOTE_COUNT_NOTE_lIKE CURSOR FOR
			SELECT Inserted.UserID
			FROM inserted;
		-- Mở CURSOR
		OPEN curRows_UseForNOTE_COUNT_NOTE_lIKE;

		-- Lấy hàng đầu tiên
		FETCH NEXT FROM curRows_UseForNOTE_COUNT_NOTE_lIKE INTO @UserID;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Thực hiện câu lệnh cập nhật cho hàng hiện tại
			-- Ví dụ: Cập nhật cột Column3 dựa trên giá trị của cột Column1
			UPDATE dbo.NOTE_COUNT
			SET NOTE=  NOTE + 1
			WHERE UserID= @UserID	
		 -- post :là bình luậnt của bài dang
		-- comment: la binh luan tra loi comment
			-- Lấy hàng tiếp theo
			FETCH NEXT FROM curRows_UseForNOTE_COUNT_NOTE_lIKE INTO  @UserID;
		END;
		-- Đóng CURSOR
		CLOSE curRows_UseForNOTE_COUNT_NOTE_lIKE;
		DEALLOCATE curRows_UseForNOTE_COUNT_NOTE_lIKE;
	END;
GO
ALTER TABLE [dbo].[NOTE_lIKE] ENABLE TRIGGER [UseForNOTE_COUNT_NOTE_lIKE]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_Post]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    CREATE TRIGGER [dbo].[Add_Path_For_Post]
	ON [dbo].[POST] AFTER INSERT
	AS
	BEGIN
		
		UPDATE dbo.POST
		SET ImagePost= CASE
            WHEN ImagePost= '' THEN ''
			else
			ImagePost
			end
		WHERE PostID= (SELECT PostID FROM INSERTed)
	END
GO
ALTER TABLE [dbo].[POST] ENABLE TRIGGER [Add_Path_For_Post]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_UPDATE_Post]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE TRIGGER [dbo].[Add_Path_For_UPDATE_Post]
	ON [dbo].[POST] AFTER UPDATE
	AS
	BEGIN
		IF UPDATE(ImagePost) 
			BEGIN
			UPDATE p
			SET ImagePost = CASE
					WHEN p.ImagePost = '' THEN ''
					ELSE 'data/post/'+p.PostID+'/'+p.ImagePost
				END
			FROM dbo.POST p
			INNER JOIN INSERTED i ON p.PostID = i.PostID
		END
	END
	--data/user/UID00000001/background/img.jfif
	--data/user/UID00000001/avatar/img.jfif

GO
ALTER TABLE [dbo].[POST] ENABLE TRIGGER [Add_Path_For_UPDATE_Post]
GO
/****** Object:  Trigger [dbo].[post_DELETE]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[post_DELETE]
	ON [dbo].[POST] After DELETE
	AS
	BEGIN
		UPDATE dbo.UserInfor
		SET NumPost= NumPost -1
		WHERE UserID= (SELECT UserID FROM Deleted);
	END;

-- NumInterface: tigger khi huy like va like dbo. (casi nay khong can trigger)
-- NumComment: trigger khi comment va xoa comment
	-- tăng NumComment của post kkhi đăng bình luận
GO
ALTER TABLE [dbo].[POST] ENABLE TRIGGER [post_DELETE]
GO
/****** Object:  Trigger [dbo].[post_INSERT]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[post_INSERT]
	ON [dbo].[POST] After INSERT
	AS
	BEGIN
		UPDATE dbo.UserInfor
		SET NumPost= NumPost +1
		WHERE UserID= (SELECT UserID FROM inserted);
	END;
	--nếu post đăng thì sẽ giảm thuộc tính NumPost của UserInfor đi 1
GO
ALTER TABLE [dbo].[POST] ENABLE TRIGGER [post_INSERT]
GO
/****** Object:  Trigger [dbo].[decrease_when_share_POST]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[decrease_when_share_POST]
	ON [dbo].[POSTSHARE] AFTER DELETE
	AS
	BEGIN
		UPDATE dbo.POST
		SET NumShare= NumShare -1
		WHERE PostID= (SELECT PostID FROM deleted)
	END

-- NumInterface: tigger khi huy like va like (casi nay khong can trigger)
-- trigger neu user1 va user2 dong thoi yeu cau kb cho nhau thi chuyen bit = 1;
GO
ALTER TABLE [dbo].[POSTSHARE] ENABLE TRIGGER [decrease_when_share_POST]
GO
/****** Object:  Trigger [dbo].[increase_when_share_POST]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[increase_when_share_POST]
	ON [dbo].[POSTSHARE] AFTER INSERT
	AS
	BEGIN
		UPDATE dbo.POST
		SET NumShare= NumShare +1
		WHERE PostID= (SELECT PostID FROM INSERTed)
	END
	--trigger khi xóa post
GO
ALTER TABLE [dbo].[POSTSHARE] ENABLE TRIGGER [increase_when_share_POST]
GO
/****** Object:  Trigger [dbo].[Add_Path_For_Update_user]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    CREATE TRIGGER [dbo].[Add_Path_For_Update_user]
	ON [dbo].[UserInfor] AFTER UPDATE 
	AS
	BEGIN
	IF UPDATE(ImageUser) 
		BEGIN
			UPDATE p
			SET p.ImageUser = CASE
					WHEN p.ImageUser = '' THEN ''
					ELSE 'data/user/'+p.UserID+'/avatar/'+p.ImageUser
				END
			FROM dbo.UserInfor p
			INNER JOIN INSERTED i ON p.UserID = i.UserID
		END
	IF UPDATE(ImageBackGround) 
		BEGIN
			UPDATE p
			SET p.ImageBackGround = CASE
					WHEN p.ImageBackGround = '' THEN ''
					ELSE 'data/user/'+p.UserID+'/background/'+p.ImageBackGround
				END
			FROM dbo.UserInfor p
			INNER JOIN INSERTED i ON p.UserID = i.UserID
		END
	END
	

GO
ALTER TABLE [dbo].[UserInfor] ENABLE TRIGGER [Add_Path_For_Update_user]
GO
/****** Object:  Trigger [dbo].[Create_for_note_count_userinfor]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    CREATE TRIGGER [dbo].[Create_for_note_count_userinfor]
	ON [dbo].[UserInfor] AFTER INSERT
	AS 
	BEGIN
		
		DECLARE @UserID VARCHAR(11)  
		-- Khởi tạo CURSOR để duyệt qua từng hàng trong bảng inserted
		DECLARE curRows_Create_for_note_count_userinfor CURSOR FOR
			SELECT  Inserted.UserID
			FROM inserted;
		-- Mở CURSOR
		OPEN curRows_Create_for_note_count_userinfor;

		-- Lấy hàng đầu tiên
		FETCH NEXT FROM curRows_Create_for_note_count_userinfor INTO @UserID;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Thực hiện câu lệnh cập nhật cho hàng hiện tại
			-- Ví dụ: Cập nhật cột Column3 dựa trên giá trị của cột Column1
			INSERT INTO dbo.NOTE_COUNT
			(
			    UserID,
			    NOTE,
			    MESS
			)
			VALUES
			(   @UserID,   -- UserID - varchar(11)
			    0, -- NOTE - int
			    0  -- MESS - int
			    )
			
		 -- post :là bình luậnt của bài dang
		-- comment: la binh luan tra loi comment

			-- Lấy hàng tiếp theo
			FETCH NEXT FROM curRows_Create_for_note_count_userinfor INTO  @UserID;
		
		END;
		-- Đóng CURSOR
		CLOSE curRows_Create_for_note_count_userinfor;
		DEALLOCATE curRows_Create_for_note_count_userinfor;	
    END 
GO
ALTER TABLE [dbo].[UserInfor] ENABLE TRIGGER [Create_for_note_count_userinfor]
GO
/****** Object:  Trigger [dbo].[ChangeToFriend]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	/*CREATE TRIGGER ChangeToFriend
	ON USERRELATION AFTER UPDATE
	AS
	BEGIN
		IF( UPDATE(U1RequestU2) AND UPDATE(U2RequestU1))
			UPDATE dbo.USERRELATION
			SET U1RequestU2= 0, U2RequestU1= 0, isFriend= 1
			WHERE UserID1= (SELECT UserID1 FROM dbo.USERRELATION) AND UserID2= (SELECT UserID2 FROM dbo.USERRELATION)
    END;*/
	CREATE TRIGGER [dbo].[ChangeToFriend]
	ON [dbo].[USERRELATION] AFTER UPDATE
	AS
	BEGIN
		IF EXISTS (
			SELECT *
			FROM INSERTED i1
			WHERE U1RequestU2 = 1 AND U2RequestU1 = 1
		)
		BEGIN
			UPDATE USERRELATION
			SET isFriend = 1, U1RequestU2= 0, U2RequestU1= 0
			FROM USERRELATION u
			JOIN INSERTED i1 ON u.UserID1 = i1.UserID1 AND u.UserID2 = i1.UserID2
			WHERE i1.U1RequestU2 = 1 AND i1.U2RequestU1 = 1
		END
	END;
-- NumComment: trigger khi comment va xoa comment
GO
ALTER TABLE [dbo].[USERRELATION] ENABLE TRIGGER [ChangeToFriend]
GO
/****** Object:  Trigger [dbo].[trigger_friend]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE TRIGGER [dbo].[trigger_friend]
	ON [dbo].[USERRELATION] AFTER UPDATE 
	AS
	BEGIN
		IF (UPDATE(isFriend))
		BEGIN
			IF((SELECT isFriend FROM inserted) = 1)
			BEGIN
				UPDATE [dbo].[UserInfor]
				SET NumFriend = NumFriend + 1
				WHERE UserID IN (SELECT UserID1 FROM deleted);

				UPDATE [dbo].[UserInfor]
				SET NumFriend = NumFriend + 1
				WHERE UserID IN (SELECT UserID2 FROM deleted);
			END
			ELSE
			BEGIN
				UPDATE [dbo].[UserInfor]
				SET NumFriend = NumFriend - 1
				WHERE UserID IN (SELECT UserID1 FROM deleted);

				UPDATE [dbo].[UserInfor]
				SET NumFriend = NumFriend - 1
				WHERE UserID IN (SELECT UserID2 FROM deleted);
			END
		END
	END;
GO
ALTER TABLE [dbo].[USERRELATION] ENABLE TRIGGER [trigger_friend]
GO
/****** Object:  Trigger [dbo].[UseForNOTE_FRIEND]    Script Date: 7/15/2023 2:27:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[UseForNOTE_FRIEND]
	ON [dbo].[USERRELATION] AFTER UPDATE
	AS
	BEGIN
			-- Khai báo các biến
		DECLARE @U1RequestU2 BIT 
		DECLARE @U2RequestU1 BIT 
		DECLARE @isFriend BIT 
		DECLARE @UserID1 VARCHAR(11)
		DECLARE @UserID2 VARCHAR(11)
		-- Khởi tạo CURSOR để duyệt qua từng hàng trong bảng inserted
		DECLARE curRows_UseForNOTE_FRIEND CURSOR FOR
			SELECT Inserted.U1RequestU2, Inserted.U2RequestU1,Inserted.isFriend , Inserted.UserID1, Inserted.UserID2
			FROM inserted;

		-- Mở CURSOR
		OPEN curRows_UseForNOTE_FRIEND;

		-- Lấy hàng đầu tiên
		FETCH NEXT FROM curRows_UseForNOTE_FRIEND INTO @U1RequestU2, @U2RequestU1, @isFriend, @UserID1, @UserID2;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Thực hiện câu lệnh cập nhật cho hàng hiện tại
			-- Ví dụ: Cập nhật cột Column3 dựa trên giá trị của cột Column1
			IF(@U1RequestU2= 0 AND @U2RequestU1= 1)
				BEGIN
					IF NOT EXISTS( SELECT * FROM dbo.NOTE_FRIEND WHERE UserID= @UserID1 AND UserIDRequest=@UserID2 )
						BEGIN
							INSERT INTO dbo.NOTE_FRIEND
							VALUES
							(   @UserID1,@UserID2,'sent',GETDATE(), 0 )
						END
					ELSE 
						BEGIN
							UPDATE dbo.NOTE_FRIEND
							SET statusNote='sent', TimeRequest= GETDATE()
							WHERE UserID= @UserID1 AND UserIDRequest= @UserID2
						END
					IF NOT EXISTS( SELECT * FROM dbo.NOTE_FRIEND WHERE UserID= @UserID2 AND UserIDRequest=@UserID1 )
						BEGIN
							INSERT INTO dbo.NOTE_FRIEND
							VALUES
							(   @UserID2,@UserID1,'request',GETDATE(),0 )
						END
					ELSE 
						BEGIN
							UPDATE dbo.NOTE_FRIEND
							SET statusNote='request', TimeRequest= GETDATE()
							WHERE UserID= @UserID2 AND UserIDRequest= @UserID1
						END
				END
			ELSE 
				IF(@U1RequestU2= 1 AND @U2RequestU1= 0)
					BEGIN
						IF NOT EXISTS( SELECT * FROM dbo.NOTE_FRIEND WHERE UserID= @UserID1 AND UserIDRequest=@UserID2 )
							BEGIN
								INSERT INTO dbo.NOTE_FRIEND
								VALUES
								(   @UserID1,@UserID2,'request',GETDATE(),0 )
							END
						ELSE 
							BEGIN
								UPDATE dbo.NOTE_FRIEND
								SET statusNote='request', TimeRequest= GETDATE()
								WHERE UserID= @UserID1 AND UserIDRequest= @UserID2
							END
						IF NOT EXISTS( SELECT * FROM dbo.NOTE_FRIEND WHERE UserID= @UserID2 AND UserIDRequest=@UserID1 )
							BEGIN
								INSERT INTO dbo.NOTE_FRIEND
								VALUES
								(   @UserID2,@UserID1,'sent',GETDATE(),0 )
							END
						ELSE 
							BEGIN
								UPDATE dbo.NOTE_FRIEND
								SET statusNote='sent', TimeRequest= GETDATE()
								WHERE UserID= @UserID2 AND UserIDRequest= @UserID1
							END
					END
					ELSE IF  (@U1RequestU2= 0 AND @U2RequestU1= 0 AND @isFriend= 1)
								BEGIN
									DECLARE @status NVARCHAR(30) = (
										SELECT TOP(1) statusNote
										FROM dbo.NOTE_FRIEND
										WHERE UserID = @UserID1 AND UserIDRequest = @UserID2
									)

									IF(@status = 'sent')
										BEGIN
											UPDATE dbo.NOTE_FRIEND
											SET TimeRequest= GETDATE(), statusNote= 'isFriend'
											WHERE UserID= @UserID1 AND UserIDRequest= @UserID2
											UPDATE dbo.NOTE_FRIEND
											SET TimeRequest= GETDATE(), statusNote= 'accepted'
											WHERE UserID= @UserID2 AND UserIDRequest= @UserID1
										END
									ELSE IF(@status = 'request')
										BEGIN
											UPDATE dbo.NOTE_FRIEND
											SET TimeRequest= GETDATE(), statusNote= 'accepted'
											WHERE UserID= @UserID1 AND UserIDRequest= @UserID2
											UPDATE dbo.NOTE_FRIEND
											SET TimeRequest= GETDATE(), statusNote= 'isFriend'
											WHERE UserID= @UserID2 AND UserIDRequest= @UserID1
										END
								END
						
					 -- sent    : nguoi dung khac yeu cau
		 -- request : minh yeu cau
		 -- accepted: yeu cau cua minh duoc chap nhan
		 -- isFriend: minh chap nhan yeu cau
		-- Duyệt qua từng hàng và thực hiện các câu lệnh tương ứng

			-- Lấy hàng tiếp theo
			FETCH NEXT FROM curRows_UseForNOTE_FRIEND INTO @U1RequestU2, @U2RequestU1, @isFriend, @UserID1, @UserID2;
		
		END;
		-- Đóng CURSOR
		CLOSE curRows_UseForNOTE_FRIEND;
		DEALLOCATE curRows_UseForNOTE_FRIEND;
	END;
GO
ALTER TABLE [dbo].[USERRELATION] ENABLE TRIGGER [UseForNOTE_FRIEND]
GO
