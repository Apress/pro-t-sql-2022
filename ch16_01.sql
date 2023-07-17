CREATE CLUSTERED INDEX IX_CustomerOrderHistory_CustomerOrderHistoryID
ON dbo.CustomerOrderHistory (CustomerOrderHistoryID);

DECLARE @StartDate  DATETIME2(2) = '08/02/2022';
DECLARE @EndDate	DATETIME2(2) = '10/09/2022';

SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated
FROM dbo.CustomerOrderHistory
WHERE DateCreated > @StartDate
	AND DateCreated <= @EndDate;

DROP INDEX IX_CustomerOrderHistory_CustomerOrderHistoryID
ON dbo.CustomerOrderHistory;

DECLARE @StartDate  DATETIME2(2) = '08/02/2022';
DECLARE @EndDate	DATETIME2(2) = '10/09/2022';

SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated
FROM dbo.CustomerOrderHistory
WHERE DateCreated > @StartDate
	AND DateCreated <= @EndDate;


ALTER DATABASE OutdoorRecreation
ADD FILEGROUP CustomerOrderHistory2021;
ALTER DATABASE OutdoorRecreation
ADD FILEGROUP CustomerOrderHistory2022Q1;
ALTER DATABASE OutdoorRecreation
ADD FILEGROUP CustomerOrderHistory2022Q2;
ALTER DATABASE OutdoorRecreation
ADD FILEGROUP CustomerOrderHistory2022Q3;
-- DROP TABLE CustomerOrderHistory
ALTER DATABASE OutdoorRecreation
ADD FILE
(
      NAME = CustomerOrderHistoryFG2021,
      FILENAME = 'D:\SQLData\CustomerOrderHistoryFG2021.ndf',
      SIZE = 50MB
)
TO FILEGROUP CustomerOrderHistory2021;
ALTER DATABASE OutdoorRecreation
ADD FILE
(
      NAME = CustomerOrderHistoryFG2022Q1,
      FILENAME = 'D:\SQLData\CustomerOrderHistoryFG2022Q1.ndf',
      SIZE = 50MB
)
TO FILEGROUP CustomerOrderHistory2022Q1;
ALTER DATABASE OutdoorRecreation
ADD FILE
(
      NAME = CustomerOrderHistoryFG2022Q2,
      FILENAME = 'D:\SQLData\CustomerOrderHistoryFG2022Q2.ndf',
      SIZE = 50MB
)
TO FILEGROUP CustomerOrderHistory2022Q2;
ALTER DATABASE OutdoorRecreation
ADD FILE
(
      NAME = CustomerOrderHistoryFG2022Q3,
      FILENAME = 'D:\SQLData\CustomerOrderHistoryFG2022Q3.ndf',
      SIZE = 50MB
)
TO FILEGROUP CustomerOrderHistory2022Q3;

-- DROP PARTITION FUNCTION CustomerOrderHistoryFunc
CREATE PARTITION FUNCTION CustomerOrderHistoryFunc(DATETIME2(2))
AS RANGE RIGHT FOR VALUES
(
      '01/01/2022',
      '04/01/2022',
      '07/01/2022'
);

-- DROP PARTITION SCHEME CustomerOrderHistoryRange
CREATE PARTITION SCHEME CustomerOrderHistoryRange
AS PARTITION CustomerOrderHistoryFunc TO
(
      CustomerOrderHistory2021,
      CustomerOrderHistory2022Q1,
      CustomerOrderHistory2022Q2,
      CustomerOrderHistory2022Q3
);

-- ALTER DATABASE OutdoorRecreation REMOVE FILEGROUP CustomerOrderHistory2022Q4
ALTER DATABASE OutdoorRecreation
ADD FILEGROUP CustomerOrderHistory2022Q4;
-- ALTER DATABASE OutdoorRecreation REMOVE FILE CustomerOrderHistoryFG2022Q4
ALTER DATABASE OutdoorRecreation
ADD FILE
(
      NAME = CustomerOrderHistoryFG2022Q4,
      FILENAME = 'D:\SQLData\CustomerOrderHistoryFG2022Q4.ndf',
      SIZE = 50MB
)
TO FILEGROUP CustomerOrderHistory2022Q4;

ALTER PARTITION SCHEME CustomerOrderHistoryRange
NEXT USED CustomerOrderHistory2022Q4;

ALTER PARTITION FUNCTION CustomerOrderHistoryFunc()
SPLIT RANGE ('10/01/2022');


CREATE TABLE dbo.CustomerOrderHistoryStatus
(
      CustomerOrderHistoryStatusID	 TINYINT		IDENTITY(1,1) NOT NULL,
      CustomerOrderHistoryStatusName VARCHAR(25)	NOT NULL,
	  IsActive						 BIT			NOT NULL,
      DateCreated					 DATETIME2(2)	NOT NULL,
      DateModified					 DATETIME2(2)	NULL,
      CONSTRAINT PK_CustomerOrderHistoryStatus_CustomerOrderHistoryStatusID
            PRIMARY KEY CLUSTERED (CustomerOrderHistoryStatusID)
);

/*
INSERT INTO dbo.CustomerOrderHistoryStatus 
(CustomerOrderHistoryStatusName, IsActive, DateCreated, DateModified) VALUES 
('Started',1,'1/1/2019','1/1/2022'),
('Completed',1,'1/1/2019','1/1/2022'),
('Cancelled',1,'1/1/2019','1/1/2022'),
('Error',1,'1/1/2019','1/1/2022');
*/


-- DROP TABLE dbo.CustomerOrderHistory
CREATE TABLE dbo.CustomerOrderHistory
(
      CustomerOrderHistoryID		BIGINT	 IDENTITY (1,1) NOT NULL,
      CustomerOrderID				INT		 NOT NULL,
      CustomerOrderHistoryStatusID  TINYINT	 NOT NULL,
      DateCreated				    DATETIME2(2) NOT NULL,
      DateModified			        DATETIME2(2) NULL,
      CONSTRAINT PK_CustomerOrderHistory_CustomerOrderHistoryID
            PRIMARY KEY NONCLUSTERED (CustomerOrderHistoryID, DateCreated),
      CONSTRAINT FK_CustomerOrderHistory_CustomerOrder
            FOREIGN KEY (CustomerOrderID)
            REFERENCES dbo.CustomerOrder(CustomerOrderID),
      CONSTRAINT FK_CustomerOrderHistory_CustomerOrderHistoryStatus
            FOREIGN KEY (CustomerOrderHistoryStatusID)
            REFERENCES dbo.CustomerOrderHistoryStatus(CustomerOrderHistoryStatusID)
) ON CustomerOrderHistoryRange (DateCreated);


SELECT tbl.[name] AS TableName,
      sch.[name] AS PartitionScheme,
      fnc.[name] AS PartitionFunction,
      prt.partition_number,
      fnc.[type_desc],
      rng.boundary_id,
      rng.[value] AS BoundaryValue,
      prt.[rows]
FROM sys.tables tbl
      INNER JOIN sys.indexes idx
      ON tbl.[object_id] = idx.[object_id]
      INNER JOIN sys.partitions prt
      ON idx.[object_id] = prt.[object_id]
            AND idx.index_id = prt.index_id
      INNER JOIN sys.partition_schemes AS sch
      ON idx.data_space_id = sch.data_space_id
      INNER JOIN sys.partition_functions AS fnc
      ON sch.function_id = fnc.function_id
      LEFT JOIN sys.partition_range_values AS rng
      ON fnc.function_id = rng.function_id
            AND rng.boundary_id = prt.partition_number
WHERE tbl.[name] = 'CustomerOrderHistory'
      AND idx.[type] <= 1
ORDER BY prt.partition_number;  

/*
SELECT MIN(DateCreated), MAX(DateCreated)
FROM dbo.CustomerOrder;
*/
/*
INSERT INTO dbo.CustomerOrderHistory 
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

SELECT
      SUM(
            CASE WHEN DateCreated < '1/1/2022'
                  THEN 1
                  ELSE 0
            END
      ) AS Partition1,
      SUM(
            CASE WHEN DateCreated >= '1/1/2022'
				AND DateCreated < '4/1/2022'
                  THEN 1
                  ELSE 0
            END
      ) AS Partition2,
      SUM(
            CASE WHEN DateCreated >= '4/1/2022'
				AND DateCreated < '7/1/2022'
                  THEN 1
                  ELSE 0
            END
      ) AS Partition3,
      SUM(
            CASE WHEN DateCreated >= '7/1/2022'
				AND DateCreated < '10/1/2022'
                  THEN 1
                  ELSE 0
            END
      ) AS Partition4,
      SUM(
            CASE WHEN DateCreated >= '10/1/2022'
                  THEN 1
                  ELSE 0
            END
      ) AS Partition5
FROM dbo.CustomerOrderHistory;

SELECT COUNT(*)
FROM dbo.CustomerOrderHistory
WHERE DateCreated = '1/1/2022';
/*
ALTER TABLE dbo.CustomerOrderHistory
ADD CONSTRAINT PK_CustomerOrderHistory_CustomerOrderHistoryID
PRIMARY KEY CLUSTERED (CustomerOrderHistoryID);
*/
ALTER TABLE dbo.CustomerOrderHistory
DROP CONSTRAINT PK_CustomerOrderHistory_CustomerOrderHistoryID
WITH (MOVE TO CustomerOrderHistoryRange(DateCreated))

ALTER TABLE dbo.CustomerOrderHistory
ADD CONSTRAINT PK_CustomerOrderHistory_CustomerOrderHistoryID
PRIMARY KEY NONCLUSTERED (CustomerOrderHistoryID, DateCreated);

CREATE CLUSTERED INDEX IX_CustomerOrderHistory_DateCreated
ON dbo.CustomerOrderHistory (DateCreated)
ON CustomerOrderHistoryRange (DateCreated);


ALTER TABLE dbo.CustomerOrderHistor
WITH CHECK ADD CONSTRAINT CK_CustomerOrderHistory_MinDateCreated
CHECK
(
      DateCreated IS NOT NULL
      AND DateCreated >= '08/01/2021'
);

ALTER TABLE dbo.CustomerOrderHistory
WITH CHECK ADD CONSTRAINT CK_CustomerOrderHistor_MaxDateCreated
CHECK
(
      DateCreated IS NOT NULL
      AND DateCreated < '1/01/2023'
);


ALTER TABLE dbo.CustomerOrderHistory SWITCH PARTITION 1
TO dbo.CustomerOrderHistoryArchive;
-- TRUNCATE TABLE dbo.CustomerOrderHistory
/*
CREATE TABLE dbo.CustomerOrderHistoryArchive
(
      CustomerOrderHistoryID		BIGINT	 NOT NULL,
      CustomerOrderID				INT		 NOT NULL,
      CustomerOrderHistoryStatusID  TINYINT	 NOT NULL,
      DateCreated				    DATETIME2(2) NOT NULL,
      DateModified			        DATETIME2(2) NULL,
      CONSTRAINT PK_CustomerOrderHistoryArchive_CustomerOrderHistoryID
            PRIMARY KEY NONCLUSTERED (CustomerOrderHistoryID, DateCreated),
      CONSTRAINT FK_CustomerOrderHistoryArchive_CustomerOrder
            FOREIGN KEY (CustomerOrderID)
            REFERENCES dbo.CustomerOrder(CustomerOrderID),
      CONSTRAINT FK_CustomerOrderHistoryArchive_CustomerOrderHistoryStatus
            FOREIGN KEY (CustomerOrderHistoryStatusID)
            REFERENCES dbo.CustomerOrderHistoryStatus(CustomerOrderHistoryStatusID)
) ON CustomerOrderHistory2021;
*/
ALTER TABLE dbo.CustomerOrderHistory SWITCH
      PARTITION 1
TO dbo.CustomerOrderHistoryArchive
      PARTITION 1;

DECLARE @StartDate  DATETIME2(2) = '08/02/2022';
DECLARE @EndDate	DATETIME2(2) = '10/09/2022';

SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated
FROM dbo.CustomerOrderHistory
WHERE DateCreated > @StartDate
	AND DateCreated <= @EndDate;
-- DBCC FREEPROCCACHE

SELECT CustomerOrderHistoryID,
      CustomerOrderID,
      CustomerOrderHistoryStatusID,
      DateCreated
FROM dbo.CustomerOrderHistory
WHERE CustomerOrderID = 4
      AND CustomerOrderHistoryStatusID = 2;
