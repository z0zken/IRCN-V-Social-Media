go
create database SocialMedia;
go
USE SocialMedia
GO
/****** Object:  Table [dbo].[POST]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[POSTSHARE]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  View [dbo].[PostSummaryByMonth]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[ReportPost]    Script Date: 7/14/2023 3:56:30 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Post_User] UNIQUE NONCLUSTERED 
(
	[PostID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ReportPostView]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[ReportComment1686]    Script Date: 7/14/2023 3:56:30 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Comment_User] UNIQUE NONCLUSTERED 
(
	[CommentID] ASC,
	[UserID] ASC,
	[IsPost] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportUser1686]    Script Date: 7/14/2023 3:56:30 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_User_User] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[UserIDRP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserInfor]    Script Date: 7/14/2023 3:56:30 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[UserReportSummary]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  View [dbo].[UserView]    Script Date: 7/14/2023 3:56:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[UserView] AS
SELECT UserID, ImageUser, FullName, Address, Mail, Account, PhoneNumber, Dob, Nation, RoleID
FROM UserInfor;
GO
/****** Object:  Table [dbo].[COMMENT]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[COMMENTSHARE]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  View [dbo].[ReportCommentView]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[Active]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[Advertisement]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[Business]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[COMMENTCHILD]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[CHATCONTENT]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[InterFace]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[InterFaceObject]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[MAIL]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[MonthlyUsage]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[NOTE_COMMENT]    Script Date: 7/14/2023 3:56:30 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uc_UserID_NoteID] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[NoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NOTE_COUNT]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[NOTE_FRIEND]    Script Date: 7/14/2023 3:56:30 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uc_UserID_UserIDRequest] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[UserIDRequest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NOTE_lIKE]    Script Date: 7/14/2023 3:56:30 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uc_UserID_ObjectID] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[ObjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Privacy]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[Role]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[UserLock]    Script Date: 7/14/2023 3:56:30 PM ******/
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
/****** Object:  Table [dbo].[USERRELATION]    Script Date: 7/14/2023 3:56:30 PM ******/
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
ALTER TABLE [dbo].[USERRELATION]  WITH CHECK ADD CHECK  (([UserID1]>[UserID2]))
GO
