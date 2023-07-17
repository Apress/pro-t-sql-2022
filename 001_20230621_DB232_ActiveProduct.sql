-- <Migration ID="68feb116-9776-4168-9d77-b6d28c0f43f9" />
GO
PRINT N'Altering [dbo].[GetProduct]...';
GO
/*-------------------------------------------------------------*\
Name:             dbo.GetProduct
Author:           Elizabeth Noble
Created Date:     October 30, 2022
Description: Get a list of all products in the databases
Updated Date:     May 20, 2023
Description: Add feature flag. If feature flag is enabled, only
     Show active products. Otherwise, show all products.
Updated Date:     June 20, 2023
Description: Remove the feature flag. Leave only the new logic.
     The stored procedure now only returns active products.
Updated Date:     June 21, 2023
Description: Remove dates.
     The stored procedure now only returns active products.


Sample Usage:
      EXECUTE dbo.GetProduct
\*-------------------------------------------------------------*/
CREATE OR ALTER PROCEDURE dbo.GetProduct
AS
  SELECT
        ProductID,
        ProductName,
        ProductPrice,
        IsActive,
        DateCreated,
        DateModified,
        DateDisabled        
  FROM dbo.Product
  WHERE IsActive = 1;
