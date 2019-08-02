-- =============================================
-- Author:		Ali Muwwakkil
-- Create date: 9/20/2013
-- Description:	This sp creates and/or updates the Sales DW
-- =============================================
CREATE PROCEDURE sp_DW_Update     -- EXEC sp_DW_Update

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
--------------------------------------------------------------------------------------------------------------------------
--Denormalizing the Data
--------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'tempdb..#SalesDataModel') IS NOT NULL BEGIN DROP TABLE #SalesDataModel END -- Delete Temp Table if exist

SELECT			d.ProductID,d.Name ProductName,e.Name ProductSubcategory,f.Name ProductCategory,  --Product Dimension Columns
				b.OrderDate,MONTH(b.OrderDate) OrderMonth,DATEPART(QQ,b.OrderDate) OrderQuarter,YEAR(b.OrderDate) OrderYear, --Time Dimension Columns
				c.TerritoryID,c.Name TerritoryName,c.[Group] TerritoryGroup, --Territory Dimension Columns		
				a.SalesOrderDetailID,a.OrderQty,a.UnitPrice,a.UnitPriceDiscount,a.LineTotal -- Sales Facts
INTO			#SalesDataModel
FROM			Sales.SalesOrderDetail a
LEFT JOIN		[Sales].[SalesOrderHeader] b
ON				a.SalesOrderID = b.SalesOrderID
LEFT JOIN		Sales.SalesTerritory c
ON				b.TerritoryID = c.TerritoryID
LEFT JOIN		Production.Product d
ON				a.ProductID = d.ProductID
LEFT JOIN		Production.ProductSubcategory e
ON				d.ProductSubcategoryID = e.ProductSubcategoryID
LEFT JOIN		Production.ProductCategory f
ON				e.ProductCategoryID = f.ProductCategoryID

--------------------------------------------------------------------------------------------------------------------------
--PRODUCT Dimension Start
--------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM SYSOBJECTS where name='Dim_Product' and xtype='U') -- Creates the Dim_Product Table if Exist
	BEGIN
			CREATE TABLE Dim_Product	(
											ProductKey INT IDENTITY(1,1),
											ProductID INT,
											ProductName VARCHAR(200),
											ProductSubcategory VARCHAR(200),
											ProductCategory VARCHAR(200),
											ProductCheckSum int
										)
	END

--------------------------------------------------------------------------------------------------------------------------
--Merge statement: If there is a new product, it will be added to the product dim.  If not, it will be updated
--------------------------------------------------------------------------------------------------------------------------	
MERGE		Dim_Product AS TARGET
USING		(	SELECT		DISTINCT ProductID,ProductName,ProductSubcategory,ProductCategory,
							BINARY_CHECKSUM(ProductName,ProductSubcategory,ProductCategory) ProductCheckSum
				FROM		#SalesDataModel	
			) AS SOURCE
ON			TARGET.ProductID = SOURCE.ProductID

WHEN		MATCHED and  TARGET.ProductCheckSum <> SOURCE.ProductCheckSum
THEN		
			UPDATE
			SET		TARGET.ProductName = SOURCE.ProductName,
					TARGET.ProductSubcategory = SOURCE.ProductSubcategory,
					TARGET.ProductCategory = SOURCE.ProductCategory
					
WHEN		NOT MATCHED
THEN		
			INSERT		(ProductID,ProductName,ProductSubcategory,ProductCategory,ProductCheckSum)
			VALUES		(SOURCE.ProductID,SOURCE.ProductName,SOURCE.ProductSubcategory,SOURCE.ProductCategory,
						BINARY_CHECKSUM(SOURCE.ProductName,SOURCE.ProductSubcategory,SOURCE.ProductCategory));
			

--------------------------------------------------------------------------------------------------------------------------
--TERRITORY Dimension Start
--------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM SYSOBJECTS where name='Dim_Territory' and xtype='U') -- Creates the Dim_Product Table if Exist
	BEGIN
			CREATE TABLE Dim_Territory	(
											TerritoryKey INT IDENTITY(1,1),
											TerritoryID INT,
											TerritoryName VARCHAR(200),
											TerritoryGroup VARCHAR(200),
											TerritoryCheckSum INT,
											/* TerritoryCheckSum column will store a calculation based on the records
											   in the table.  This is how we will know if a record has changed.
											*/
											TerritoryEffectiveDate DATETIME,
											TerritoryEndDate DATETIME,
											TerritoryCurrentRecord VARCHAR(50)
											
										)
										
	END

--------------------------------------------------------------------------------------------------------------------------
--Merge statement: If there is a new territory, it will be added to the territory dim.  If not, it will be updated
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Dim_Territory (TerritoryID,TerritoryName,TerritoryGroup,TerritoryCheckSum,TerritoryEffectiveDate,TerritoryEndDate,TerritoryCurrentRecord)
/*	The final result of the statement below will insert records into the Territory Dimension of the 
	Records that were updated since a new record needs to be inserted into Type 2 SCD to keep track of the changes  */	
SELECT		TerritoryID,
			TerritoryName,
			TerritoryGroup,
			TerritoryCheckSum,
			TerritoryEffectiveDate,
			TerritoryEndDate,
			TerritoryCurrentRecord
FROM
		(	/*	First we will connect the SalesDataModel temp table with the Territory Dimension to see if
				we need to update or insert records   */
			MERGE		Dim_Territory AS TARGET
			USING		(	SELECT		DISTINCT TerritoryID,TerritoryName,TerritoryGroup,
										BINARY_CHECKSUM(TerritoryName,TerritoryGroup) TerritoryCheckSum
							FROM		#SalesDataModel	
						) SOURCE
			ON			TARGET.TerritoryID = SOURCE.TerritoryID
			
			/*	When the TerritoryID is the same for both tables, this looks at the CheckSum columns to see if
				any of the data has changed.  If it has changed, we need to update the Enddate and make the 
				CurrentRecord column 'N' since it is no longer active  */
				
			WHEN		MATCHED and  TARGET.TerritoryCheckSum <> SOURCE.TerritoryCheckSum
			THEN		
						
						UPDATE
						SET		TARGET.TerritoryEndDate = GETDATE(),
								TARGET.TerritoryCurrentRecord = 'N'
								
			
									
			WHEN		NOT MATCHED
			THEN		
						INSERT		(TerritoryID,TerritoryName, TerritoryGroup, TerritoryEffectiveDate,TerritoryEndDate,TerritoryCheckSum,TerritoryCurrentRecord)
						VALUES		(SOURCE.TerritoryID,SOURCE.TerritoryName,SOURCE.TerritoryGroup,'1/1/2000','12/31/9999',
									BINARY_CHECKSUM(SOURCE.TerritoryName,SOURCE.TerritoryGroup),'Y')
									
								/*	
									1/1/2000 is entered for the TerritoryEffective Date only because we are dealing with past data.
									Normally this would be a GetDate()
								*/	
						
						
						OUTPUT	$action,
							SOURCE.TerritoryID,
							SOURCE.TerritoryName,
							SOURCE.TerritoryGroup,
							SOURCE.TerritoryCheckSum,
							GETDATE(),
							'12/31/9999',
							'Y'
							
			/*	All of statements below the FROM clause are tracked and can produce an output base on the Action performed
				UPDATE / INSERT / DELETE  */
		) Changes			
			(
				Action,
				TerritoryID,
				TerritoryName,
				TerritoryGroup,
				TerritoryCheckSum,
				TerritoryEffectiveDate,
				TerritoryEndDate,
				TerritoryCurrentRecord
			)	
			/*	This formats the Output columns that will return the results specified in the WHERE clause.  Since we have 
				specified UPDATE, this Merge will return the records that were updated and the beginning of this statement 
				specifies that an INSERT will be performed for thesr updated records.  */
				
WHERE	Action = 'UPDATE';


--------------------------------------------------------------------------------------------------------------------------
--TIME Dimension Start
--------------------------------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM SYSOBJECTS where name='Dim_Time' and xtype='U') -- Creates the Dim_Product Table if Exist
	BEGIN
			CREATE TABLE Dim_Time	(
											TimeKey INT IDENTITY(1,1),
											OrderDate DATETIME,
											OrderMonth INT,
											OrderQuarter INT,
											OrderYear INT,
											TimeCheckSum int
										)
	END

--------------------------------------------------------------------------------------------------------------------------
--Merge statement: 
--------------------------------------------------------------------------------------------------------------------------	
MERGE		Dim_Time AS TARGET
USING		(	SELECT		DISTINCT OrderDate,OrderMonth,OrderQuarter,OrderYear,
							BINARY_CHECKSUM(OrderMonth,OrderQuarter,OrderYear) TimeCheckSum
				FROM		#SalesDataModel	
			) AS SOURCE
ON			TARGET.OrderDate = SOURCE.OrderDate

WHEN		MATCHED and  TARGET.TimeCheckSum <> SOURCE.TimeCheckSum
THEN		
			UPDATE
			SET		TARGET.OrderMonth = SOURCE.OrderMonth,
					TARGET.OrderQuarter = SOURCE.OrderQuarter,
					TARGET.OrderYear = SOURCE.OrderYear
					
					
WHEN		NOT MATCHED
THEN		
			INSERT		(OrderDate,OrderMonth,OrderQuarter,OrderYear,TimeCheckSum)
			VALUES		(SOURCE.OrderDate,SOURCE.OrderMonth,SOURCE.OrderQuarter,SOURCE.OrderYear,
						BINARY_CHECKSUM(SOURCE.OrderMonth,SOURCE.OrderQuarter,SOURCE.OrderYear));

--------------------------------------------------------------------------------------------------------------------------
--SALES FACT TABLE
--------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM SYSOBJECTS where name='Fact_Sales' and xtype='U') -- Creates the Dim_Product Table if Exist
	BEGIN
			CREATE TABLE Fact_Sales	(
											FactSalesKey INT IDENTITY(1,1),
											SalesOrderDetailID INT,
											ProductKey INT,
											TerritoryKey INT,
											TimeKey INT,
											OrderQty INT,
											UnitPrice MONEY,
											UnitPriceDiscount MONEY,
											LineTotal MONEY,
											FactCheckSum INT
										)
	END

--------------------------------------------------------------------------------------------------------------------------
--Merge statement: If there is a new product, it will be added to the product dim.  If not, it will be updated
--------------------------------------------------------------------------------------------------------------------------	
MERGE		Fact_Sales AS TARGET
USING		(	SELECT		a.SalesOrderDetailID,b.ProductKey,c.TerritoryKey,d.TimeKey,OrderQty,UnitPrice,UnitPriceDiscount,LineTotal,
							BINARY_CHECKSUM(ProductKey,TerritoryKey,TimeKey,OrderQty,UnitPrice,UnitPriceDiscount,LineTotal) FactCheckSum
				FROM		#SalesDataModel a
				LEFT JOIN	Dim_Product b
				ON			a.ProductID = b.ProductID
				LEFT JOIN	Dim_Territory c
				ON			a.TerritoryID = c.TerritoryID
				AND			a.OrderDate between c.TerritoryEffectiveDate AND c.TerritoryEndDate
				LEFT JOIN	Dim_Time d
				ON			a.OrderDate = d.OrderDate 
			) AS SOURCE
ON			TARGET.SalesOrderDetailID = SOURCE.SalesOrderDetailID

WHEN		MATCHED and  TARGET.FactCheckSum <> SOURCE.FactCheckSum
THEN		
			UPDATE
			SET		TARGET.ProductKey = SOURCE.ProductKey,
					TARGET.TerritoryKey = SOURCE.TerritoryKey,
					TARGET.TimeKey = SOURCE.TimeKey,
					TARGET.OrderQty = SOURCE.OrderQty,
					TARGET.UnitPrice = SOURCE.UnitPrice,
					TARGET.UnitPriceDiscount = SOURCE.UnitPriceDiscount,
					TARGET.LineTotal = SOURCE.LineTotal,
					TARGET.FactCheckSum = SOURCE.FactCheckSum
					
WHEN		NOT MATCHED
THEN		
			INSERT		(SalesOrderDetailID,ProductKey,TerritoryKey,TimeKey,OrderQty,UnitPrice,UnitPriceDiscount,LineTotal,FactCheckSum)
			VALUES		(SOURCE.SalesOrderDetailID,SOURCE.ProductKey,SOURCE.TerritoryKey,SOURCE.TimeKey,SOURCE.OrderQty,
						SOURCE.UnitPrice,SOURCE.UnitPriceDiscount,SOURCE.LineTotal,
						BINARY_CHECKSUM(SOURCE.ProductKey,SOURCE.TerritoryKey,SOURCE.TimeKey,SOURCE.OrderQty,
						SOURCE.UnitPrice,SOURCE.UnitPriceDiscount,SOURCE.LineTotal));
			





/*
SELECT * FROM Dim_Product
SELECT * FROM #SalesDataModel
SELECT * FROM Dim_Territory
SELECT * FROM Dim_Time
SELECT * FROM Fact_Sales
*/


END
