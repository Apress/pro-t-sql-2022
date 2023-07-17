USE OutdoorRecreation;
GO

SELECT DISTINCT FirstName, LastName, Address, City, PostalCode, Country
FROM dbo.Customer

-- Memphis, Egypt -- 153 Road Mit Rahina Al Shabab 3364932 -- Karim Khalil  -- Add $249 Sales to Karim
-- Memphis, US -- 750 Cherry Rd, 38117

SELECT *
FROM dbo.Product

SELECT TOP 10 *
FROM dbo.CustomerOrder
ORDER BY 1 DESC;

BEGIN TRAN 
UPDATE dbo.Customer 
SET FirstName = 'Karim',
	LastName = 'Khalil',
	[Address] = '153 Road Mit Rahina Al Shabab',
	City = 'Memphis',
	PostalCode = '3364932',
	Country = 'Egypt'
WHERE CustomerID = 401407

UPDATE dbo.Customer 
SET FirstName = 'Marty`',
	LastName = 'Bethel',
	[Address] = '750 Cherry Rd',
	City = 'Memphis',
	PostalCode = '38117',
	Country = 'United States'
WHERE CustomerID = 401405
COMMIT

SELECT *
FROM dbo.CustomerOrder co 
	INNER JOIN dbo.OrderDetail od 
	ON co.CustomerOrderID = od.CustomerOrderID
WHERE CustomerID IN (401405,
401407)

UPDATE OrderDetail
SET QuantitySold = 2
WHERE OrderDetailID = 802819


SELECT FirstName, LastName 
FROM dbo.Customer 
WHERE City = 'Memphis'
UNION
SELECT FirstName, LastName 
FROM dbo.Customer 
WHERE [Address] LIKE '%de%';