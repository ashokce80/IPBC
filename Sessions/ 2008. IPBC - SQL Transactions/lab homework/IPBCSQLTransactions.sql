----------- Ashok IPBC SQL Transactions LAb 7.18.19 ----------------
--Create a Stored Procedure that accepts StockName, NewOpenPrice, NewClosePrice.
Go
CREATE PROCEDURE dbo.error_handler
as
	BEGIN
	DECLARE @errnum INT,
			@severity INT,
			@errstate INT,
			@proc NVARCHAR(126),
			@line INT,
			@message NVARCHAR(4000)
	-- capture the error information that caused the CATCH block to be invoked
	SELECT	@errnum = ERROR_NUMBER(),
			@severity = ERROR_SEVERITY(),
			@errstate = ERROR_STATE(),
			@proc = ERROR_PROCEDURE(),
			@line = ERROR_LINE(),
			@message = ERROR_MESSAGE()

End

CREATE TABLE dbo.Stocks (
			StockID int IDENTITY(1,1),
			StockName varchar(50),
			OpenPrice money,
			ClosePrice money )

INSERT INTO dbo.Stocks
SELECT 'Walmart',21.58,22.98 UNION
SELECT 'Target',17.32,15.23 UNION
SELECT 'Taco Bell',4.58,12.98 UNION
SELECT 'Microsoft',7.15,8.15 UNION
SELECT 'Apple',10.79,9.89

Select	*
From	dbo.Stocks

--SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

GO
Alter Proc UDF_StockData
@StockName varchar(20)
,@NewOpenPrice Money
,@NewClosePrice Money
as
	Begin
		IF(@StockName in (Select StockName From dbo.Stocks))
			Begin Try
				Update	dbo.Stocks
				Set		OpenPrice = @NewOpenPrice,  ClosePrice = @NewClosePrice
				Where	StockName = @StockName--'Apple'
			End Try
			Begin Catch
				Exec dbo.error_handler
			End Catch
		Else
			Begin Try
				Insert dbo.Stocks(StockName,OpenPrice,ClosePrice)
				Select	@StockName,@NewOpenPrice,@NewClosePrice
			End Try
			Begin Catch
				Exec dbo.error_handler
			End Catch
	End

Exec [dbo].[UDF_StockData] 'Berry','WrongData',7.78
