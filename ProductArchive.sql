CREATE TABLE #TempProductArchive
(
      ProductID     INT				NOT NULL,
      ProductName   VARCHAR(25)		NOT NULL,
      ProductPrice  DECIMAL(6,2)	NOT NULL,
      IsActive      BIT				NOT NULL,
      DateCreated	DATETIME2(2)	NOT NULL,
      DateModified	DATETIME2(2)	NOT NULL,
	  DateDisabled	DATETIME2(2)	NULL,
      DateInserted	DATETIME2(2)	NOT NULL,
);

INSERT INTO #TempProductArchive
(
      ProductID,
      ProductName,
      ProductPrice,
      IsActive,
      DateCreated,
      DateModified,
	  DateDisabled,
	  DateInserted
)
VALUES 
(
	14,
	'Water shoes',
	25.00,
	0,
	'1/1/2018',
	'7/29/2022',
	'7/29/2022',
	GETDATE()
);

INSERT INTO #TempProductArchive
(
      ProductID,
      ProductName,
      ProductPrice,
      IsActive,
      DateCreated,
      DateModified,
	  DateDisabled,
	  DateInserted
)
VALUES 
(

);


SELECT
      ProductID,
      ProductName,
      ProductPrice,
      IsActive,
      DateCreated,
      DateModified,
	  DateDisabled,
	  GETDATE()
FROM dbo.Product 
WHERE DateDisabled < '8/1/2022';


UPDATE dbo.Product
SET IsActive = 0,
	DateModified = GETDATE(),
	DateDisabled = GETDATE()
WHERE ProductID = 1;

UPDATE dbo.Product
SET IsActive = 0,
	DateModified = GETDATE(),
	DateDisabled = GETDATE()
WHERE ProductID = 2;

UPDATE dbo.Product
SET IsActive = 0,
	DateModified = GETDATE(),
	DateDisabled = GETDATE()
WHERE ProductName LIKE '%water%';

UPDATE prd 
SET DateModified = GETDATE(),
	IsActive = 0
SELECT       
      ProductID,
      ProductName,
      ProductPrice,
      IsActive,
      DateCreated,
      DateModified,
	  DateDisabled
FROM dbo.Product prd 
	INNER JOIN dbo.ProductArchive pch
	ON prd.ProductID = pch.ProductID
WHERE pch.DateInserted >= CAST(GETDATE() AS DATE);