CREATE TABLE dbo.CustomerOrderHistory2021
(
      CustomerOrderHistoryID BIGINT IDENTITY(1,1) NOT NULL,
      CustomerOrderID			    INT		      NOT NULL,
      CustomerOrderHistoryStatusID  TINYINT	      NOT NULL,
      DateCreated				    DATETIME2(2)  NOT NULL,
      DateModified			        DATETIME2(2)  NULL,
      CONSTRAINT PK_CustomerOrderHistory2021_CustomerOrderHistoryID
      	PRIMARY KEY NONCLUSTERED 
(CustomerOrderHistoryID, DateCreated),
      CONSTRAINT FK_CustomerOrderHistory2021_CustomerOrder
            FOREIGN KEY (CustomerOrderID)
            REFERENCES dbo.CustomerOrder(CustomerOrderID),
      CONSTRAINT    FK_CustomerOrderHistory2021_CustomerOrderHistoryStatus
            FOREIGN KEY (CustomerOrderHistoryStatusID)
            REFERENCES dbo.CustomerOrderHistoryStatus
(CustomerOrderHistoryStatusID)
);

CREATE CLUSTERED INDEX IX_CustomerOrderHistory2021_DateCreated
ON dbo.CustomerOrderHistory2021 (DateCreated)
ON CustomerOrderHistoryRange (DateCreated);

CREATE TABLE dbo.CustomerOrderHistory2022
(
      CustomerOrderHistoryID BIGINT IDENTITY(1,1) NOT NULL,
      CustomerOrderID			    INT		      NOT NULL,
      CustomerOrderHistoryStatusID  TINYINT	      NOT NULL,
      DateCreated				    DATETIME2(2)  NOT NULL,
      DateModified			        DATETIME2(2)  NULL,
      CONSTRAINT PK_CustomerOrderHistory2022_CustomerOrderHistoryID
      	PRIMARY KEY NONCLUSTERED 
(CustomerOrderHistoryID, DateCreated),
      CONSTRAINT FK_CustomerOrderHistory2022_CustomerOrder
            FOREIGN KEY (CustomerOrderID)
            REFERENCES dbo.CustomerOrder(CustomerOrderID),
      CONSTRAINT    FK_CustomerOrderHistory2022_CustomerOrderHistoryStatus
            FOREIGN KEY (CustomerOrderHistoryStatusID)
            REFERENCES dbo.CustomerOrderHistoryStatus
(CustomerOrderHistoryStatusID)
);

CREATE CLUSTERED INDEX IX_CustomerOrderHistory2022_DateCreated
ON dbo.CustomerOrderHistory2022 (DateCreated)
ON CustomerOrderHistoryRange (DateCreated);

ALTER TABLE dbo.CustomerOrderHistory2022
WITH CHECK ADD CONSTRAINT CK_CustomerOrderHistory2022_MinDateCreated
CHECK
(
      DateCreated IS NOT NULL
      AND DateCreated >= '01/01/2022'
);
ALTER TABLE dbo.CustomerOrderHistory2022
WITH CHECK ADD CONSTRAINT CK_CustomerOrderHistory2022_MaxDateCreated
CHECK
(
      DateCreated IS NOT NULL
      AND DateCreated < '01/01/2023'
);
ALTER TABLE dbo.CustomerOrderHistory2021
WITH CHECK ADD CONSTRAINT CK_CustomerOrderHistory2021_MinDateCreated
CHECK
(
      DateCreated IS NOT NULL
      AND DateCreated >= '01/01/2021'
);
ALTER TABLE dbo.CustomerOrderHistory2021
WITH CHECK ADD CONSTRAINT CK_CustomerOrderHistory2021_MaxDateCreated
CHECK
(
      DateCreated IS NOT NULL
      AND DateCreated < '01/01/2022'
);


CREATE VIEW dbo.vwCustomerOrderHistory
WITH SCHEMABINDING
AS
-- Select data from current read/write table
SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated,
      DateModified
FROM dbo.CustomerOrderHistory2022
UNION ALL
-- Select data from partitioned table
SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated,
      DateModified
FROM dbo.CustomerOrderHistory2021;


/*
INSERT INTO dbo.CustomerOrderHistory2022 
(
	CustomerOrderID, 
	CustomerOrderHistoryStatusID, 
	DateCreated, 
	DateModified
)
SELECT CustomerOrderID, 
	1 AS OrderStatusID, 
	DateCreated,
	DateModified
FROM dbo.CustomerOrder;
*/

DECLARE @StartDate  DATETIME2(2) = '08/31/2022';
DECLARE @EndDate	DATETIME2(2) = '12/01/2022';

SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated,
	  DateModified
FROM dbo.vwCustomerOrderHistory
WHERE DateCreated > @StartDate
	AND DateCreated <= @EndDate;

SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated
FROM dbo.vwCustomerOrderHistory
WHERE CustomerOrderID = 204375
      AND CustomerOrderHistoryStatusID = 1;

CREATE TABLE dbo.CustomerOrderHistoryPartition
(
      CustomerOrderHistoryID         BIGINT			NOT NULL,
      CustomerOrderID                INT			NOT NULL,
      CustomerOrderHistoryStatusID   TINYINT		NOT NULL,
      DateCreated					 DATETIME2(2)   NOT NULL,
      DateModified					 DATETIME2(2)   NULL,
      CONSTRAINT PK_CustomerOrderHistoryPartition_CustomerOrderHistoryID
            PRIMARY KEY (CustomerOrderHistoryID, DateCreated),
      CONSTRAINT FK_CustomerOrderHistoryPartition_CustomerOrderID
            FOREIGN KEY (CustomerOrderID)
            REFERENCES dbo.CustomerOrder(CustomerOrderID),
      CONSTRAINT FK_CustomerOrderHistoryParition_CustomerOrderHistoryStatusID
            FOREIGN KEY (CustomerOrderHistoryStatusID)
            REFERENCES
            dbo.CustomerOrderHistoryStatus(CustomerOrderHistoryStatusID)
)
ON CustomerOrderHistoryRange (DateCreated);

CREATE TABLE dbo.CustomerOrderActive
(
      CustomerOrderHistoryID         BIGINT			NOT NULL,
      CustomerOrderID                INT			NOT NULL,
      CustomerOrderHistoryStatusID   TINYINT		NOT NULL,
      DateCreated					 DATETIME2(2)   NOT NULL,
      DateModified					 DATETIME2(2)	NULL,
      CONSTRAINT PK_CustomerOrderActive_CustomerOrderHistoryID
            PRIMARY KEY (CustomerOrderHistoryID, DateCreated),
      CONSTRAINT FK_CustomerOrderActive_CustomerOrderID
            FOREIGN KEY (CustomerOrderID)
            REFERENCES dbo.CustomerOrder(CustomerOrderID),
      CONSTRAINT FK_CustomerOrderActive_CustomerOrderHistoryStatusID
            FOREIGN KEY (CustomerOrderHistoryStatusID)
            REFERENCES
            dbo.CustomerOrderHistoryStatus(CustomerOrderHistoryStatusID)
);

CREATE VIEW dbo.vwCustomerOrderHistory_PT
WITH SCHEMABINDING
AS
-- Select data from current read/write table
SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated,
      DateModified
FROM dbo.CustomerOrderHistory
UNION ALL
-- Select data from partitioned table
SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated,
      DateModified
FROM dbo.CustomerOrderHistoryPartition;


DECLARE @StartDate  DATETIME2(2) = '08/31/2022';
DECLARE @EndDate	DATETIME2(2) = '12/01/2022';

SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated,
	  DateModified
FROM dbo.vwCustomerOrderHistory_PT
WHERE DateCreated > @StartDate
	AND DateCreated <= @EndDate;


SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated
FROM dbo.vwCustomerOrderHistory
WHERE CustomerOrderID = 204375
      AND CustomerOrderHistoryStatusID = 1;


SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated
FROM dbo.vwCustomerOrderHistory_PT
WHERE CustomerOrderID = 204375
      AND CustomerOrderHistoryStatusID = 1;

