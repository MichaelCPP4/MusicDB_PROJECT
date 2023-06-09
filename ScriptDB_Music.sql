USE [master]
GO
/****** Object:  Database [MusicDB]    Script Date: 24.05.2023 2:18:19 ******/
CREATE DATABASE [MusicDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MusicDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MusicDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MusicDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\MusicDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [MusicDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MusicDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MusicDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MusicDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MusicDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MusicDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MusicDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [MusicDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MusicDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MusicDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MusicDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MusicDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MusicDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MusicDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MusicDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MusicDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MusicDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MusicDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MusicDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MusicDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MusicDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MusicDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MusicDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MusicDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MusicDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MusicDB] SET  MULTI_USER 
GO
ALTER DATABASE [MusicDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MusicDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MusicDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MusicDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MusicDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MusicDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MusicDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [MusicDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [MusicDB]
GO
/****** Object:  UserDefinedFunction [dbo].[GetAlbumDuration]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAlbumDuration](@albumId INT)
RETURNS INT
AS
BEGIN
    DECLARE @duration INT;

    SELECT @duration = SUM(Length)
    FROM Tracks
    WHERE AlbumId = @albumId;

    RETURN @duration;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetArtistDescriptionByIndex]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetArtistDescriptionByIndex]
(
    @Index INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @Description VARCHAR(MAX);

    SELECT @Description = Description
    FROM dbo.Artists
    WHERE Id = (SELECT Id FROM dbo.Artists ORDER BY Id OFFSET @Index ROWS FETCH NEXT 1 ROWS ONLY);

    RETURN @Description;
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetMaxTrackNumberForAlbum]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetMaxTrackNumberForAlbum]
(
    @albumId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @maxTrackNumber INT;

    SELECT @maxTrackNumber = MAX(TrackNumber)
    FROM Tracks
    WHERE AlbumId = @albumId;

    RETURN ISNULL(@maxTrackNumber, 0);
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetPlaylistTrackCount]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetPlaylistTrackCount](@playlistId INT)
RETURNS INT
AS
BEGIN
    DECLARE @trackCount INT;

    SELECT @trackCount = COUNT(*)
    FROM PlaylistTracks
    WHERE PlaylistId = @playlistId;

    RETURN @trackCount;
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetTrackCountByGenre]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetTrackCountByGenre]
(
    @genreId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @trackCount INT;
    
    --Код для получения количества треков определенного жанра
    SELECT @trackCount = COUNT(*)
    FROM Tracks T
    INNER JOIN TrackGenres TG ON T.Id = TG.TrackId
    WHERE TG.GenreId = @genreId;

    RETURN @trackCount;
END
GO
/****** Object:  Table [dbo].[Albums]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Albums](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ArtistId] [int] NULL,
	[ReleaseDate] [date] NOT NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Artists]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Artists](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tracks]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tracks](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[AlbumId] [int] NULL,
	[Length] [int] NOT NULL,
	[TrackNumber] [int] NOT NULL,
	[Lyrics] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[TrackList]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TrackList]
AS
SELECT        T.Name AS TrackName, A.Name AS Artist, Alb.Name AS Album, T.Length AS Duration
FROM            dbo.Tracks AS T INNER JOIN
                         dbo.Albums AS Alb ON T.AlbumId = Alb.Id INNER JOIN
                         dbo.Artists AS A ON Alb.ArtistId = A.Id
GO
/****** Object:  Table [dbo].[Genres]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genres](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrackGenres]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrackGenres](
	[TrackId] [int] NOT NULL,
	[GenreId] [int] NOT NULL,
 CONSTRAINT [PK_TrackGenres] PRIMARY KEY CLUSTERED 
(
	[TrackId] ASC,
	[GenreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AlbumList]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AlbumList]
AS
SELECT        Alb.Name AS AlbumName, A.Name AS Artist, Alb.ReleaseDate AS ReleaseYear, G.Name AS Genre
FROM            dbo.Albums AS Alb INNER JOIN
                         dbo.Artists AS A ON Alb.ArtistId = A.Id LEFT OUTER JOIN
                             (SELECT        AlbumId, MIN(TrackNumber) AS FirstTrackNumber
                               FROM            dbo.Tracks AS T
                               GROUP BY AlbumId) AS FT ON Alb.Id = FT.AlbumId INNER JOIN
                         dbo.Tracks AS T ON Alb.Id = T.AlbumId AND T.TrackNumber = FT.FirstTrackNumber INNER JOIN
                         dbo.TrackGenres AS TG ON T.Id = TG.TrackId INNER JOIN
                         dbo.Genres AS G ON TG.GenreId = G.Id
GO
/****** Object:  View [dbo].[ArtistView]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ArtistView] AS
SELECT Id, Name, Country
FROM dbo.Artists
GO
/****** Object:  Table [dbo].[Playlists]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Playlists](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlaylistTracks]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlaylistTracks](
	[PlaylistId] [int] NOT NULL,
	[TrackId] [int] NOT NULL,
 CONSTRAINT [PK_PlaylistTracks] PRIMARY KEY CLUSTERED 
(
	[PlaylistId] ASC,
	[TrackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[PlaylistView]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PlaylistView]
AS
SELECT        TOP (100) PERCENT p.Id, p.Name AS PlaylistName, COUNT(t.Id) AS TrackCount, CAST(SUM(t.Length) / 60.0 AS DECIMAL(10, 2)) AS PlaylistDuration
FROM            dbo.Playlists AS p INNER JOIN
                         dbo.PlaylistTracks AS pt ON p.Id = pt.PlaylistId INNER JOIN
                         dbo.Tracks AS t ON pt.TrackId = t.Id
GROUP BY p.Name, p.Id
ORDER BY p.Id
GO
/****** Object:  UserDefinedFunction [dbo].[SearchArtistByName]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SearchArtistByName]
(
    @artistName NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1 *
    FROM Artists
    WHERE Name LIKE '%' + @artistName + '%'
    ORDER BY Id
)
GO
/****** Object:  UserDefinedFunction [dbo].[SearchAlbumByTitle]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SearchAlbumByTitle]
(
    @albumTitle NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 1 *
    FROM Albums
    WHERE "Name" LIKE '%' + @albumTitle + '%'
    ORDER BY Id
)

GO
/****** Object:  UserDefinedFunction [dbo].[FilterTracksByAlbumId]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FilterTracksByAlbumId]
(
    @albumId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Tracks
    WHERE AlbumId = @albumId
)

GO
/****** Object:  UserDefinedFunction [dbo].[GetPlaylistTracks]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetPlaylistTracks]
(
    @playlistId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT T.Id, T.Name
    FROM Tracks T
    INNER JOIN PlaylistTracks PT ON T.Id = PT.TrackId
    WHERE PT.PlaylistId = @playlistId
)

GO
/****** Object:  UserDefinedFunction [dbo].[SearchTracksByKeyword]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SearchTracksByKeyword]
(
    @keyword NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (1) *
    FROM Tracks
    WHERE Name LIKE '%' + @keyword + '%' OR Lyrics LIKE '%' + @keyword + '%'
)
GO
/****** Object:  UserDefinedFunction [dbo].[GetAlbumsByGenre]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAlbumsByGenre](@genreId INT)
RETURNS TABLE
AS
RETURN (
--Функция используется для получения всех альбомов, связанных с определенным жанром.
    SELECT A.*
    FROM Albums A
    WHERE EXISTS (
        SELECT 1
        FROM TrackGenres TG
        INNER JOIN Tracks T ON TG.TrackId = T.Id
        WHERE TG.GenreId = @genreId
        AND T.AlbumId = A.Id
    )
);
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleId] [int] NOT NULL,
	[RoleName] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[RoleId] [int] NULL,
	[FullName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK__Users__1788CC4C2F49B257] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (1, N'The Game', 1, CAST(N'1980-06-27' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (2, N'Black In Black', 2, CAST(N'1980-07-25' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (3, N'Die For You', 3, CAST(N'2023-02-24' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (4, N'Cold Heart (PHAU Remix)', 4, CAST(N'2021-08-13' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (5, N'DAMN.', 5, CAST(N'2017-04-14' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (6, N'Curtain Call 2', 7, CAST(N'2022-08-05' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (7, N'Express Youself', 8, CAST(N'1989-03-27' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (8, N'Чайковский, Vol. 1 (1936,1937)', 9, CAST(N'1878-05-01' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (9, N'This Is What I Mean', 6, CAST(N'2022-11-25' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (10, N'Времена года', 10, CAST(N'1720-08-07' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (11, N'Get Lucky', 11, CAST(N'2013-04-19' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (12, N'No Geography', 12, CAST(N'2019-04-12' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (13, N'God''s Gonna Cut You Down', 13, CAST(N'2006-01-01' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (14, N'Queen Of Me', 14, CAST(N'2023-02-03' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (15, N'What A Wonderful World', 15, CAST(N'1968-01-01' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (16, N'Out On The Road', 16, CAST(N'2023-05-05' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (17, N'So Lonely l''ll Be', 17, CAST(N'2023-02-20' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (18, N'John Lee Hooker Blues', 18, CAST(N'2018-10-26' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (19, N'Ride The Lightning', 19, CAST(N'1984-07-26' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (20, N'A Matter of Life and Death', 20, CAST(N'2015-08-28' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (21, N'Jazz', 21, CAST(N'2007-01-01' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (22, N'Live In Washington DC 1977', 22, CAST(N'1977-07-05' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (23, N'Nesta!', 23, CAST(N'2021-09-07' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (24, N'Marcus Garvey', 24, CAST(N'1975-02-12' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (25, N'Aretha Now', 25, CAST(N'1968-07-14' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (26, N'Midnicht Love', 26, CAST(N'1982-10-01' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (27, N'Amoroso', 27, CAST(N'1977-09-23' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (28, N'The Car', 28, CAST(N'2022-10-21' AS Date), NULL)
INSERT [dbo].[Albums] ([Id], [Name], [ArtistId], [ReleaseDate], [Description]) VALUES (29, N'The Slow Rush', 29, CAST(N'2020-02-14' AS Date), NULL)
GO
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (1, N'Queen', N'Великобритания', N'Queen (Великобритания) - британская рок-группа, основанная в 1970 году. Стиль группы включает в себя элементы хард-рока, глэма-рока, прогрессив-рока и поп-музыки. Queen стали одной из наиболее коммерчески успешных рок-групп в истории, продав более 300 миллионов альбомов.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (2, N'AC/DC', N'Австралия', N'AC/DC (Австралия) - Австралийская рок-группа, основанная в 1973 году. Их характерный звук, основанный на громких гитарных риффах и вокале Брайана Джонсона, сделал их одними из самых известных и популярных рок-групп в мире.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (3, N'Ariana Grande', N'США', N'Ariana Grande (США) - американская певица и актриса, начавшая карьеру в 2008 году. Стиль ее музыки включает в себя элементы поп-музыки, R&B, соула и хип-хопа. Grande получила множество наград, включая 1 премию Грэм')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (4, N'Dua Lipa', N'Великобритания', N'Dua Lipa: Дуа Липа - британская певица и автор песен. Она начала свою карьеру в 2015 году, выпустив свой первый сингл "New Love". Однако ее мировой успех пришел с выпуском сингла "Be the One" в 2017 году, за которым последовали хиты, такие как "One Kiss", "IDGAF" и "Don''t Start Now". Липа является обладательницей двух наград Грэмми и ее музыка часто сочетает в себе элементы поп-музыки и танцевальной музыки.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (5, N'Kendrick Lamar', N'США', N'Kendrick Lamar (США) - Американский рэпер и автор песен, начал свою карьеру в 2003 году. Он получил множество наград и стал одним из самых уважаемых рэперов в мире, выпустив альбомы, такие как "good kid, m.A.A.d city" и "To Pimp a Butterfly".')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (6, N'Stormzy ', N'Великобритания', N'Stormzy (Великобритания) - Британский рэпер и автор песен, начал свою карьеру в 2011 году. Он стал известен после выпуска своего первого альбома "Gang Signs & Prayer" и стал одним из самых влиятельных рэперов в Великобритании.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (7, N'Eminem ', N'США', N'Eminem - американский рэпер, продюсер и актёр. Родился в 1972 году в Сент-Джозефе, Миссури. Начал свою карьеру в рэпе в 1996 году с выпуска своего дебютного альбома "Infinite". Однако настоящий успех пришёл к нему в 1999 году с альбомом "The Slim Shady LP". Его работы получили 15 премий "Грэмми". Eminem является одним из наиболее продаваемых рэп-исполнителей всех времён.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (8, N'N.W.A', N'США', N'N.W.A - американская группа, образованная в Лос-Анджелесе в 1986 году. Состав группы включал Ice Cube, Dr. Dre, Eazy-E, MC Ren и DJ Yella. Они стали одними из основоположников гангста-рэпа и получили большую известность своим альбомом "Straight Outta Compton" в 1988 году. N.W.A считается одной из самых влиятельных групп в истории хип-хопа.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (9, N'Чайковский П.И.', N'Россия', N'Чайковский П.И. - русский композитор и дирижёр, родившийся в 1840 году в Воткинске. Чайковский стал одним из наиболее популярных и известных композиторов в мире благодаря своим операм, балетам, симфониям и концертам для фортепиано и скрипки. Его произведения, такие как "Лебединое озеро", "Щелкунчик" и "Симфония № 5", по сей день остаются классикой мировой музыки.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (10, N'Antonio Vivaldi', N'Италия', N'Antonio Vivaldi - итальянский композитор и скрипач, родившийся в 1678 году в Венеции. Он стал одним из самых известных композиторов барокко благодаря своим концертам для скрипки и оркестра, таким как "Времена года". Его музыка отличалась яркостью и красочностью, а его техника скрипки была превосходной.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (11, N'Daft Punk', N'Франция', N'Daft Punk - французский дуэт, образованный в 1993 году. В его состав входили Томас Бангальтер и Ги-Мануэль де Омем-Кристо. Их музыка включает элементы хауса, электро, диско и фанка. Daft Punk получили несколько наград Grammy и продали более 12 миллионов альбомов во всем мире. В 2021 году дуэт распался.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (12, N'The Chemical Brothers', N'Великобритания', N'The Chemical Brothers - британский дуэт, образованный в 1989 году. В его состав входят Том Роулендс и Эд Саймонс. The Chemical Brothers исполняют музыку в жанрах хауса, биг-бита и электроники. Они выпустили восемь студийных альбомов, получили несколько наград Grammy и продали более 12 миллионов альбомов.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (13, N'Johnny Cash', N'США', N'Johnny Cash - американский певец, гитарист и автор песен. Родился в 1932 году в Арканзасе. Cash получил мировую известность в 1950-х годах своими хитами "I Walk the Line", "Ring of Fire" и другими. Он является одним из самых влиятельных исполнителей кантри и фолк-музыки в истории. Cash умер в 2003 году в возрасте 71 года.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (14, N'Shania Twain', N'Канада', N'Shania Twain - канадская певица и автор песен. Родилась в 1965 году в Онтарио. Twain получила широкую популярность в 1990-х годах благодаря своему альбому "The Woman in Me" и песням "Man! I Feel Like a Woman!" и "You''re Still the One". Она продала более 100 миллионов альбомов во всем мире и получила несколько наград Grammy.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (15, N' Louis Armstrong', N'США', N'Louis Armstrong - американский джазовый трубач, певец и актёр. Родился в Новом Орлеане в 1901 году. Armstrong стал одним из самых известных джазовых музыкантов в мире, благодаря своей виртуозности на трубе и своему харизматическому вокалу. Он записал более 60 альбомов и получил множество наград за свою музыку.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (16, N'Norah Jones', N'США', N'Norah Jones: Нора Джонс - американская певица и автор песен, обладательница девяти наград Грэмми. Ее музыка сочетает в себе элементы джаза, кантри и фолка. Она получила широкую известность после выпуска своего дебютного альбома "Come Away with Me" в 2002 году, который стал бестселлером в США и Великобритании. В дальнейшем Джонс выпустила множество успешных альбомов и сотрудничала с такими музыкантами, как Билли Джоэл и Долли Партон.
')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (17, N'B.B. King', N'США', N'B.B. King (США) - американский блюзовый гитарист, певец и автор песен. Он считается одним из самых влиятельных гитаристов в истории блюза и рока. Родился в 1925 году в Миссисипи, начал свою карьеру в 1940-х годах, записал более 40 альбомов и был удостоен 15 премий Грэмми.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (18, N'John Lee Hooker', N'США', N'John Lee Hooker: Джон Ли Хукер - американский блюзовый гитарист и певец, часто называемый "королем буги-вуги". Он начал свою карьеру в 1940-х годах и записал более 100 альбомов за свою жизнь. Хукер стал известен своими характерными гитарными риффами и глубоким, хриплым голосом. Он внес значительный вклад в развитие блюза и влиял на многих известных музыкантов, включая Карлоса Сантану и Эрика Клэптона.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (19, N'Metallica', N'США', N'Metallica (США) - американская метал-группа, основанная в 1981 году в Лос-Анджелесе. Она стала одной из самых успешных и популярных групп в истории метал-музыки, продав более 125 миллионов альбомов по всему миру. Группа получила множество наград, в том числе 9 премий Грэмми.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (20, N'Iron Maiden', N'Великобритания', N'Iron Maiden (Великобритания) - британская метал-группа, основанная в 1975 году. Она известна своим уникальным звучанием, запоминающимися мелодиями и символическим образом - "брендом" группы является скелет Эдди. Группа выпустила более 40 альбомов и получила множество наград.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (21, N'James Brown', N'США', N'James Brown (США) - американский фанк-музыкант, певец, автор песен и танцор. Он считается "королем соула" и "отцом фанка", в его репертуаре более 100 хитов. Родился в 1933 году в Южной Каролине, начал свою карьеру в 1950-х годах и получил множество наград и награждений за свой талант и вклад в музыку.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (22, N'Parliament-Funkadelic', N'США', N'Parliament-Funkadelic: Парламент-Фанкаделик - американская фанк-группа, основанная в 1960-х годах. Они известны своими яркими, экспериментальными выступлениями и сильным влиянием соула, джаза и рок-музыки. В состав группы входило множество талантливых музыкантов.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (23, N'Bob Marley', N'Ямайка', N'Bob Marley: Боб Марли - ямайский певец, композитор и гитарист, один из самых известных исполнителей регги. Родился в 1945 году в небольшом городке на Ямайке. С детства проявлял интерес к музыке и начал играть на гитаре в 14 лет. В 1963 году Боб Марли и его друзья создали группу The Wailers, которая стала популярной благодаря сочинению регги-хитов, таких как "Stir It Up" и "Get Up, Stand Up". Марли также активно участвовал в политической жизни своей страны, выступая за равенство и справедливость. Он умер в 1981 году от рака.
')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (24, N'Burning Spear', N'Ямайка', N'Burning Spear: Уинстон Родни - ямайский регги-певец, известный под псевдонимом Burning Spear. Родился в 1945 году на Ямайке. С детства проявлял интерес к музыке и начал выступать в качестве профессионального музыканта в 1969 году. Он быстро стал популярным благодаря своим характерным регги-ритмам и текстам, которые выражали политические и социальные идеи. Он выпустил более 20 альбомов и продолжает концертировать по всему миру.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (25, N'Aretha Franklin', N'США', N'Aretha Franklin: Арета Франклин - американская певица, известная как "Королева соула". Родилась в 1942 году в Мемфисе, штат Теннесси. Она начала петь в церковном хоре в возрасте 10 лет и затем продолжила свою музыкальную карьеру, записывая ритм-энд-блюз и соул-хиты, такие как "Respect", "Think" и "Chain of Fools". Арета Франклин была первой женщиной, которой было присуждено звание "легенда" на церемонии вручения премии Грэмми. Она умерла в 2018 году.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (26, N'Marvin Gaye', N'США', N'Marvin Gaye (1939-1984) был американским певцом, автором песен и продюсером. Он был одним из величайших исполнителей в истории соула и R&B музыки. В начале своей карьеры Gaye работал в качестве сессионного музыканта для лейбла Motown, где записывался с такими артистами, как The Supremes и Stevie Wonder. В 1970-х он начал записывать более социально-ориентированную музыку, такую как "What''s Going On" и "Mercy Mercy Me", которые стали классикой жанра. Он также записал множество других хитов, включая "Sexual Healing" и "Let''s Get It On". Gaye был убит своим отцом в 1984 году в возрасте 44 лет.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (27, N'João Gilberto', N'Бразилия', N'João Gilberto: Жоао Жильберту был бразильским певцом, гитаристом и композитором, известным как отец босса-новы. Родился в Баия в 1931 году, Жильберту развил новый стиль бразильской музыки, сочетая традиционные самба-ритмы с джазовой гармоникой. Его дебютный альбом "Chega de Saudade" был выпущен в 1959 году и считается одним из наиболее влиятельных альбомов бразильской музыки. Жильберту умер в 2019 году в возрасте 88 лет.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (28, N'Arctic Monkeys', N'Великобритания', N'Arctic Monkeys: Arctic Monkeys - это британская рок-группа, основанная в 2002 году в Шеффилде. Они выпустили свой дебютный альбом "Whatever People Say I Am, That''s What I''m Not" в 2006 году, который стал самым быстро продаваемым дебютным альбомом в истории Великобритании. Группа прославилась своими взрывными живыми выступлениями и интеллектуальными текстами песен, которые обычно описывают повседневную жизнь молодежи. Их стиль включает элементы гаражного рока, инди-рока и панк-рока.')
INSERT [dbo].[Artists] ([Id], [Name], [Country], [Description]) VALUES (29, N'Tame Impala', N'Австралия', N'Tame Impala: Tame Impala - это австралийская группа, основанная в 2007 году в Перте. Главным музыкантом и композитором группы является Кевин Паркер, который записывает все инструменты и вокал на своих студийных альбомах. Стиль Tame Impala объединяет в себе элементы психоделического рока, электронной музыки и ретро-фанка. Группа быстро набрала популярность благодаря своему дебютному альбому "Innerspeaker" в 2010 году, а также альбому "Lonerism" в 2012 году.')
GO
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (1, N'Рок', N'Рок - жанр гитарной музыки с упором на риффы и сильный ритм.')
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (2, N'поп-музыка', N'Поп - музыкальный жанр, цель которого создать приятную и запоминающуюся мелодию для массовой аудитории.')
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (3, N'Хип-хоп', N' Хип-хоп - музыкальный жанр, включающий ритмичный рэп, сэмплинг и битбоксинг.')
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (4, N'Рэп', N'Рэп - это жанр музыки, который характеризуется ритмичным чтением слов под фон музыки. Рэп сформировался в культуре афроамериканцев в США в 1970-х годах и стал одним из наиболее популярных жанров в мировой музыке. Тексты рэп-песен обычно затрагивают социальные, политические и культурные темы, такие как расизм, насилие, наркотики, полиция и т.д.')
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (5, N'Классическая', N'Классическая - музыкальный жанр, включающий музыку периода Барокко, Классицизма и Романтизма.')
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (6, N'Электронная', N'Электронная - музыкальный жанр, созданный на основе электронных инструментов и обработки звука с помощью компьютеров.')
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (7, N'Кантри', N'Кантри - музыкальный жанр, имеющий корни в фольклоре и народной музыке южных штатов США.')
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (8, N'Джаз', N'Джаз - музыкальный жанр, включающий импровизацию и использование характерного гармонического прогресса.')
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (9, N'Блюз', N'Блюз - музыкальный жанр, имеющий корни в афроамериканской культуре, обычно включающий гитару, гармонику и сильный ритм.')
INSERT [dbo].[Genres] ([Id], [Name], [Description]) VALUES (10, N'Метал', N'Метал - музыкальный жанр, включающий более тяжелые гитарные звуки и часто использующий двойную бочку.')
GO
INSERT [dbo].[Playlists] ([Id], [Name], [Description]) VALUES (1, N'Избранное', N'В этом плейлисте избранные треки')
INSERT [dbo].[Playlists] ([Id], [Name], [Description]) VALUES (2, N'Для прогулки', N'Спокойная музыка для отдыха на прогулке')
INSERT [dbo].[Playlists] ([Id], [Name], [Description]) VALUES (3, N'Плейлист для игры в Wat Thunder', N'Музыка для агрессивного геймплея в War Thunder')
INSERT [dbo].[Playlists] ([Id], [Name], [Description]) VALUES (4, N'Рок/Метал', N'Лучшие треки рока и метала')
INSERT [dbo].[Playlists] ([Id], [Name], [Description]) VALUES (5, N'Электронная музыка', NULL)
INSERT [dbo].[Playlists] ([Id], [Name], [Description]) VALUES (6, N'Треннировка', NULL)
GO
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 1)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 3)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 4)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 6)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 8)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 19)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 22)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 33)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 45)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 55)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 78)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (1, 99)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (2, 14)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (2, 18)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (2, 23)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (2, 56)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (2, 66)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (2, 71)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (2, 79)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (2, 84)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (3, 1)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (3, 2)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (3, 3)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (3, 4)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (3, 5)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (3, 11)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (3, 12)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (3, 13)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (3, 17)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 1)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 2)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 3)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 4)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 5)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 6)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 7)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 8)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 9)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 10)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 11)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 12)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 13)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 14)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 15)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 16)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 17)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 18)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 19)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 20)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 87)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 99)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (4, 100)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (5, 63)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (5, 64)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (5, 65)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (5, 66)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (5, 67)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (5, 68)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (6, 1)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (6, 3)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (6, 15)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (6, 16)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (6, 19)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (6, 64)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (6, 66)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (6, 67)
INSERT [dbo].[PlaylistTracks] ([PlaylistId], [TrackId]) VALUES (6, 68)
GO
INSERT [dbo].[Roles] ([RoleId], [RoleName]) VALUES (1, N'Клиент')
INSERT [dbo].[Roles] ([RoleId], [RoleName]) VALUES (2, N'Менеджер')
INSERT [dbo].[Roles] ([RoleId], [RoleName]) VALUES (3, N'Администратор')
GO
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (1, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (2, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (3, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (4, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (5, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (6, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (7, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (8, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (9, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (10, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (11, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (12, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (13, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (14, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (15, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (16, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (17, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (18, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (19, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (20, 1)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (21, 2)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (22, 2)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (23, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (24, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (25, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (26, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (27, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (28, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (29, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (30, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (31, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (32, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (33, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (34, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (35, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (36, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (37, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (38, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (39, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (40, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (41, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (42, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (43, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (44, 4)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (45, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (46, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (47, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (48, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (49, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (50, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (51, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (52, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (53, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (54, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (55, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (56, 3)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (57, 5)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (58, 5)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (59, 5)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (60, 5)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (61, 5)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (62, 5)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (63, 6)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (64, 6)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (65, 6)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (66, 6)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (67, 6)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (68, 6)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (69, 7)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (70, 7)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (71, 7)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (72, 7)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (73, 7)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (74, 7)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (75, 7)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (76, 8)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (77, 8)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (78, 9)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (79, 9)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (80, 9)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (81, 9)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (82, 9)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (83, 9)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (84, 9)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (85, 9)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (86, 9)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (87, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (88, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (89, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (90, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (91, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (92, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (93, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (94, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (95, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (96, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (97, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (98, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (99, 10)
INSERT [dbo].[TrackGenres] ([TrackId], [GenreId]) VALUES (100, 10)
GO
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (1, N'Play the Game', 1, 210, 1, N'Open up your mind and let me step inside
Rest your weary head and let your heart decide
It''s so easy when you know the rules
It''s so easy all you have to do
Is fall in love
Play the game
Everybody play the game of love
Ooh yeah

When you''re feeling down and your resistance is low
Light another cigarette and let yourself go
This is your life
Don''t play hard to get
It''s a free world
All you have to do is fall in love
Play the game - yeah
Everybody play the game of love
Ooh yeah

My game of love has just begun
Love runs from my head down to my toes
My love is pumping through my veins
Play the game
Driving me insane
Come come come come come play the game
Play the game play the game play the game

Play the game
Everybody play the game of love
This is your life - don''t play hard to get
It''s a free free world
All you have to do is fall in love
Play the game
Yeah play the game of love
Your life - don''t play hard to get
It''s a free free world
All you have to do is fall in love
Play the game yeah everybody play the game of love
')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (2, N'Dragon Attack', 1, 258, 2, N'Take me to the room where the red''s all red
Take me out of my head — ''s what I said...
Take me to the room where the green''s all green
And from what I''ve seen it''s hot, it''s mean...

- Gonna use my stack
- It''s gotta be Mack
- Gonna get me on the track
- Got a dragon on my back

Take me to the room where the beat''s all round
Реклама•
MediaSniper
Gonna eat that sound — (yeah yeah yeah)...
Take me to the room where the black''s all white
And the white''s all black, take me back to the shack...

- She don''t take no prisoners
- Gonna give me the business
- Got a dragon on my back
- It''s a dragon attack

Low down — She don''t take no prisoners
Go down — Gonna give me the business
No time — Yeah chained to the rack!
Show time — Got a dragon on my back
Show down — Go find another customer
Slow down — I gotta make my way...')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (3, N'Another One Bites the Dust', 1, 215, 3, N'Ooh, let''s go
Steve walks warily down the street
With the brim pulled way down low
Ain''t no sound but the sound of his feet
Machine guns ready to go
Are you ready? Hey, are you ready for this?
Are you hanging on the edge of your seat?
Out of the doorway, the bullets rip
To the sound of the beat, yeah
Another one bites the dust
Another one bites the dust
And another one gone, and another one gone
Another one bites the dust
Hey, I''m gonna get you too
Another one bites the dust
How do you think I''m going to get along?
Without you, when you''re gone
You took me for everything that I had
And kicked me out on my own
Are you happy, are you satisfied?
How long can you stand the heat?
Out of the doorway the bullets rip
To the sound of the beat, look out
Another one bites the dust
Another one bites the dust
And another one gone, and another one gone
Another one bites the dust
Hey, I''m gonna get you too
Another one bites the dust
Hey
Oh, take it
Bite the dust
Bite the dust
Another one bites the dust
Another one bites the dust, ow
Another one bites the dust, hey, hey
Another one bites the dust, hey-eh-eh
(Ooh, shut up)
There are plenty of ways you can hurt a man
And bring him to the ground
You can beat him, you can cheat him
You can treat him bad and leave him when he''s down, yeah
But I''m ready, yes, I''m ready for you
I''m standing on my own two feet
Out of the doorway the bullets rip
Repeating the sound of the beat, oh, yeah
Another one bites the dust
Another one bites the dust
And another one gone, and another one gone
Another one bites the dust
Hey, I''m gonna get you too
Another one bites the dust
Shoot out
Ay-yeah
Alright')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (4, N'Need Your Loving Tonight', 1, 170, 4, N'Yeah!
Hey, hey, hey

[Verse 1]
No, I''ll never look back in anger
No, I''ll never find me an answer
You promised me you''d keep in touch
I read your letter and it hurt me so much

[Chorus]
I said I''d never
Never be angry with you

[Verse 2]
I don''t wanna feel like a stranger, no
''Cause I''d rather stay out of danger
I read your letter so many times
I got your meaning between the lines

[Chorus]
I said I''d never
Never be angry with you

[Bridge]
I must be strong so she won''t know
How much I miss her
I only hope as time
Goes on, I''ll forget her
My body''s aching, can''t sleep at night
I''m too exhausted to start a fight
And if I see her with another guy
I''ll eat my heart out ''cause I love
Love, love, love her
You might also like
Crazy Little Thing Called Love
Queen
Sail Away Sweet Sister
Queen
Save Me
Queen
[Verse 3]
Come on baby, let''s get together
I''ll love you, baby, I''ll love you forever
I''m trying hard, to stay away
What made you change, what did I say?

[Refrain]
Ooh, I need your loving tonight
Ooh, I need your loving
Ooh, I need your loving
Ooh, I need your loving, baby, tonight
(Hit me)

[Guitar Solo]

[Interlude]
Ooh, I need your loving tonight

[Verse 4]
No, I''ll never, look back in anger
No, I''ll never, find me an answer
Gave me no warning, how could I guess
I''ll have to learn to forgive and forget

[Refrain]
Ooh, I need your loving
Ooh, I need your loving
Ooh, I need your loving tonight')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (5, N'Crazy Little Thing Called Love', 1, 164, 5, N'This thing called love
I just can''t handle it
This thing called love
I must get ''round to it, I ain''t ready
Crazy little thing called love
This thing (this thing) called love (called love)
It cries (like a baby) in a cradle all night
It swings (woo-ooo), it jives (woo-woo)
It shakes all over like a jelly fish
I kinda like it
Crazy little thing called love
There goes my baby
She knows how to rock and roll
She drives me crazy
She gives me hot and cold fever
Then she leaves me in a cool, cool sweat
I gotta be cool, relax
Get hip, get on my tracks
Take a back seat, hitch-hike
And take a long ride on my motorbike
Until I''m ready
Crazy little thing called love
Yeah, I gotta be cool, relax
Get hip and get on my tracks
Take a back seat, hitchhike (ahem, ahem)
And take a long ride on my motorbike
Until I''m ready (ready, Freddie)
Crazy little thing called love
This thing called love
I just can''t handle it
This thing called love
I must get ''round to it, I ain''t ready (ooh)
Crazy little thing called love
Crazy little thing called love (yeah, yeah)
Crazy little thing called love (yeah, yeah)
Crazy little thing called love (yeah, yeah)
Crazy little thing called love (yeah, yeah)
Crazy little thing called love (yeah, yeah)
Crazy little thing called love (yeah, yeah)
Crazy little thing called love (yeah, yeah)
Crazy little thing called love')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (6, N'Rock It (Prime Jive)', 1, 273, 6, N'When I hear that rock and roll,
It gets down to my soul,
When it''s real rock and roll, oh rock and roll

You really think they like to rock in space?
Well I don''t know
What do you know?
What do you hear?
On the radio
Coming through the air I said Mama
I ain''t crazy
I''m alright - alright
Hey, c''mon baby said it''s alright
To rock and roll on a Saturday night

I said shoot and get your suit and come along with me
I said c''mon baby down come and rock and roll with me,
I said yeah

What do you do
To get to feel alive?
You go downtown
And get some of that prime jive

I said Mama

We''re gonna rock it tonight
(We want some prime jive)
We''re gonna rock it tonight
C''mon honey
Get some of that prime jive
Get some of that, get, get down
C''mon honey - we''re gonna rock it tonight')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (7, N'Don’t Try Suicide', 1, 232, 7, N'One, two, three, four, one
Yeah
Okay
Don''t do it
Don''t you try, baby
Don''t do that, don''t, don''t, don''t
Don''t do that, you got a good thing going now
Don''t do it, don''t do it
Don''t
Don''t try suicide, nobody''s worth it
Don''t try suicide, nobody cares
Don''t try suicide, you''re just gonna hate it
Don''t try suicide, nobody gives a damn
So, you think it''s the easy way out?
Think you''re gonna slash your wrists this time
Baby, when you do it all you do is get on my tits
Don''t do that, try, try, try, baby
Don''t do that, you got a good thing going now
Don''t do it, don''t do it
Don''t
Don''t try suicide, nobody''s worth it
Don''t try suicide, nobody cares
Don''t try suicide, you''re just gonna hate it
Don''t try suicide, nobody gives a damn
You need help
Look at yourself, you need help (yeah, yeah)
You need life
So don''t hang yourself, it''s okay, okay, okay, okay
You just can''t be a prick teaser all of the time
A little bit attention? You got it
Need some affection? You got it
Suicide, suicide, suicide bid
Suicide, suicide, suicide bid
Suicide, hey
Don''t do it, don''t do it, don''t do it, babe, yeah
Don''t do it, don''t do it, don''t do it
Don''t put your neck on the line
Don''t drown on me, babe
Blow your brains out
Don''t do that, yeah
Don''t do that
You got a good thing going, baby
Don''t do it, (no), don''t do it (no)
Don''t
Don''t try suicide, nobody''s worth it
Don''t try suicide, nobody cares
Don''t try suicide, you''re just gonna hate it
Don''t try suicide, nobody gives, nobody gives
Nobody gives a damn
Okay')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (8, N'Sail Away Sweet Sister', 1, 213, 8, N'Hey little babe you''re changing
Babe are you feeling sore?
It ain''t no use in pretending
You don''t wanna play no more

It''s plain that you ain''t no baby
What would your mother say?
You''re all dressed up like a lady
How come you behave this way?

Sail away sweet sister
Sail across the sea
Maybe you find somebody
To love you half as much as me
My heart is always with you
No matter what you do
Sail away sweet sister
I''ll always be in love with you

Forgive me for what I told you
My heart makes a fool of me
You know that I''ll never hold you
I know that you gotta be free

Sail away sweet sister
Sail across the sea
Maybe you find somebody
To love you half as much as me
Take it the way you want it
But when they let you down my friend
Sail away sweet sister
Back to my arms again

Hot child don''t you know, you''re young –
You got your whole life ahead of you
And you can throw it away too soon
Way too soon

Sail away sweet sister
Sail across the sea
Maybe you find somebody''s
Gonna love you half as much as me
My heart is always with you
No matter what you do
Sail away sweet sister
I''ll always be in love with you
')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (9, N'Coming Soon', 1, 171, 9, N'Ooh
Oh Oh Oh

I get some headaches when I hit the heights
Like in the morning after crazy nights
Like some mother in law in her nylon tights
They''re always
They''re always
They''re always
They''re always
Coming soon
Coming soon on the outside of the tracks

You take ''em
The same old babies with the same old toys
The neighbors screaming when the noise annoys
Somebody naggin'' you
when you''re out with the boys
They''re always
They''re always
They''re always
They''re always
Coming soon
Coming soon on the outside of the track

They''re always
They''re always
They''re always
They''re always
Coming soon
Coming soon on the outside of the track
Coming soon
Coming soon on the outside of the track
Yeah yeah yeah
')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (10, N'Save Me', 1, 230, 10, N'It started off so well
They said we made a perfect pair
I clothed myself in your glory and your love
How I loved you, how I cried
The years of care and loyalty
Were nothing but a sham, it seems
The years belie, we lived a lie
I love you ''till I die
Save me, save me, save me
I can''t face this life alone
Save me, save me, save me
I''m naked and I''m far from home
The slate will soon be clean
I''ll erase the memories
To start again with somebody new
Was it all wasted, all that love?
I hang my head and I advertise
A soul for sale or rent
I have no heart, I am cold inside
I have no real intent
Save me, save me, save me
I can''t face this life alone
Save me, save me, ooh
I''m naked and I''m far from home
Each night I cry, I still believe the lie
I love you ''till I die
Ow!
Save me, save me, save me (oh, yeah!)
Yeah, save me, (yeah), save me, ooh (oh, save me)
Don''t let me face my life alone
Save me, save me, ooh (save me)
I''m naked and I''m far from home')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (11, N'Hells Bells', 2, 309, 1, N'I''m rolling thunder, pouring rain
I''m coming on like a hurricane
My lightning''s flashing across the sky
You''re only young, but you''re gonna die
I won''t take no prisoners, won''t spare no lives
Nobody''s putting up a fight
I got my bell, I''m gonna take you to hell
I''m gonna get ya, Satan get ya
Hells bells
Hells bells, you got me ringing
Hells bells, my temperature''s high
Hells bells
I''ll give you black sensations up and down your spine
If you''re into evil, you''re a friend of mine
See the white light flashing as I split the night
Cos if good''s on the left then I''m sticking to the right
I won''t take no prisoners, won''t spare no lives
Nobody''s puttin'' up a fight
I got my bell, I''m gonna take you to hell
I''m gonna get ya, Satan get ya
Hells bells
Hells bells, you got me ringing
Hells bells, my temperature''s high
Hells bells
Hells bells, Satan''s coming to you
Hells bells, he''s ringing them now
Those hells bells, the temperature''s high
Hells bells, across the sky
Hells bells, they''re taking you down
Hells bells, they''re dragging you down
Hells bells, gonna split the night
Hells bells, there''s no way to fight
Hells bells')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (12, N'Shoot to Thrill', 2, 314, 2, N'All you women who want a man of the street
But don''t know which way you wanna turn
Just keep a-comin'', and put your hand out to me
''Cause I''m the one who''s gonna make you burn

I''m gonna take you down
Oh, down, down, down
So, don''t you fool around
I''m gonna pull it, pull it, pull the trigger

Shoot to thrill, play to kill
Too many women with too many pills, yeah
Shoot to thrill, play to kill
I got my gun at the ready, gonna fire at will, yeah

I''m like evil, I get under your skin
Just like a bomb that''s ready to blow
''Cause I''m illegal, I got everything
That all you women might need to know

I''m gonna take you down
Yeah, down, down, down
So, don''t you fool around
I''m gonna pull it, pull it, pull the trigger

Shoot to thrill, play to kill
Too many women with too many pills, said
Shoot to thrill, play to kill
I got my gun at the ready, gonna fire at will
''Cause I shoot to thrill, and I''m ready to kill
I can''t get enough and I can''t get my fill
I shoot to thrill, play to kill
Yeah

Pull the trigger, pull it
Pull it, pull it, pull the trigger!

Oh
Shoot to thrill, play to kill
Too many women with too many pills, I said
Shoot to thrill, play to kill
I got my gun at the ready, going to fire at will
''Cause I shoot to thrill and I''m ready to kill
And I can''t get enough and I can''t get my fill
''Cause I shoot to thrill, play to kill

Yeah

Shoot you down, yeah
I''m gonna get you down to the bottom, girl
Shoot you, I''m gonna shoot you
Ooh, yeah
Yeah, yeah
I''m gonna shoot you down, yeah, yeah
I''m gonna get you down
Down, down, down, down

Shoot you, shoot you, shoot you, shoot you down
Shoot you, shoot you, shoot you down
Aah, aah, aah, aah, aah, aah yeah

I''m gonna shoot to thrill
Play to kill
Shoot to thrill')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (13, N'What Do You Do for Money Honey', 2, 213, 3, N'You''re working in bars, riding in cars
Never gonna give it for free
Your apartment with a view on the finest avenue
Looking at your beat on the street
You''re always pushing, shoving, satisfied with nothing
You bitch, you must be getting old
So stop your love on the road
All your digging for gold
You make me wonder
Yes, I wonder, I wonder
Honey, what do you do for money?
Honey, what do you do for money?
Where you get your kicks?
You''re loving on the take, and you''re always on the make
Squeezing all the blood out of men
Yeah, we''re standing in a queue, just to spend the night with you
It''s business as usual again
You''re always grabbin'', stabbin'', trying to get it back in
But girl, you must be getting slow
So stop your love on the road
All your digging for gold
You make me wonder
Yes, I wonder, yes, I wonder
Honey, what do you do for money?
Honey, what do you do for money?
Yeah, what do you do for money, honey?
How do you get your kicks?
What do you do for money, honey?
How you get your licks?
Go
Yow! Honey, what do you do for money?
I said, Honey, what do you do for money?
Oh honey (honey)
Oh yeah, honey, what do you do for money?
What you gonna do?
Hey now, honey (oh yea, honey), what do you do for money?
What you gonna do?
Oww, what you gonna do?')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (14, N'Givin’ the Dog a Bone', 2, 210, 4, N'Ooh, yeah

She takes you down easy
Going down to her knees
Going down to the devil
Down, down to 90 degrees
Oh, she''s blowing me crazy ''til my ammunition is dry

Oh, she''s using her head again
She''s using her head
Oh, she''s using her head again

I''m just a-givin'' the dog a bone (givin'' the dog a bone)
Yeah, I''m givin'' the dog a bone (givin'' the dog a bone)
I''m just a-givin'' the dog a bone (givin'' the dog a bone)
I''m just a-givin'' the dog a bone (givin'' the dog a bone)
Yaw!

Oh, she''s no Mona Lisa
No, she''s no Playboy star
But she''d send you to Heaven
Then explode you to Mars

Oh, she''s using her head again (using her head again)
She''s using her head (using her head again)
Ah, she''s using her head again (using her head)

I''m just a-givin'' the dog a bone (givin'' the dog a bone)
Givin'' the dog a bone (givin'' the dog a bone)
I''m just a-givin'' the dog a bone (givin'' the dog a bone)
Why don''t you givin'' the dog a bone? (Givin'' the dog a bone)
Come on

Ow-oh-oh-oh!

She got the power of union
Yeah, she only hits when it''s hot
And if she likes what you''re doing
Yeah, she''ll give you the lot
Givin'' everything

I''m just givin'' the dog a bone (givin'' the dog a bone)
Givin'' the dog a bone (givin'' the dog a bone)
Givin'' the dog a bone (givin'' the dog a bone)
I''m just a-givin'' the dog a bone (givin'' the dog a bone)

Givin'' the dog a bone (givin'' the dog a bone)
Givin'' the dog a bone (givin'' the dog a bone)
I''m just a-givin'' the dog a bone (givin'' the dog a bone)
I''m just a givin'' a dog, givin'' a dog, givin'' a dog
Ooh, I''m just a givin'' a dog a bone
Aw, no')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (15, N'Let Me Put My Love into You', 2, 252, 5, N'Flying on a free flight
Driving all night with my machinery
''Cause I, I got the power, any hour
To show the man in me

And those reputations, blown to pieces
With my artillery
I''ll be guiding, we''ll be riding
Give a-what you got to me

Don''t you struggle
Don''t you fight
Don''t you worry
''Cause it''s your turn tonight

Let me put my love into you, babe
Let me put my love on the line
Let me put my love into you, babe
Let me cut your cake with my knife, oh

Oh, like a fever, burnin'' faster
You spark the fire in me
Crazy feelings got me reeling
They got me raisin'' steam

Now, don''t you struggle
Don''t you fight
Don''t you worry
''Cause it''s your turn tonight, yeah

Let me put my love into you, babe
Let me put my love on the line
Let me put my love into you, babe
Let me cut your cake with my knife, oh
Cut it

Let me
Let me
Ow!

Let me put my love into you, babe
Let me put my love on the line
Let me put my love into you, babe
Let me cut your cake with my knife

Oh, let me put my love into you, babe
Let me put my love on the line
Let me put my love into you, babe
Let me give it all
Let me give it all to you
To you

Give it all!')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (16, N'Black In Black', 2, 253, 6, N'Back in black!
I hit the sack.
I''ve been too long, I''m glad to be back.
I bet you know I''m...
Yes, I''m let loose
From the noose -
That''s kept me hanging about
I''ve been looking at the sky,
''Cause it''s gettin'' me high.
Forget the hearse ''cause I never die -
I got nine lives.
Cat''s eyes!
Abusin'' every one of them and running wild.

''Cause I''m back
Yes, I''m back
Yes, I''m back in black

Back in the back
Of a Cadillac.
Number one with a bullet, I''m a power pack.
Yes, I''m in a bang
With a gang.
They''ve got to catch me if they want me to hang,
Cause I''m back on the track.
And I''m beatin'' the flack,
Nobody''s gonna get me on another rap.
So look at me now,
I''m just makin'' my play.
Don''t try to push your luck, just get out of my way.

''Cause I''m back
Yes, I''m back
Yes, I''m back in black
')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (17, N'You Shook Me All Night Long', 2, 238, 7, N'She was a fast machine, she kept her motor clean
She was the best damn woman that I ever seen
She had the sightless eyes, telling me no lies
Knocking me out with those American thighs
Taking more than her share, had me fighting for air
She told me to come, but I was already there
''Cause the walls start shaking, the Earth was quaking
My mind was aching and we were making it
And you shook me all night long
Yeah, you shook me all night long
Working double time on the seduction line
She''s one of a kind, she''s just mine, all mine
Wanted no applause, it''s just another course
Made a meal outta me, and come back for more
Had to cool me down to take another round
Now I''m back in the ring to take another swing
That the walls were shaking, the Earth was quaking
My mind was aching and we were making it
And you shook me all night long
Yeah, you shook me all night long
And knocked me out, I said you shook me all night long
You had me shaking and you shook me all night long
Yeah, you shook me
Well, you took me
You really took me and you shook me all night long
Ooh, you shook me all night long
Yeah, yeah, you shook me all night long
You really got me and you shook me all night long
Yeah, you shook me
Yeah, you shook me all night long')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (18, N'Have a Drink on Me', 2, 237, 8, N'Whiskey, gin and brandy
With a glass, I''m pretty handy
I''m tryin'' to walk a straight line
On sour mash and cheap wine

So, join me for a drink, boys
We''re gonna make a big noise
So, don''t worry about tomorrow
Take it today
Forget about the check, we''ll get hell to pay

Have a drink on me
Yeah, have a drink on me
Yeah, have a drink on me
Have a drink on me

I''m dizzy, drunk and fighting
On tequila, white lightnin''
Yes, my glass is gettin'' shorter
On whiskey, ice and water

Yeah, so come on, have a good time
And get blinded out of your mind
So, don''t worry about tomorrow
Take it today
Forget about the check, we''ll get hell to pay

Have a drink on me
Yeah, have a drink on me
Yeah, have a drink on me
Have a drink on me tonight
Get stoned

Have a drink on me
Have a drink on me
Have a drink on me
Come on

Going another round
Gonna hit the ground
Take another swig
Have another drink
Gonna drink you dry
Gonna get me high
Come on, all the boys make a noise

Have a drink on me (Have a drink on me)
Have a drink on me (Have a drink on me)
Ah, have a drink on me (Have a drink on me)
Have a drink on me
Have a drink on me
Have a drink
On me
')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (19, N'Shake a Leg', 2, 243, 9, N'Idle juvenile on the street on the street
Kickin'' everything with his feet with his feet
Fightin'' on the wrong side of the law of the law
Don''t kick don''t fight don''t sleep at night
And shake a leg
Shake a leg
Shake a leg
Shake it again

Keepin'' outta trouble with eyes in the back of my face
Kickin'' ass in the class and they tell me I''m a damn disgrace
They tell me what they think but they stink
and I really don''t care
Got a mind of my own move on get outta my hair
Shake a leg shake your head
Shake a leg wake the dead
Shake a leg get stuck in
Shake a leg shake a leg

Mob scenes, wet dreams, dirty women
on machines for me
Big licks skin flicks tricky dicks are my chemistry
Goin'' against the grain
tryin'' to keep me sane with you
So stop your grinnin'' and drop your linen
for me
Shake a leg shake your head
Shake a leg wake the dead
Shake a leg get stuck in
Shake a leg shake a leg
Shake it

Idle juvenile on the street on the street
Kickin'' everything with his feet with his feet
Fightin'' on the wrong side of the law of the law
Spittin'' and bitin'' and kickin'' and fightin'' for more
Shake a leg shake your head
Shake a leg wake the dead
Shake a leg get stuck in
Shake a leg play to win
Shake a leg shake your head
Shake a leg wake the dead
Shake a leg get stuck in
Shake a leg
Shake a leg

Shake it
')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (20, N'Rock and Roll Ain’t Noise Pollution', 2, 252, 10, N'Alright
Hey there, all you middlemen
Throw away your fancy clothes
And while you''re out there sittin'' on a fence
So get off your ass and come down here
''Cause rock and roll ain''t no riddle, man
To me, it makes good, good sense
Good sense, just go
Aw!
Ooh, yeah
Heavy decibels are playing on my guitar
We got vibrations coming up from the floor
We''re just listening to the rock that''s giving too much noise
Are you deaf, you wanna hear some more?
We''re just talkin'' about the future
Forget about the past
It''ll always be with us
It''s never gonna die, never gonna die
Rock and roll ain''t noise pollution
Rock and roll ain''t gonna die
Rock and roll ain''t noise pollution
Rock and roll, it will survive
Yes, it will, ha-ha
I took a look inside your bedroom door
You looked so good lying on your bed
Well, I asked you if you wanted any rhythm and love
You said you wanna rock and roll instead
We''re just talkin'' about the future
Forget about the past
It''ll always be with us
It''s never gonna die, never gonna die
Rock and roll ain''t noise pollution
Rock and roll ain''t gonna die
Rock and roll ain''t no pollution
Rock and roll, it''s just rock and roll
Ah, rock and roll ain''t noise pollution
Rock and roll ain''t gonna die
Rock and roll ain''t no pollution
Rock and roll, it will survive
Rock and roll ain''t no pollution
Rock and roll, it''ll never die
Rock and roll ain''t no pollution
Rock and roll
Oh, rock and roll
Is just rock and roll, yeah')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (21, N'Die For You - Remix', 3, 232, 1, N'1')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (22, N'Cold Heart (PHAU Remix)', 4, 202, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (23, N'Blood', 5, 118, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (24, N'DNA', 5, 185, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (25, N'Yah', 5, 160, 3, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (26, N'Element', 5, 208, 4, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (27, N'Feel', 5, 214, 5, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (28, N'Loyalty', 5, 227, 6, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (29, N'Pride', 5, 275, 7, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (30, N'Humble', 5, 177, 8, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (31, N'Lust', 5, 307, 9, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (32, N'Love', 5, 223, 10, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (33, N'Fear', 5, 460, 11, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (34, N'God', 5, 248, 12, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (35, N'Godzilla', 7, 210, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (36, N'Lucky You', 7, 244, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (37, N'Lighters', 7, 303, 3, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (38, N'Gnat', 7, 224, 4, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (39, N'Cinderella Man', 7, 279, 5, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (40, N'Walk on Water', 7, 304, 6, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (41, N'Rap God', 7, 353, 7, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (42, N'Love the Way You Lie', 7, 263, 8, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (43, N'Won''t Back Down', 7, 265, 9, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (44, N'Higher', 7, 282, 10, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (45, N'Fire + Water', 6, 497, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (46, N'This Is What I Mean', 6, 324, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (47, N'Firebabe', 6, 230, 3, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (48, N'Please', 6, 173, 4, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (49, N'Need You', 6, 196, 5, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (50, N'hide & Seek', 6, 208, 6, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (51, N'My Presidents Are Black', 6, 262, 7, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (52, N'Sampha''s Plea', 6, 165, 8, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (53, N'Holy Spirit', 6, 282, 9, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (54, N'Bad Blood', 6, 243, 10, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (55, N'I Got My Smile Back', 9, 251, 11, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (56, N'Give It to the Water', 9, 252, 12, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (57, N'Евгений Онегин', 8, 634, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (58, N'Пиковая дама', 8, 565, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (59, N'Весна', 10, 572, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (60, N'Лето', 10, 618, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (61, N'Осень', 10, 693, 3, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (62, N'Зима', 10, 644, 4, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (63, N'Get Lucky', 11, 363, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (64, N'Eve of Destruction', 12, 280, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (65, N'Bango', 12, 247, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (66, N'No Geography', 12, 190, 3, N'If you ever change your mind about leaving it all behind
Remember, remember, no geography
If you ever change your mind about leaving it all behind
Remember, remember, no geography
Me, you and me
Him and her, and them too
And you, and me too
I''ll take you along, I''ll take you along with me
I''ll take you along with me
I''ll take you along with me
If you ever change your mind about leaving it all behind
Remember, remember, no geography
Me, you and me
Him and her, and them too
And you, and me too
I''ll take you along, I''ll take you along with me
I''ll take you along with me
I''ll take you along with me')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (67, N'Got to Keep On', 12, 316, 4, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (68, N'Gravity Drops', 12, 270, 5, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (69, N'God’s Gonna Cut You Down', 13, 180, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (70, N'Giddy Up!', 14, 162, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (71, N'Brand New', 14, 153, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (72, N'Waking Up Dreaming', 14, 198, 3, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (73, N'Best Friend', 14, 159, 4, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (74, N'Pretty Liar', 14, 159, 5, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (75, N'Inhale/Exhale Air', 14, 189, 6, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (76, N'What A Wonderful World', 15, 377, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (77, N'Out On The Road', 16, 154, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (78, N'You''re Still My Woman', 17, 364, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (79, N'Nobody Loves Me But My Mother', 17, 86, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (80, N'Ask Me No Questions', 17, 188, 3, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (81, N'Until I''m Dead and Cold', 17, 285, 4, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (82, N'Black Snake', 18, 213, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (83, N'How Long Blues', 18, 134, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (84, N'Wobblin'' Baby', 18, 171, 3, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (85, N'She''s Long, She''s Tall, She Weeps Like a Willow', 18, 187, 4, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (86, N'Pea Vine Special', 18, 190, 5, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (87, N'Fight Fire with Fire', 19, 285, 1, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (88, N'Ride the Lightning', 19, 367, 2, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (89, N'For Whom the Bell Tolls', 19, 309, 3, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (90, N'Fade to Black', 19, 359, 4, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (91, N'Trapped Under Ice', 19, 248, 5, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (92, N'Escape', 19, 264, 6, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (93, N'Creeping Death', 19, 374, 7, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (94, N'The Call of Ktulu', 19, 535, 8, N'')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (95, N'Different World', 20, 258, 1, N'You lead me on the path, keep showing me the way I feel a little lost, a little strange today I think I’ll take a hold of whatever comes my way Then we’ll see what happens, take it day by day I though I had it all, I had it all worked out Just what my future held that there would be no doubt But then the card came up and I took another turn But I don’t know if it’s fulfillment that I yearn Tell me what you can hear and then tell me what you see Everybody has a different way to view the world I would like you to know, when you see the simple things To appreciate this life it’s not too late to learn Don’t want to be here — somewhere I’d rather be But when I get there, I might find it’s not for me Tell me what you can hear and then tell me what you see Everybody has a different way to view the world I would like you to know, when you see the simple things To appreciate this life it’s not too late to learn Tell me what you can hear and then tell me what you see Everybody has a different way to view the world I would like you to know, when you see the simple things To appreciate this life it’s not too late to learn Don’t want to be here — somewhere I’d rather be But when I get there, I might find it’s not for me Don’t know what I want or where I want to be I’m feeling more confused the more the days go by')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (96, N'These Colours Don''t Run', 20, 351, 2, N'It''s the same in every country when you say you''re leaving
Left behind the loved ones waiting silent in the hall
Where you''re going, lies adventure others only dream of
Red and green light, this is real, and so you go to war
For the passion, for the glory
For the memories, for the money
You''re a soldier for your country
What''s the difference? All the same
Far away from the land of our birth
We fly a flag in some foreign earth
We sailed away like our fathers before
These colours don''t run from cold, bloody war
There is no one that will save you, going down in flames
No surrender, certain death, you look it in the eye
On the shores of tyranny, you crashed a human wave
Paying for my freedom with your lonely unmarked graves
For the passion, for the glory
For the memories, for the money
You''re a soldier for your country
What''s the difference? All the same
Far away from the land of our birth
We fly a flag in some foreign earth
We sailed away like our fathers before
These colours don''t run from cold, bloody war
Far away from the land of our birth
We fly a flag in some foreign earth
We sailed away like our fathers before
These colours don''t run from cold, bloody war
Far away from the land of our birth
We fly a flag in some foreign earth
We sailed away like our fathers before
These colours don''t run from cold, bloody war
These colours don''t run from cold, bloody war')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (97, N'Brighter Than a Thousand Suns', 20, 734, 3, N'We are not the sons of god
We are not his chosen people now
We have crossed the path he trod
We will feel the pain of his beginning

Shadow fingers rise above
Iron fingers stab the desert sky
Oh Behold the power of man
On its tower ready for the fall

Knocking heads together well
Rise a city build a living hell
Join the race to suicide
Listen for the tolling of the bell

Out of the universe a strange love is born
Unholy union trinity reformed

Yellow sun it''s evil twin
In the black the wings deliver him
We will split our souls within
Atom seed to nuclear dust is riven

Out of the universe a strange love is born
Unholy union, trinity reformed

Out of the darkness
Brighter than a thousand suns
Out of the darkness
Brighter than a thousand suns
Out of the darkness
Brighter than a thousand suns
Out of the darkness
Brighter than a thousand suns

Bury your morals and bury your dead
Bury your head in the sand
E=mc squared you can relate
how we made God
With our hands

Whatever would Robert have said to his god
About how we made war with the sun
E=mc squared you can relate
how we made god
With our hands

All the nations are rising
Through acid veils of love and hate
Chain letters of Satan
Uncertainty leads us all to this
All the nations are rising
Through acid veils of love and hate
Cold fusion and fury

Divide and conquer while ye may
Others preach and others fall and pray
In the bunkers where we''ll die
Where the executioners they lie

Bombers launch with no recall
Minutes warning of the missile fall
Take a look at your last sky
Guessing you won''t have the time to cry

Out of the universe a strange love is born
Unholy union, trinity reformed

Out of the darkness
Out of the darkness
Out of the darkness
Brighter than a thousand suns
Out of the darkness
Brighter than a thousand suns
Out of the darkness
Brighter than a thousand suns
Out of the darkness
Brighter than a thousand suns

Holy Father we have sinned')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (98, N'The Pilgrim', 20, 306, 4, N'The keys to death and hell
The ailing kingdom doomed to fall
The bonds of sin and heart will break
The pilgrims course will take

Quelling the devils might
And ready for eternal fight
Aching limbs and fainting soul
Holy battles take their toll

Liberty and hope divine
Changing water into wine
So to you we bid farewell
Kingdom of heaven to hell

Spirit holy, life eternal
Raise me up take me home
Pilgrim sunrise, pagan sunset
Onward journey begun

To courage find and gracious will
Deliver good from ill
Clean the water clean our guilt
With us do what you will

Then will my judge appear
Bear no false angel that I hear
For only then I will confess
To my eternal hell

Now give us our holy sign
Changing water into wine
So to you we bid farewell
Kingdom of heaven to hell

Spirit holy life eternal
Raise me up take me home
Pilgrim sunrise pagan sunset
Onward journey begun')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (99, N'Longest Day', 20, 467, 5, N'I was walking home alone late the other night
I couldn''t see a single star in the sky
Oh, they must be too high
Shadows dance around me in the dark
Don''t stop

This could be the longest day
And the night has yet to come
This must be the door to take
There''s nowhere left to run

This could be the longest day
And the night has yet to come
This must be the door to take
I''ve nowhere left to run

Was eleven years to change what had been lost
One single shot was fired at what a cost
Oh, at what a cost

This could be the longest day
And the night has yet to come
This must be the door to take
There''s nowhere left to run

This could be the longest day
And the night has yet to come
This must be the door to take
I''ve nowhere left to run

I wanna run
I better run now
Run
As far as I can
')
INSERT [dbo].[Tracks] ([Id], [Name], [AlbumId], [Length], [TrackNumber], [Lyrics]) VALUES (100, N'Out of the Shadows', 20, 335, 6, N'Hold a halo round the world
Golden is the day
Princess of the Universe
Your burden is the way
So there is no better time
Who will be born today
A gypsy child at day break
A king for a day

Out of the shadows and into the sun
Dreams of the past as the old ways are done
Oh there is beauty and surely there is pain
But we must endure it to live again

Dusty dreams in fading daylight
Flicker on the walls
Nothing new your life''s adrift
What purpose to it all?
Eyes are closed and death is calling
Reaching out its hand
Call upon the starlight to surround you

Out of the shadows and into the sun
Dreams of the past as the old ways are done
Oh there is beauty and surely there is pain
But we must endure it to live again

A man who casts no shadow has no soul')
GO
INSERT [dbo].[Users] ([UserId], [UserName], [Password], [RoleId], [FullName]) VALUES (1, N'User', N'123', 1, N'Дмитрий Попов Михайлович')
INSERT [dbo].[Users] ([UserId], [UserName], [Password], [RoleId], [FullName]) VALUES (2, N'Manager', N'1234', 2, N'Пётр Кузнецов Александрович')
INSERT [dbo].[Users] ([UserId], [UserName], [Password], [RoleId], [FullName]) VALUES (3, N'Admin', N'12345', 3, N'Михаил Иванов Андреевич')
GO
ALTER TABLE [dbo].[Albums]  WITH CHECK ADD  CONSTRAINT [FK_Albums_Artists] FOREIGN KEY([ArtistId])
REFERENCES [dbo].[Artists] ([Id])
GO
ALTER TABLE [dbo].[Albums] CHECK CONSTRAINT [FK_Albums_Artists]
GO
ALTER TABLE [dbo].[PlaylistTracks]  WITH CHECK ADD  CONSTRAINT [FK_PlaylistTracks_Playlists] FOREIGN KEY([PlaylistId])
REFERENCES [dbo].[Playlists] ([Id])
GO
ALTER TABLE [dbo].[PlaylistTracks] CHECK CONSTRAINT [FK_PlaylistTracks_Playlists]
GO
ALTER TABLE [dbo].[PlaylistTracks]  WITH CHECK ADD  CONSTRAINT [FK_PlaylistTracks_Tracks] FOREIGN KEY([TrackId])
REFERENCES [dbo].[Tracks] ([Id])
GO
ALTER TABLE [dbo].[PlaylistTracks] CHECK CONSTRAINT [FK_PlaylistTracks_Tracks]
GO
ALTER TABLE [dbo].[TrackGenres]  WITH CHECK ADD  CONSTRAINT [FK_TrackGenres_Genres] FOREIGN KEY([GenreId])
REFERENCES [dbo].[Genres] ([Id])
GO
ALTER TABLE [dbo].[TrackGenres] CHECK CONSTRAINT [FK_TrackGenres_Genres]
GO
ALTER TABLE [dbo].[TrackGenres]  WITH CHECK ADD  CONSTRAINT [FK_TrackGenres_Tracks] FOREIGN KEY([TrackId])
REFERENCES [dbo].[Tracks] ([Id])
GO
ALTER TABLE [dbo].[TrackGenres] CHECK CONSTRAINT [FK_TrackGenres_Tracks]
GO
ALTER TABLE [dbo].[Tracks]  WITH CHECK ADD  CONSTRAINT [FK_Tracks_Albums] FOREIGN KEY([AlbumId])
REFERENCES [dbo].[Albums] ([Id])
GO
ALTER TABLE [dbo].[Tracks] CHECK CONSTRAINT [FK_Tracks_Albums]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK__Users__RoleId__06CD04F7] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([RoleId])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK__Users__RoleId__06CD04F7]
GO
/****** Object:  StoredProcedure [dbo].[AddArtist]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddArtist]
    @ArtistId INT,
    @ArtistName NVARCHAR(50),
    @Country NVARCHAR(50),
    @Description NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Добавляем нового артиста
    INSERT INTO Artists (Id, Name, Country, Description)
    VALUES (@ArtistId, @ArtistName, @Country, @Description)
END
GO
/****** Object:  StoredProcedure [dbo].[AddGenre]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddGenre]
    @Id INT,
    @GenreName NVARCHAR(50),
    @Description NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Добавляем новый жанр с указанным Id
    INSERT INTO Genres (Id, Name, Description)
    VALUES (@Id, @GenreName, @Description)
END
GO
/****** Object:  StoredProcedure [dbo].[AddPlaylist]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPlaylist]
    @PlaylistId INT,
    @PlaylistName NVARCHAR(50),
    @Description NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Добавляем новый плейлист
    INSERT INTO Playlists (Id, Name, Description)
    VALUES (@PlaylistId, @PlaylistName, @Description)
END
GO
/****** Object:  StoredProcedure [dbo].[AddTrack]    Script Date: 24.05.2023 2:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddTrack]
    @Id INT,
    @TrackName NVARCHAR(50),
    @AlbumId INT,
    @Length INT,
    @TrackNumber INT,
    @Lyrics NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Добавляем новый трек с указанным идентификатором
    INSERT INTO Tracks (Id, Name, AlbumId, Length, TrackNumber, Lyrics)
    VALUES (@Id, @TrackName, @AlbumId, @Length, @TrackNumber, @Lyrics)
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[27] 4[22] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Alb"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 136
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "FT"
            Begin Extent = 
               Top = 6
               Left = 462
               Bottom = 102
               Right = 646
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "T"
            Begin Extent = 
               Top = 6
               Left = 684
               Bottom = 136
               Right = 858
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TG"
            Begin Extent = 
               Top = 6
               Left = 896
               Bottom = 102
               Right = 1070
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "G"
            Begin Extent = 
               Top = 6
               Left = 1108
               Bottom = 119
               Right = 1282
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 2850
         Width = 2430
         Width = 2400
         Width = 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AlbumList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AlbumList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AlbumList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pt"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 102
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 462
               Bottom = 201
               Right = 636
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 555
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PlaylistView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'PlaylistView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[3] 2[8] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "T"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "A"
            Begin Extent = 
               Top = 91
               Left = 493
               Bottom = 221
               Right = 667
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Alb"
            Begin Extent = 
               Top = 141
               Left = 260
               Bottom = 271
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 2700
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'TrackList'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'TrackList'
GO
USE [master]
GO
ALTER DATABASE [MusicDB] SET  READ_WRITE 
GO
