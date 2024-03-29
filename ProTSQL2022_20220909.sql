USE [master]
GO
/****** Object:  Database [OutdoorRecreation]    Script Date: 9/9/2022 12:39:00 AM ******/
CREATE DATABASE [OutdoorRecreation]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'OutdoorRecreation', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\OutdoorRecreation_Primary.mdf' , SIZE = 204800KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'OutdoorRecreation_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\OutdoorRecreation_Primary.ldf' , SIZE = 270336KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [OutdoorRecreation] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OutdoorRecreation].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [OutdoorRecreation] SET ANSI_NULL_DEFAULT ON 
GO
ALTER DATABASE [OutdoorRecreation] SET ANSI_NULLS ON 
GO
ALTER DATABASE [OutdoorRecreation] SET ANSI_PADDING ON 
GO
ALTER DATABASE [OutdoorRecreation] SET ANSI_WARNINGS ON 
GO
ALTER DATABASE [OutdoorRecreation] SET ARITHABORT ON 
GO
ALTER DATABASE [OutdoorRecreation] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [OutdoorRecreation] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET CURSOR_DEFAULT  LOCAL 
GO
ALTER DATABASE [OutdoorRecreation] SET CONCAT_NULL_YIELDS_NULL ON 
GO
ALTER DATABASE [OutdoorRecreation] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [OutdoorRecreation] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET  DISABLE_BROKER 
GO
ALTER DATABASE [OutdoorRecreation] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [OutdoorRecreation] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET RECOVERY FULL 
GO
ALTER DATABASE [OutdoorRecreation] SET  MULTI_USER 
GO
ALTER DATABASE [OutdoorRecreation] SET PAGE_VERIFY NONE  
GO
ALTER DATABASE [OutdoorRecreation] SET DB_CHAINING OFF 
GO
ALTER DATABASE [OutdoorRecreation] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [OutdoorRecreation] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [OutdoorRecreation] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [OutdoorRecreation] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'OutdoorRecreation', N'ON'
GO
ALTER DATABASE [OutdoorRecreation] SET QUERY_STORE = OFF
GO
USE [OutdoorRecreation]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 9/9/2022 12:39:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](40) NOT NULL,
	[LastName] [varchar](100) NOT NULL,
	[Address] [varchar](100) NOT NULL,
	[City] [varchar](100) NOT NULL,
	[PostalCode] [varchar](20) NULL,
	[Country] [varchar](75) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DateCreated] [datetime2](2) NOT NULL,
	[DateModified] [datetime2](2) NOT NULL,
	[DateDisabled] [datetime2](2) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerOrder]    Script Date: 9/9/2022 12:39:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerOrder](
	[CustomerOrderID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[OrderNumber] [varchar](15) NOT NULL,
	[OrderDate] [datetime2](2) NULL,
	[ShipDate] [datetime2](2) NULL,
	[IsActive] [bit] NOT NULL,
	[DateCreated] [datetime2](2) NOT NULL,
	[DateModified] [datetime2](2) NOT NULL,
	[DateDisabled] [datetime2](2) NULL,
 CONSTRAINT [PK_CustomerOrder] PRIMARY KEY CLUSTERED 
(
	[CustomerOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 9/9/2022 12:39:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[OrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerOrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductPrice] [decimal](6, 2) NOT NULL,
	[QuantitySold] [smallint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DateCreated] [datetime2](2) NOT NULL,
	[DateModified] [datetime2](2) NOT NULL,
	[DateDisabled] [datetime2](2) NULL,
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[OrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 9/9/2022 12:39:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](25) NOT NULL,
	[ProductPrice] [decimal](6, 2) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DateCreated] [datetime2](2) NOT NULL,
	[DateModified] [datetime2](2) NOT NULL,
	[DateDisabled] [datetime2](2) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [CX_Customer_DateCreated]    Script Date: 9/9/2022 12:39:00 AM ******/
CREATE NONCLUSTERED INDEX [CX_Customer_DateCreated] ON [dbo].[Customer]
(
	[DateCreated] ASC,
	[FirstName] ASC,
	[LastName] ASC,
	[Country] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_DateModified]  DEFAULT (getdate()) FOR [DateModified]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_DateDisabled]  DEFAULT (NULL) FOR [DateDisabled]
GO
ALTER TABLE [dbo].[CustomerOrder] ADD  CONSTRAINT [DF_CustomerOrder_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[CustomerOrder] ADD  CONSTRAINT [DF_CustomerOrder_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[CustomerOrder] ADD  CONSTRAINT [DF_CustomerOrder_DateModified]  DEFAULT (getdate()) FOR [DateModified]
GO
ALTER TABLE [dbo].[CustomerOrder] ADD  CONSTRAINT [DF_CustomerOrder_DateDisabled]  DEFAULT (NULL) FOR [DateDisabled]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_DateModified]  DEFAULT (getdate()) FOR [DateModified]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_DateDisabled]  DEFAULT (NULL) FOR [DateDisabled]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_DateCreated]  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_DateModified]  DEFAULT (getdate()) FOR [DateModified]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_DateDisabled]  DEFAULT (NULL) FOR [DateDisabled]
GO
ALTER TABLE [dbo].[CustomerOrder]  WITH CHECK ADD  CONSTRAINT [FK_CustomerOrder_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[CustomerOrder] CHECK CONSTRAINT [FK_CustomerOrder_Customer]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_CustomerOrder] FOREIGN KEY([CustomerOrderID])
REFERENCES [dbo].[CustomerOrder] ([CustomerOrderID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_CustomerOrder]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Product]
GO
/****** Object:  StoredProcedure [dbo].[GetCustomer]    Script Date: 9/9/2022 12:39:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------*\
Name:             dbo.GetCustomer
Author:           Elizabeth Noble
Created Date:     October 30, 2022
Description: Get a list of all customers in the databases
Sample Usage:
      EXECUTE dbo.GetCustomer
\*-------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[GetCustomer]
AS
  SELECT
        CustomerID,
        FirstName,
        LastName,
        Address,
        City,
        PostalCode,
        Country,
        IsActive,
        DateCreated,
        DateModified,
        DateDisabled
  FROM dbo.Customer;
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerAndOrderNumberByProductID]    Script Date: 9/9/2022 12:39:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------*\
Name:             dbo.GetCustomerAndOrderNumberByProductID
Author:           Elizabeth Noble
Created Date:     October 30, 2022
Description: Get customer and products ordered for an order number
Sample Usage:
      EXECUTE dbo.GetRecipeAndIngredientByMealTypeID 1
\*-------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[GetCustomerAndOrderNumberByProductID]
     @ProductID     INT
WITH RECOMPILE
AS
     SELECT
          cus.FirstName, 
          cus.LastName, 
          ord.OrderNumber,
          ord.OrderDate,
          prd.ProductName,
          SUM(dtl.QuantitySold),
          dtl.ProductPrice
     FROM dbo.Customer cus
          INNER JOIN dbo.CustomerOrder ord
          ON cus.CustomerID = ord.CustomerID
          INNER JOIN dbo.OrderDetail dtl 
          ON ord.CustomerOrderID = dtl.CustomerOrderID
          INNER JOIN dbo.Product prd
          ON prd.ProductID = dtl.ProductID
     WHERE prd.ProductID = @ProductID
     GROUP BY cus.FirstName, 
          cus.LastName, 
          ord.OrderNumber,
          ord.OrderDate,
          prd.ProductName,
          dtl.ProductPrice
     ORDER BY cus.FirstName, cus.LastName;
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerByCustomerID]    Script Date: 9/9/2022 12:39:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------*\
Name:             dbo.GetCustomerByCustomerID
Author:           Elizabeth Noble
Created Date:     October 30, 2022
Description: Get Customer information when a Customer ID is provided
Sample Usage:
      DECLARE @CustomerID INT;
      SET @CustomerID = 1;
      EXECUTE dbo.GetCustomerByCustomerID @CustomerID
\*-------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[GetCustomerByCustomerID]
      @CustomerID   INT
AS
     SELECT
          CustomerID,
          FirstName,
          LastName,
          Address,
          City,
          PostalCode,
          Country,
          IsActive,
          DateCreated,
          DateModified,
          DateDisabled
     FROM dbo.Customer
     WHERE CustomerID = @CustomerID;
GO
USE [master]
GO
ALTER DATABASE [OutdoorRecreation] SET  READ_WRITE 
GO
