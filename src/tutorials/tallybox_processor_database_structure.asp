<!--#INCLUDE virtual="/inc_header.asp"-->

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TallyBox Tutorial - Database Structure</title>
    <meta name="description" content="A step-by-step tutorial on the TallyBox SQL Server database structure, including table definitions, relationships, and usage in transaction processing and archiving. Includes a downloadable SQL script with copy-to-clipboard functionality.">
    <meta name="author" content="shahiN Noursalehi">

    <!--#INCLUDE virtual="/inc_styles.asp"-->

</head>
<body class="dark-mode">
    <header>
        <h1>TallyBox Tutorial - Database Structure</h1>
        <p>by shahiN Noursalehi</p>
        <label>
            <input type="checkbox" id="darkModeToggle" checked onchange="toggleDarkMode()" aria-label="Toggle dark mode"> Dark Mode
        </label>
    </header>

    <!-- Navigation Bar -->
    <section class="content-box">
        You are here: 
        <a href="/">Home</a> /
        Tutorials /
        <a href="tallybox_processor_database_structure.asp">TallyBox Payment Processor - Database Structure</a>
    </section>

    <br>

    <!-- AI-Friendly Notice -->
    <section class="yellow-box">
        <p><strong>Note:</strong> This tutorial is structured to be <strong>AI-Friendly</strong>. An AI can generate code or database schemas in any programming language or database system based on the content of this URL, thanks to its clear explanations, schema details, and examples.</p>
    </section>

    <!-- Main Content -->
    <main>
        <!-- Introduction -->
        <section class="content-box">
            <h2>TallyBox Database Structure</h2>
            <p>This tutorial guides developers through the SQL Server database structure for the TallyBox Windows desktop application. The `net_mixoftix_tallybox` database supports transaction processing, wallet management, and archiving for a decentralized ledger system. This tutorial explains the database setup, table purposes, relationships, and provides a downloadable SQL script with copy-to-clipboard functionality.</p>
        </section>

        <!-- Step 1: Database Setup -->
        <section class="content-box">
            <h3>Step 1: Database Setup</h3>
            <p>The `net_mixoftix_tallybox` database is created with specific configurations for performance and reliability. The setup involves:
                <ul>
                    <li>Create the database with a primary data file (10MB initial size, unlimited growth) and a log file (8MB initial size, 2TB max).</li>
                    <li>Set compatibility level to 160 (SQL Server 2022) for modern features.</li>
                    <li>Enable Query Store for query performance tracking and set recovery model to FULL.</li>
                    <li>Configure settings like `AUTO_UPDATE_STATISTICS`, `PAGE_VERIFY CHECKSUM`, and disable features like `ANSI_NULLS` and `ANSI_PADDING`.</li>
                </ul>
                This step ensures the database is optimized for transaction processing.
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Database Creation</strong><br><br>
                <pre>
CREATE DATABASE net_mixoftix_tallybox
    PRIMARY_FILE = 'C:\shahin_root\dbs\net_mixoftix_tallybox.mdf', SIZE = 10304KB, MAXSIZE = UNLIMITED
    LOG_FILE = 'C:\shahin_root\dbs\net_mixoftix_tallybox_log.ldf', SIZE = 8192KB, MAXSIZE = 2048GB
    COMPATIBILITY_LEVEL = 160
    QUERY_STORE = ON (STALE_QUERY_THRESHOLD_DAYS = 30, MAX_STORAGE_SIZE_MB = 1000)
    RECOVERY = FULL
    PAGE_VERIFY = CHECKSUM
    DISABLE ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS
END
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Setup:</strong><br><br>
                Database Name: net_mixoftix_tallybox<br>
                Data File: C:\shahin_root\dbs\net_mixoftix_tallybox.mdf (10MB)<br>
                Log File: C:\shahin_root\dbs\net_mixoftix_tallybox_log.ldf (8MB)<br>
                Query Store: Enabled<br>
                Recovery Model: FULL</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/t-sql/statements/create-database-transact-sql">CREATE DATABASE (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/SQL_Server">SQL Server (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 2: Download SQL Script -->
        <section class="content-box">
            <h3>Step 2: Download SQL Script</h3>
            <p>Below is the complete SQL script for creating the `net_mixoftix_tallybox` database and its tables. You can copy it to your clipboard.</p>
            <div class="green-box">
                <textarea class="textarea-green" readonly>
				
USE [master]
GO
/****** Object:  Database [net_mixoftix_tallybox]    Script Date: 8/2/2025 6:51:36 AM ******/
CREATE DATABASE [net_mixoftix_tallybox]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'net_mixoftix_tallybox', FILENAME = N'C:\shahin_root\dbs\net_mixoftix_tallybox.mdf' , SIZE = 10304KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'net_mixoftix_tallybox_log', FILENAME = N'C:\shahin_root\dbs\net_mixoftix_tallybox_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [net_mixoftix_tallybox] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [net_mixoftix_tallybox].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [net_mixoftix_tallybox] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET ARITHABORT OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET  DISABLE_BROKER 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET RECOVERY FULL 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET  MULTI_USER 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [net_mixoftix_tallybox] SET DB_CHAINING OFF 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [net_mixoftix_tallybox] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'net_mixoftix_tallybox', N'ON'
GO
ALTER DATABASE [net_mixoftix_tallybox] SET QUERY_STORE = ON
GO
ALTER DATABASE [net_mixoftix_tallybox] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [net_mixoftix_tallybox]
GO
/****** Object:  Table [dbo].[tbl_optimize_row_counts]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_optimize_row_counts](
    [table_name] [varchar](30) NOT NULL,
    [row_count] [bigint] NOT NULL,
    [last_updated] [datetime] NOT NULL,
 CONSTRAINT [PK_tbl_row_counts] PRIMARY KEY CLUSTERED 
(
    [table_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_0]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_0](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_0] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_1]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_1](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_1] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_2]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_2](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_2] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_3]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_3](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_3] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_4]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_4](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_4] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_5]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_5](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_5] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_6]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_6](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_6] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_7]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_7](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_7] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_8]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_8](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_8] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_dispatcher_9]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_dispatcher_9](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_dispatcher_9] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_ods]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_ods](
    [graph_from] [varchar](50) NULL,
    [graph_to] [varchar](50) NULL,
    [wallet_from] [varchar](64) NOT NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_currency] [varchar](10) NULL,
    [order_amount] [decimal](18, 8) NOT NULL,
    [order_utc_unix] [bigint] NOT NULL,
    [order_id] [varchar](20) NULL,
    [public_key] [varchar](50) NULL,
    [the_sign] [varchar](100) NOT NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_order_ods] PRIMARY KEY CLUSTERED 
(
    [the_sign] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_order_ods_multiple]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_order_ods_multiple](
    [the_sign_md5] [varchar](32) NULL,
    [row_id] [int] NULL,
    [wallet_to] [varchar](64) NOT NULL,
    [order_amount] [decimal](18, 8) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_system_config]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_system_config](
    [config_key] [varchar](50) NOT NULL,
    [config_value] [varchar](255) NOT NULL,
    [config_type] [varchar](20) NOT NULL,
    [description] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
    [config_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_system_currency]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_system_currency](
    [currency_id] [int] NULL,
    [currency_name] [varchar](10) NOT NULL,
    [currency_title] [varchar](50) NULL,
    [currency_image] [varchar](15) NULL,
 CONSTRAINT [PK_tbl_system_currency] PRIMARY KEY CLUSTERED 
(
    [currency_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_system_gazette]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_system_gazette](
    [gazette_id] [varchar](20) NULL,
    [actual_currency] [varchar](10) NULL,
    [actual_amount] [decimal](18, 8) NULL,
    [actual_wallet] [varchar](64) NULL,
    [blockchain_entity] [varchar](20) NULL,
    [blockchain_wallet] [varchar](64) NULL,
    [blockchain_hash] [varchar](64) NULL,
    [local_utc_unix] [bigint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_system_graph]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_system_graph](
    [graph_domain] [varchar](50) NOT NULL,
    [graph_id] [int] NULL,
    [graph_title] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_system_graph] PRIMARY KEY CLUSTERED 
(
    [graph_domain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_system_peers]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_system_peers](
    [ip] [varchar](45) NOT NULL,
    [port] [int] NOT NULL,
    [last_time] [decimal](18, 7) NOT NULL,
    [last_attempt] [bigint] NULL,
    [peer_rule] [tinyint] NULL,
    [status] [tinyint] NULL,
 CONSTRAINT [PK_tbl_system_peers] PRIMARY KEY CLUSTERED 
(
    [ip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_system_treasury]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_system_treasury](
    [treasury_id] [varchar](20) NOT NULL,
    [authorized_currency] [varchar](10) NULL,
    [authorized_amount] [decimal](18, 8) NULL,
    [authorized_wallet] [varchar](64) NULL,
    [blockchain_entity] [varchar](20) NULL,
    [blockchain_wallet] [varchar](64) NULL,
    [blockchain_hash] [varchar](64) NULL,
    [local_utc_unix] [bigint] NULL,
 CONSTRAINT [PK_tbl_system_treasury] PRIMARY KEY CLUSTERED 
(
    [treasury_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_book]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_book](
    [tnx_id_dag] [decimal](18, 7) NULL,
    [tnx_id] [decimal](18, 7) NULL,
    [tnx_type] [tinyint] NULL,
    [graph_id] [int] NULL,
    [wallet_id] [bigint] NULL,
    [currency_id] [int] NULL,
    [currency_amount] [decimal](18, 8) NULL,
    [left_amount] [decimal](18, 8) NULL,
    [tally_hash_dag] [varchar](64) NULL,
    [tally_hash] [varchar](64) NOT NULL,
 CONSTRAINT [PK_tbl_tallybox_book] PRIMARY KEY CLUSTERED 
(
    [tally_hash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_book_archive_1]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_book_archive_1](
    [tnx_id_dag] [decimal](18, 7) NULL,
    [tnx_id] [decimal](18, 7) NULL,
    [tnx_type] [tinyint] NULL,
    [graph_id] [int] NULL,
    [wallet_id] [bigint] NULL,
    [currency_id] [int] NULL,
    [currency_amount] [decimal](18, 8) NULL,
    [left_amount] [decimal](18, 8) NULL,
    [tally_hash_dag] [varchar](64) NULL,
    [tally_hash] [varchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_book_archive_2]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_book_archive_2](
    [tnx_id_dag] [decimal](18, 7) NULL,
    [tnx_id] [decimal](18, 7) NULL,
    [tnx_type] [tinyint] NULL,
    [graph_id] [int] NULL,
    [wallet_id] [bigint] NULL,
    [currency_id] [int] NULL,
    [currency_amount] [decimal](18, 8) NULL,
    [left_amount] [decimal](18, 8) NULL,
    [tally_hash_dag] [varchar](64) NULL,
    [tally_hash] [varchar](64) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_book_buffer]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_book_buffer](
    [tnx_id_dag] [decimal](18, 7) NULL,
    [tnx_id] [decimal](18, 7) NULL,
    [tnx_type] [tinyint] NULL,
    [graph_id] [int] NULL,
    [wallet_id] [bigint] NULL,
    [currency_id] [int] NULL,
    [currency_amount] [decimal](18, 8) NULL,
    [left_amount] [decimal](18, 8) NULL,
    [tally_hash_dag] [varchar](64) NULL,
    [tally_hash] [varchar](64) NOT NULL,
    [archive_id] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_sign]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_sign](
    [tree_id] [bigint] NULL,
    [branch_id] [int] NULL,
    [tnx_id] [decimal](18, 7) NOT NULL,
    [order_id] [varchar](20) NULL,
    [utc_unix_order] [bigint] NULL,
    [the_sign] [varchar](100) NULL,
    [the_sign_md5] [varchar](32) NULL,
    [the_tnx_md5] [varchar](32) NULL,
 CONSTRAINT [PK_tbl_tallybox_sign] PRIMARY KEY CLUSTERED 
(
    [tnx_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_sign_archive_1]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_sign_archive_1](
    [tree_id] [bigint] NULL,
    [branch_id] [int] NULL,
    [tnx_id] [decimal](18, 7) NOT NULL,
    [order_id] [varchar](20) NULL,
    [utc_unix_order] [bigint] NULL,
    [the_sign] [varchar](100) NULL,
    [the_sign_md5] [varchar](32) NULL,
    [the_tnx_md5] [varchar](32) NULL,
 CONSTRAINT [PK_tbl_tallybox_sign_archive_1] PRIMARY KEY CLUSTERED 
(
    [tnx_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_sign_archive_2]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_sign_archive_2](
    [tree_id] [bigint] NULL,
    [branch_id] [int] NULL,
    [tnx_id] [decimal](18, 7) NOT NULL,
    [order_id] [varchar](20) NULL,
    [utc_unix_order] [bigint] NULL,
    [the_sign] [varchar](100) NULL,
    [the_sign_md5] [varchar](32) NULL,
    [the_tnx_md5] [varchar](32) NULL,
 CONSTRAINT [PK_tbl_tallybox_sign_archive_2] PRIMARY KEY CLUSTERED 
(
    [tnx_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_sign_buffer]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_sign_buffer](
    [tree_id] [bigint] NULL,
    [branch_id] [int] NULL,
    [tnx_id] [decimal](18, 7) NOT NULL,
    [order_id] [varchar](20) NULL,
    [utc_unix_order] [bigint] NULL,
    [the_sign] [varchar](100) NULL,
    [the_sign_md5] [varchar](32) NULL,
    [the_tnx_md5] [varchar](32) NULL,
    [archive_id] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_wallet]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_wallet](
    [the_wallet] [varchar](64) NOT NULL,
    [wallet_id] [bigint] NOT NULL,
 CONSTRAINT [PK_tbl_tallybox_wallet] PRIMARY KEY CLUSTERED 
(
    [the_wallet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_wallet_archive_1]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_wallet_archive_1](
    [the_wallet] [varchar](64) NOT NULL,
    [wallet_id] [bigint] NOT NULL,
 CONSTRAINT [PK_tbl_tallybox_wallet_archive_1] PRIMARY KEY CLUSTERED 
(
    [the_wallet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_wallet_archive_2]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_wallet_archive_2](
    [the_wallet] [varchar](64) NOT NULL,
    [wallet_id] [bigint] NOT NULL,
 CONSTRAINT [PK_tbl_tallybox_wallet_archive_2] PRIMARY KEY CLUSTERED 
(
    [the_wallet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_wallet_buffer]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_wallet_buffer](
    [the_wallet] [varchar](64) NOT NULL,
    [wallet_id] [bigint] NOT NULL,
    [archive_id] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_wallet_pubkey]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_wallet_pubkey](
    [public_key] [varchar](50) NULL,
    [wallet_id] [bigint] NOT NULL,
 CONSTRAINT [PK_tbl_tallybox_wallet_pubkey] PRIMARY KEY CLUSTERED 
(
    [wallet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_wallet_pubkey_archive_1]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_wallet_pubkey_archive_1](
    [public_key] [varchar](50) NULL,
    [wallet_id] [bigint] NOT NULL,
 CONSTRAINT [PK_tbl_tallybox_wallet_pubkey_archive_1] PRIMARY KEY CLUSTERED 
(
    [wallet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_wallet_pubkey_archive_2]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_wallet_pubkey_archive_2](
    [public_key] [varchar](50) NULL,
    [wallet_id] [bigint] NOT NULL,
 CONSTRAINT [PK_tbl_tallybox_wallet_pubkey_archive_2] PRIMARY KEY CLUSTERED 
(
    [wallet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_tallybox_wallet_pubkey_buffer]    Script Date: 8/2/2025 6:51:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_tallybox_wallet_pubkey_buffer](
    [public_key] [varchar](50) NULL,
    [wallet_id] [bigint] NOT NULL,
    [archive_id] [tinyint] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_system_currency_currency_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_system_currency_currency_id] ON [dbo].[tbl_system_currency]
(
    [currency_id] ASC
)
INCLUDE([currency_name]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_system_graph_graph_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_system_graph_graph_id] ON [dbo].[tbl_system_graph]
(
    [graph_id] ASC
)
INCLUDE([graph_domain]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_currency_id_tnx_type]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_currency_id_tnx_type] ON [dbo].[tbl_tallybox_book]
(
    [currency_id] ASC,
    [tnx_type] ASC
)
INCLUDE([currency_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_currency_id_wallet_id_tnx_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_currency_id_wallet_id_tnx_id] ON [dbo].[tbl_tallybox_book]
(
    [currency_id] ASC,
    [wallet_id] ASC,
    [tnx_id] DESC
)
INCLUDE([tnx_type],[currency_amount],[left_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_tnx_id_tnx_type]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_tnx_id_tnx_type] ON [dbo].[tbl_tallybox_book]
(
    [tnx_id] DESC,
    [tnx_type] DESC
)
INCLUDE([tnx_id_dag],[graph_id],[wallet_id],[currency_id],[currency_amount],[left_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_tnx_type_currency_id_wallet_id_tnx_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_tnx_type_currency_id_wallet_id_tnx_id] ON [dbo].[tbl_tallybox_book]
(
    [tnx_type] ASC,
    [currency_id] ASC,
    [wallet_id] ASC,
    [tnx_id] DESC
)
INCLUDE([currency_amount],[left_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_currency_id_tnx_type]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_currency_id_tnx_type] ON [dbo].[tbl_tallybox_book_archive_1]
(
    [currency_id] ASC,
    [tnx_type] ASC
)
INCLUDE([currency_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_currency_id_wallet_id_tnx_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_currency_id_wallet_id_tnx_id] ON [dbo].[tbl_tallybox_book_archive_1]
(
    [currency_id] ASC,
    [wallet_id] ASC,
    [tnx_id] DESC
)
INCLUDE([tnx_type],[currency_amount],[left_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_tnx_id_tnx_type]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_tnx_id_tnx_type] ON [dbo].[tbl_tallybox_book_archive_1]
(
    [tnx_id] DESC,
    [tnx_type] DESC
)
INCLUDE([tnx_id_dag],[graph_id],[wallet_id],[currency_id],[currency_amount],[left_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_tnx_type_currency_id_wallet_id_tnx_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_tnx_type_currency_id_wallet_id_tnx_id] ON [dbo].[tbl_tallybox_book_archive_1]
(
    [tnx_type] ASC,
    [currency_id] ASC,
    [wallet_id] ASC,
    [tnx_id] DESC
)
INCLUDE([currency_amount],[left_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_currency_id_tnx_type]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_currency_id_tnx_type] ON [dbo].[tbl_tallybox_book_archive_2]
(
    [currency_id] ASC,
    [tnx_type] ASC
)
INCLUDE([currency_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_currency_id_wallet_id_tnx_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_currency_id_wallet_id_tnx_id] ON [dbo].[tbl_tallybox_book_archive_2]
(
    [currency_id] ASC,
    [wallet_id] ASC,
    [tnx_id] DESC
)
INCLUDE([tnx_type],[currency_amount],[left_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_tnx_id_tnx_type]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_tnx_id_tnx_type] ON [dbo].[tbl_tallybox_book_archive_2]
(
    [tnx_id] DESC,
    [tnx_type] DESC
)
INCLUDE([tnx_id_dag],[graph_id],[wallet_id],[currency_id],[currency_amount],[left_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_book_tnx_type_currency_id_wallet_id_tnx_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_book_tnx_type_currency_id_wallet_id_tnx_id] ON [dbo].[tbl_tallybox_book_archive_2]
(
    [tnx_type] ASC,
    [currency_id] ASC,
    [wallet_id] ASC,
    [tnx_id] DESC
)
INCLUDE([currency_amount],[left_amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_sign_tnx_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_sign_tnx_id] ON [dbo].[tbl_tallybox_sign]
(
    [tnx_id] ASC
)
INCLUDE([tree_id],[order_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_sign_tnx_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_sign_tnx_id] ON [dbo].[tbl_tallybox_sign_archive_1]
(
    [tnx_id] ASC
)
INCLUDE([tree_id],[order_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_sign_tnx_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_sign_tnx_id] ON [dbo].[tbl_tallybox_sign_archive_2]
(
    [tnx_id] ASC
)
INCLUDE([tree_id],[order_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_wallet_wallet_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_wallet_wallet_id] ON [dbo].[tbl_tallybox_wallet]
(
    [wallet_id] ASC
)
INCLUDE([the_wallet]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_wallet_wallet_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_wallet_wallet_id] ON [dbo].[tbl_tallybox_wallet_archive_1]
(
    [wallet_id] ASC
)
INCLUDE([the_wallet]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_tbl_tallybox_wallet_wallet_id]    Script Date: 8/2/2025 6:51:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_tbl_tallybox_wallet_wallet_id] ON [dbo].[tbl_tallybox_wallet_archive_2]
(
    [wallet_id] ASC
)
INCLUDE([the_wallet]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_optimize_row_counts] ADD  CONSTRAINT [DF__tbl_row_c__row_c__1B9317B3]  DEFAULT ((0)) FOR [row_count]
GO
ALTER TABLE [dbo].[tbl_optimize_row_counts] ADD  CONSTRAINT [DF__tbl_row_c__last___1C873BEC]  DEFAULT (getdate()) FOR [last_updated]
GO
ALTER TABLE [dbo].[tbl_system_peers]  WITH CHECK ADD  CONSTRAINT [CHK_last_time] CHECK  (([last_time]>=(0)))
GO
ALTER TABLE [dbo].[tbl_system_peers] CHECK CONSTRAINT [CHK_last_time]
GO
ALTER TABLE [dbo].[tbl_system_peers]  WITH CHECK ADD  CONSTRAINT [CHK_port] CHECK  (([port]>=(0) AND [port]<=(65535)))
GO
ALTER TABLE [dbo].[tbl_system_peers] CHECK CONSTRAINT [CHK_port]
GO
USE [master]
GO
ALTER DATABASE [net_mixoftix_tallybox] SET  READ_WRITE 
GO
                </textarea>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/ssms/scripting/generate-scripts-sql-server-management-studio">Generate Scripts in SSMS (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/SQL">SQL (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 3: Transaction Processing Tables -->
        <section class="content-box">
            <h3>Step 3: Transaction Processing Tables</h3>
            <p>These tables handle incoming transactions and their processing. They include:
                <ul>
                    <li><strong>tbl_order_dispatcher_0 to tbl_order_dispatcher_9</strong>: Sharded tables for incoming transactions, each with fields like `graph_from`, `wallet_from`, `order_amount`, and `the_sign` (primary key).</li>
                    <li><strong>tbl_order_ods</strong>: Holds transactions moved from dispatcher tables for processing, with the same structure as dispatcher tables.</li>
                    <li><strong>tbl_order_ods_multiple</strong>: Stores multiple recipients for group transactions, linked by `the_sign_md5`.</li>
                </ul>
                These tables are used by `timer_engine_Tick` and `sql_ods_processor` to process transactions.
            </p>
            <div class="gray-box">
                <p><strong>Schema Example: tbl_order_ods</strong><br><br>
                <pre>
CREATE TABLE tbl_order_ods (
    graph_from VARCHAR(50) NULL,
    graph_to VARCHAR(50) NULL,
    wallet_from VARCHAR(64) NOT NULL,
    wallet_to VARCHAR(64) NOT NULL,
    order_currency VARCHAR(10) NULL,
    order_amount DECIMAL(18,8) NOT NULL,
    order_utc_unix BIGINT NOT NULL,
    order_id VARCHAR(20) NULL,
    public_key VARCHAR(50) NULL,
    the_sign VARCHAR(100) NOT NULL,
    local_utc_unix BIGINT NULL,
    CONSTRAINT PK_tbl_order_ods PRIMARY KEY (the_sign)
)
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Data:</strong><br><br>
                Table: tbl_order_ods<br>
                graph_from: tallybox.mixoftix.net<br>
                wallet_from: boxB2bbc15c8c135...<br>
                order_currency: 2ZR<br>
                order_amount: 3500.00000000<br>
                order_id: 778844<br>
                the_sign: MEYCIQCxzNKhOUXijLr+z2mI9npu/+KZijiEv3//W7Ya3VpvzgIhAI1m7wJLJ9ldP2m5jmYfUreuvoKTjoZmFQmt5e6foakp<br>
                local_utc_unix: 1741675600</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql">CREATE TABLE (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Database_sharding">Database Sharding (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 4: System Configuration Tables -->
        <section class="content-box">
            <h3>Step 4: System Configuration Tables</h3>
            <p>These tables store configuration and validation data for the TallyBox system. They include:
                <ul>
                    <li><strong>tbl_system_config</strong>: Key-value pairs for system settings (e.g., `config_key`, `config_value`).</li>
                    <li><strong>tbl_system_currency</strong>: Defines currencies (e.g., IRR, 2ZR) with `currency_id` and `currency_name` (primary key).</li>
                    <li><strong>tbl_system_graph</strong>: Maps graph domains to IDs (e.g., `graph_domain` as primary key).</li>
                    <li><strong>tbl_system_peers</strong>: Tracks peer nodes with `ip` (primary key), `port`, and `status`.</li>
                    <li><strong>tbl_system_treasury</strong>: Manages treasury transactions with `treasury_id` (primary key).</li>
                    <li><strong>tbl_system_gazette</strong>: Logs blockchain-related data (no primary key).</li>
                </ul>
                These tables support validation in `sql_ods_processor`.
            </p>
            <div class="gray-box">
                <p><strong>Schema Example: tbl_system_currency</strong><br><br>
                <pre>
CREATE TABLE tbl_system_currency (
    currency_id INT NULL,
    currency_name VARCHAR(10) NOT NULL,
    currency_title VARCHAR(50) NULL,
    currency_image VARCHAR(15) NULL,
    CONSTRAINT PK_tbl_system_currency PRIMARY KEY (currency_name)
)
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Data:</strong><br><br>
                Table: tbl_system_currency<br>
                currency_id: 1<br>
                currency_name: IRR<br>
                currency_title: Iranian Rial<br>
                currency_image: irr.png<br><br>
                currency_id: 2<br>
                currency_name: 2ZR<br>
                currency_title: TallyBox Token<br>
                currency_image: 2zr.png</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints">Primary Key Constraints (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Database_normalization">Database Normalization (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 5: Ledger and Wallet Tables -->
        <section class="content-box">
            <h3>Step 5: Ledger and Wallet Tables</h3>
            <p>These tables manage wallets and ledger entries for transactions in the TallyBox system. They are critical for tracking wallet identities, public keys, and transaction records. The tables include:
                <ul>
                    <li><strong>tbl_tallybox_wallet</strong>: Maps wallet addresses (`the_wallet`, primary key) to unique `wallet_id` values for efficient referencing.</li>
                    <li><strong>tbl_tallybox_wallet_pubkey</strong>: Associates public keys (`public_key`) with `wallet_id` (primary key) for cryptographic validation.</li>
                    <li><strong>tbl_tallybox_book</strong>: Records ledger entries for transactions, including `tnx_id`, `currency_amount`, `left_amount`, and `tally_hash` (primary key).</li>
                    <li><strong>tbl_tallybox_sign</strong>: Stores transaction signatures and metadata, with `tnx_id` (primary key), `the_sign`, and `the_sign_md5` for verification.</li>
                </ul>
                These tables are updated by the `sql_ods_processor` stored procedure during transaction processing, ensuring accurate ledger updates and signature validation.
            </p>
            <div class="gray-box">
                <p><strong>Schema Example: tbl_tallybox_book</strong><br><br>
                <pre>
CREATE TABLE tbl_tallybox_book (
    tnx_id_dag DECIMAL(18,7) NULL,
    tnx_id DECIMAL(18,7) NULL,
    tnx_type TINYINT NULL,
    graph_id INT NULL,
    wallet_id BIGINT NULL,
    currency_id INT NULL,
    currency_amount DECIMAL(18,8) NULL,
    left_amount DECIMAL(18,8) NULL,
    tally_hash_dag VARCHAR(64) NULL,
    tally_hash VARCHAR(64) NOT NULL,
    CONSTRAINT PK_tbl_tallybox_book PRIMARY KEY (tally_hash)
)
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Data:</strong><br><br>
                Table: tbl_tallybox_book<br>
                tnx_id_dag: 1741675599.1000000<br>
                tnx_id: 1741675600.1000000<br>
                tnx_type: 0<br>
                graph_id: 123<br>
                wallet_id: 1001<br>
                currency_id: 1<br>
                currency_amount: 750.00000000<br>
                left_amount: 250.00000000<br>
                tally_hash_dag: a1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef<br>
                tally_hash: 7c4a8d09ca3762af61e59520943dc26494f8941b</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints">Primary Key Constraints (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Cryptographic_hash_function">Cryptographic Hash Functions (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 6: Buffer and Archive Tables -->
        <section class="content-box">
            <h3>Step 6: Buffer and Archive Tables</h3>
            <p>Buffer and archive tables manage temporary storage and long-term archiving of transaction and wallet data. These tables include:
                <ul>
                    <li><strong>tbl_tallybox_wallet_buffer</strong>, <strong>tbl_tallybox_wallet_pubkey_buffer</strong>, <strong>tbl_tallybox_book_buffer</strong>, <strong>tbl_tallybox_sign_buffer</strong>: Temporary storage for records before archiving, with an `archive_id` (1 or 2) to determine the target archive table.</li>
                    <li><strong>tbl_tallybox_wallet_archive_1</strong>, <strong>tbl_tallybox_wallet_archive_2</strong>, <strong>tbl_tallybox_wallet_pubkey_archive_1</strong>, <strong>tbl_tallybox_wallet_pubkey_archive_2</strong>, <strong>tbl_tallybox_book_archive_1</strong>, <strong>tbl_tallybox_book_archive_2</strong>, <strong>tbl_tallybox_sign_archive_1</strong>, <strong>tbl_tallybox_sign_archive_2</strong>: Archive tables for long-term storage, sharded into two tables for scalability.</li>
                </ul>
                The `timer_buffer_Tick` process moves data from buffer tables to archive tables based on the `archive_id` value.
            </p>
            <div class="gray-box">
                <p><strong>Schema Example: tbl_tallybox_wallet_buffer</strong><br><br>
                <pre>
CREATE TABLE tbl_tallybox_wallet_buffer (
    the_wallet VARCHAR(64) NOT NULL,
    wallet_id BIGINT NOT NULL,
    archive_id TINYINT NULL
)
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Data:</strong><br><br>
                Table: tbl_tallybox_wallet_buffer<br>
                the_wallet: boxB2bbc15c8c135a7b8f8e7a8b6c7d5e4f3a2b1c0d9e8f7a6b5c4d3e2f1a0b9c8<br>
                wallet_id: 1001<br>
                archive_id: 1</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/relational-databases/tables/temporal-tables">Temporal Tables (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Data_archiving">Data Archiving (Wikipedia)</a>
            </p>
        </section>

        <!-- Step 7: Optimization and Monitoring -->
        <section class="content-box">
            <h3>Step 7: Optimization and Monitoring</h3>
            <p>The database includes features for optimization and monitoring:
                <ul>
                    <li><strong>tbl_optimize_row_counts</strong>: Tracks row counts for each table (`table_name`, primary key) with `row_count` and `last_updated` for performance monitoring.</li>
                    <li><strong>Indexes</strong>: Non-clustered indexes on `tbl_tallybox_book`, `tbl_tallybox_sign`, `tbl_tallybox_wallet`, and archive tables optimize queries on `currency_id`, `tnx_id`, `tnx_type`, and `wallet_id`.</li>
                    <li><strong>Constraints</strong>: Primary keys ensure uniqueness, and check constraints on `tbl_system_peers` validate `last_time` and `port` values.</li>
                    <li><strong>Query Store</strong>: Enabled to track query performance and identify bottlenecks.</li>
                </ul>
                These features ensure efficient transaction processing and data retrieval.
            </p>
            <div class="gray-box">
                <p><strong>Schema Example: tbl_optimize_row_counts</strong><br><br>
                <pre>
CREATE TABLE tbl_optimize_row_counts (
    table_name VARCHAR(30) NOT NULL,
    row_count BIGINT NOT NULL DEFAULT (0),
    last_updated DATETIME NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT PK_tbl_row_counts PRIMARY KEY (table_name)
)
                </pre>
                </p>
            </div>
            <br>
            <div class="cyan-box">
                <p><strong>Example Data:</strong><br><br>
                Table: tbl_optimize_row_counts<br>
                table_name: tbl_tallybox_book<br>
                row_count: 15000<br>
                last_updated: 2025-08-02 05:47:00</p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/relational-databases/indexes/indexes">Indexes (Microsoft Docs)</a><br>
                <a href="https://learn.microsoft.com/en-us/sql/relational-databases/performance/monitor-and-tune-for-performance">Performance Monitoring (Microsoft Docs)</a>
            </p>
        </section>

        <!-- Step 8: Data Flow and Relationships -->
        <section class="content-box">
            <h3>Step 8: Data Flow and Relationships</h3>
            <p>The data flow in the TallyBox database follows a structured process:
                <ol>
                    <li>Incoming transactions are stored in one of the sharded `tbl_order_dispatcher_X` tables (0-9), identified by `the_sign`.</li>
                    <li>The `timer_engine_Tick` process moves transactions to `tbl_order_ods` for processing.</li>
                    <li>The `sql_ods_processor` validates transactions using `tbl_system_currency`, `tbl_system_graph`, and `tbl_tallybox_wallet`, then updates `tbl_tallybox_book` and `tbl_tallybox_sign`.</li>
                    <li>For group transactions, `tbl_order_ods_multiple` stores multiple recipients linked by `the_sign_md5`.</li>
                    <li>Periodically, `timer_buffer_Tick` moves records from buffer tables (`tbl_tallybox_wallet_buffer`, etc.) to archive tables (`tbl_tallybox_wallet_archive_1`, etc.) based on `archive_id`.</li>
                    <li>`tbl_system_treasury` and `tbl_system_gazette` log treasury and blockchain-related data.</li>
                </ol>
                <strong>Relationships:</strong>
                <ul>
                    <li>`tbl_tallybox_book.wallet_id` references `tbl_tallybox_wallet.wallet_id`.</li>
                    <li>`tbl_tallybox_book.currency_id` references `tbl_system_currency.currency_id`.</li>
                    <li>`tbl_tallybox_sign.tnx_id` links to `tbl_tallybox_book.tnx_id`.</li>
                    <li>`tbl_order_ods.the_sign` links to `tbl_tallybox_sign.the_sign`.</li>
                </ul>
            </p>
            <div class="gray-box">
                <p><strong>Pseudo-Code: Transaction Processing</strong><br><br>
                <pre>
BEGIN
    SELECT * FROM tbl_order_dispatcher_X WHERE the_sign = 'signature'
    INSERT INTO tbl_order_ods SELECT * FROM tbl_order_dispatcher_X
    EXEC sql_ods_processor @the_sign
        VALIDATE wallet_from, wallet_to IN tbl_tallybox_wallet
        VALIDATE order_currency IN tbl_system_currency
        INSERT INTO tbl_tallybox_book (tnx_id, wallet_id, currency_amount, tally_hash)
        INSERT INTO tbl_tallybox_sign (tnx_id, the_sign, the_sign_md5)
    MOVE TO tbl_tallybox_book_buffer WHERE archive_id = 1
    EXEC timer_buffer_Tick
        INSERT INTO tbl_tallybox_book_archive_1 SELECT * FROM tbl_tallybox_book_buffer
END
                </pre>
                </p>
            </div>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/relational-databases/stored-procedures/stored-procedures-database-engine">Stored Procedures (Microsoft Docs)</a><br>
                <a href="https://en.wikipedia.org/wiki/Database_design">Database Design (Wikipedia)</a>
            </p>
        </section>

        <!-- Conclusion -->
        <section class="content-box">
            <h3>Conclusion</h3>
            <p>The `net_mixoftix_tallybox` database is designed for efficient transaction processing, wallet management, and data archiving in the TallyBox application. Its sharded dispatcher tables, system configuration tables, ledger and wallet tables, and buffer/archive system ensure scalability and performance. Non-clustered indexes and the Query Store optimize query performance, while constraints maintain data integrity. By following this tutorial, developers can set up the database, understand its structure, and integrate it with the TallyBox application.</p>
            <p>For further assistance, refer to the provided SQL script and Microsoft SQL Server documentation. If you have questions, contact the TallyBox support team.</p>
            <p><strong>References:</strong><br>
                <a href="https://learn.microsoft.com/en-us/sql/sql-server">SQL Server Documentation</a><br>
                <a href="https://en.wikipedia.org/wiki/Blockchain">Blockchain (Wikipedia)</a>
            </p>
        </section>

    </main>

<!--#INCLUDE virtual="/inc_footer.asp"-->