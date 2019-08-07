USE [Mortgage]
GO
/****** Object:  StoredProcedure [dbo].[proc_LoanGauges]    Script Date: 06/29/2013 17:47:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[proc_LoanGauges] --EXEC  dbo.proc_LoanGauges 

	@ReportDate Datetime,
	@LoanAmount varchar(max),
	@LoanPurpose varchar(max),
	@PropertyUsage varchar(max),
	@Demographics2 varchar(max)	
	
	AS
		BEGIN

			DECLARE		@CurrentMonth INT,
						@CurrentYear  INT,
						@PriorMonth INT,
						@PriorYear  INT,
						@CurrentQuarter INT,
						@MTD INT,
						@QTD INT,
						@MonthlyPrior6mnthAvg INT,
						@MonthlyPrior6mnthAvgExcludeCurrMonth INT,
						@LastFullMonth INT,
						@LastFullQuarter INT
						--,@ReportDate Datetime = '6/25/2013'
						
			SET			@CurrentMonth = DATEPART(MM,@ReportDate)
			SET			@CurrentQuarter = DATEPART(QQ,@ReportDate)
			SET			@CurrentYear = DATEPART(YY,@ReportDate)
			SET			@PriorMonth = DATEPART(MM,DateAdd(MM,-1,@ReportDate))
			SET			@PriorYear = (
			SELECT CASE WHEN DATEPART(MM,DateAdd(MM,-1,@ReportDate)) = 1 THEN DATEPART(YY,DATEADD(YY,-1,@ReportDate)) ELSE @CurrentYear END)
						--SELECT @CurrentMonth,@CurrentQuarter,@CurrentYear,@PriorMonth,@PriorYear
						
			DECLARE		--@ReportDate datetime = '6/27/2013',
						@DayOfWeek varchar(100),
						@BeginOfWeek Datetime,
						@BeginOfMonth Datetime,
						@BeginOfYear Datetime

			SET			@DayOfWeek = (SELECT DATENAME(dw,@ReportDate))
			SET			@BeginOfWeek =	(
											SELECT		CASE	WHEN @DayOfWeek = 'Sunday'		THEN DATEADD(dd,0,@ReportDate)
																WHEN @DayOfWeek = 'Monday'		THEN DATEADD(dd,-1,@ReportDate)
																WHEN @DayOfWeek = 'Tuesday'		THEN DATEADD(dd,-2,@ReportDate)
																WHEN @DayOfWeek = 'Wednesday'	THEN DATEADD(dd,-3,@ReportDate)
																WHEN @DayOfWeek = 'Thursday'	THEN DATEADD(dd,-4,@ReportDate)
																WHEN @DayOfWeek = 'Friday'		THEN DATEADD(dd,-5,@ReportDate)
																WHEN @DayOfWeek = 'Saturday'	THEN DATEADD(dd,-6,@ReportDate) END BeginOfWeek
										)

			SET			@BeginOfMonth = (
											SELECT		CONVERT(DATETIME,CONVERT(VARCHAR(100),DATEPART(MM,@ReportDate)) + '/1/' + CONVERT(VARCHAR(100),DATEPART(YY,@ReportDate)))
										)

			SET			@BeginOfYear = (
											SELECT		'1/1/' + CONVERT(VARCHAR(100),DATEPART(YY,@ReportDate))
										)
					SELECT		b.*,c.[Property Usage],d.MaritalStatus,d.Sex,d.Race,DATEDIFF(YY,d.DOB,@ReportDate) Age,
						CASE WHEN LoanDate >= @BeginOfWeek	AND LoanDate <= @ReportDate THEN		'WeekToDate'
						     WHEN LoanDate >= @BeginOfMonth AND LoanDate <= @ReportDate  THEN		'MonthToDate'
							 WHEN LoanDate >= @BeginOfYear  AND LoanDate <= @ReportDate THEN		'YearToDate' ELSE NULL END ToDate,
						CASE WHEN LoanDate >= @BeginOfWeek	AND LoanDate <= @ReportDate THEN		1
						     WHEN LoanDate >= @BeginOfMonth AND LoanDate <= @ReportDate  THEN		2
							 WHEN LoanDate >= @BeginOfYear  AND LoanDate <= @ReportDate THEN		3 ELSE NULL END ToDateOrder,
						CASE WHEN LoanAmount <= 100000 THEN 'Less Than $100k'
							 WHEN LoanAmount between 100000 AND 200000 THEN '$100k to $200k'
							 WHEN LoanAmount > 200000 THEN 'More Than $200k' END LoanAmountGroup,
						CASE WHEN LoanAmount <= 100000 THEN 1
							 WHEN LoanAmount between 100000 AND 200000 THEN 2
							 WHEN LoanAmount > 200000 THEN 3 END LoanAmountGroupOrder,
						CASE WHEN DATEDIFF(YY,d.DOB,@ReportDate) < 25 THEN '<=25'
							 WHEN DATEDIFF(YY,d.DOB,@ReportDate) between 25 and 35 THEN '26-35'
							 WHEN DATEDIFF(YY,d.DOB,@ReportDate) between 36 and 45 THEN '36-45'	
							 WHEN DATEDIFF(YY,d.DOB,@ReportDate) > 45 THEN '46+' END AgeGroup,
						CASE WHEN DATEDIFF(YY,d.DOB,@ReportDate) < 25 THEN 1
							 WHEN DATEDIFF(YY,d.DOB,@ReportDate) between 25 and 35 THEN 2
							 WHEN DATEDIFF(YY,d.DOB,@ReportDate) between 36 and 45 THEN 3
							 WHEN DATEDIFF(YY,d.DOB,@ReportDate) > 45 THEN 4 END AgeGroupOrder	
			INTO		#Financials	  
			FROM		dbo.Fact_Financials a
			LEFT JOIN	dbo.Dim_Loan b
			ON			a.Loan_ID = b.Loan_ID
			LEFT JOIN	Dim_Property c
			ON			a.Property_ID = c.Property_ID
			LEFT JOIN	dbo.Dim_Borrower d
			ON			a.Borrower_ID = d.Borrower_ID
			
			SELECT		*
			INTO		#FinancialsII
			FROM		#Financials
			WHERE		LoanAmountGroup IN (SELECT items FROM dbo.Split(@LoanAmount,','))
			AND			[Purpose of Loan] IN (SELECT items FROM dbo.Split(@LoanPurpose,','))
			AND			[Property Usage] IN (SELECT items FROM dbo.Split(@PropertyUsage,','))
			AND			(AgeGroup IN (SELECT items FROM dbo.Split(@Demographics2,','))
				OR		 MaritalStatus IN (SELECT items FROM dbo.Split(@Demographics2,','))
				OR		 Race IN (SELECT items FROM dbo.Split(@Demographics2,','))
				OR		 Sex IN (SELECT items FROM dbo.Split(@Demographics2,',')))
				
				SET			@MTD =	(
									SELECT		COUNT(*)  
									FROM		#FinancialsII
									WHERE		DATEPART(MM,LoanDate) = @CurrentMonth
									AND			DATEPART(YY,LoanDate) = @CurrentYear
									AND			LoanDate <= @ReportDate
									)

				SET			@MonthlyPrior6mnthAvg = 
									(
									SELECT		AVG(LoanCnt)
									FROM	(
											SELECT		TOP 6 DATEPART(MM,LoanDate) LoanMonth,DATEPART(YY,LoanDate) LoanYear,COUNT(*) LoanCnt
											FROM		#FinancialsII
											WHERE		CONVERT(VARCHAR(25),DATEPART(MM,LoanDate)) + CONVERT(VARCHAR(25),DATEPART(YY,LoanDate)) <> CONVERT(VARCHAR(25),@CurrentMonth) +  CONVERT(VARCHAR(25),@CurrentYear)
											AND		LoanDate <= @ReportDate	
											GROUP BY	DATEPART(MM,LoanDate),DATEPART(YY,LoanDate)	
											ORDER BY	DATEPART(YY,LoanDate) DESC,DATEPART(MM,LoanDate) DESC		
											) a
									)

				SET			@LastFullMonth = 
									(
									SELECT		AVG(LoanCnt)
									FROM	(
											SELECT		TOP 1 DATEPART(MM,LoanDate) LoanMonth,DATEPART(YY,LoanDate) LoanYear,COUNT(*) LoanCnt
											FROM		#FinancialsII
											WHERE		CONVERT(VARCHAR(25),DATEPART(MM,LoanDate)) + CONVERT(VARCHAR(25),DATEPART(YY,LoanDate)) <> CONVERT(VARCHAR(25),@CurrentMonth) +  CONVERT(VARCHAR(25),@CurrentYear)
											AND			LoanDate <= @ReportDate	
											GROUP BY	DATEPART(MM,LoanDate),DATEPART(YY,LoanDate)	
											ORDER BY	DATEPART(YY,LoanDate) DESC,DATEPART(MM,LoanDate) DESC		
											) a
									)

				SET			@MonthlyPrior6mnthAvgExcludeCurrMonth = 
									(
									SELECT		AVG(LoanCnt)
									FROM	(
											SELECT		TOP 6 DATEPART(MM,LoanDate) LoanMonth,DATEPART(YY,LoanDate) LoanYear,COUNT(*) LoanCnt
											FROM		#FinancialsII
											WHERE		(CONVERT(VARCHAR(25),DATEPART(MM,LoanDate)) + CONVERT(VARCHAR(25),DATEPART(YY,LoanDate)) <> CONVERT(VARCHAR(25),@CurrentMonth) +  CONVERT(VARCHAR(25),@CurrentYear)
											AND			CONVERT(VARCHAR(25),DATEPART(MM,LoanDate)) + CONVERT(VARCHAR(25),DATEPART(YY,LoanDate)) <> CONVERT(VARCHAR(25),@PriorMonth) +  CONVERT(VARCHAR(25),@PriorYear))
											AND			LoanDate <= @ReportDate	
											GROUP BY	DATEPART(MM,LoanDate),DATEPART(YY,LoanDate)	
											ORDER BY	DATEPART(YY,LoanDate) DESC,DATEPART(MM,LoanDate) DESC
											) a
									)	

				SET			@QTD = 	
									(						
									SELECT		LoanCnt
									FROM		
											(		
											SELECT		TOP 1 DATEPART(QQ,LoanDate) LoanQuarter,DATEPART(YY,LoanDate) LoanYear,COUNT(*) LoanCnt
											FROM		#FinancialsII
											WHERE		CONVERT(VARCHAR(25),DATEPART(QQ,LoanDate)) + CONVERT(VARCHAR(25),DATEPART(YY,LoanDate)) = CONVERT(VARCHAR(25),@CurrentQuarter) +  CONVERT(VARCHAR(25),@CurrentYear)
											AND			LoanDate <= @ReportDate	
											GROUP BY	DATEPART(QQ,LoanDate),DATEPART(YY,LoanDate)	
											ORDER BY	DATEPART(YY,LoanDate) DESC,DATEPART(QQ,LoanDate) DESC	
											)	a
									)
																		
				SET			@LastFullQuarter = 	
									(						
									SELECT		LoanCnt
									FROM		
											(		
											SELECT		TOP 1 DATEPART(QQ,LoanDate) LoanQuarter,DATEPART(YY,LoanDate) LoanYear,COUNT(*) LoanCnt
											FROM		#FinancialsII
											WHERE		CONVERT(VARCHAR(25),DATEPART(QQ,LoanDate)) + CONVERT(VARCHAR(25),DATEPART(YY,LoanDate)) <> CONVERT(VARCHAR(25),@CurrentQuarter) +  CONVERT(VARCHAR(25),@CurrentYear)
											AND		LoanDate <= @ReportDate	
											GROUP BY	DATEPART(QQ,LoanDate),DATEPART(YY,LoanDate)	
											ORDER BY	DATEPART(YY,LoanDate) DESC,DATEPART(QQ,LoanDate) DESC	
											)	a
									)	
									
												
				SELECT		@MTD MTD,@MonthlyPrior6mnthAvg MonthlyPrior6mnthAvg,((@MTD *1.00)/@MonthlyPrior6mnthAvg) * 100 MTDvsMonthlyPrior6mnthAvg_PerInc,
							@LastFullMonth LastFullMonth,@MonthlyPrior6mnthAvgExcludeCurrMonth MonthlyPrior6mnthAvgExcludeCurrMonth,((@LastFullMonth *1.00)/@MonthlyPrior6mnthAvgExcludeCurrMonth) * 100 LastFullMonthvsMonthlyPrior6mnthExcludeCurrMonth_Avg_PerInc,
							@QTD QTD,@LastFullQuarter LastFullQuarter,((@QTD *1.00)/@LastFullQuarter) * 100 QTDvsLastFullQuarter
							
					
			
	END
	
/*

SELECT		DATEPART(MM,LoanDate) LoanMonth,DATEPART(YY,LoanDate) LoanYear,COUNT(*) LoanCnt
FROM		dbo.Fact_Financials a
LEFT JOIN	dbo.Dim_Loan b
ON			a.Loan_ID = b.Loan_ID
LEFT JOIN	Dim_Property c
ON			a.Property_ID = c.Property_ID
LEFT JOIN	dbo.Dim_Borrower d
ON			a.Borrower_ID = d.Borrower_ID
WHERE		LoanDate <= @ReportDate	
GROUP BY	DATEPART(MM,LoanDate),DATEPART(YY,LoanDate)	
ORDER BY	DATEPART(YY,LoanDate) DESC,DATEPART(MM,LoanDate) DESC		
							
SELECT		DATEPART(QQ,LoanDate) LoanQuarter,DATEPART(YY,LoanDate) LoanYear,COUNT(*) LoanCnt
FROM		dbo.Fact_Financials a
LEFT JOIN	dbo.Dim_Loan b
ON			a.Loan_ID = b.Loan_ID
LEFT JOIN	Dim_Property c
ON			a.Property_ID = c.Property_ID
LEFT JOIN	dbo.Dim_Borrower d
ON			a.Borrower_ID = d.Borrower_ID
WHERE		LoanDate <= @ReportDate	
GROUP BY	DATEPART(QQ,LoanDate),DATEPART(YY,LoanDate)	
ORDER BY	DATEPART(YY,LoanDate) DESC,DATEPART(QQ,LoanDate) DESC							


SELECT		DATEPART(MM,LoanDate) LoanMonth,DATEPART(YY,LoanDate) LoanYear,
			AVG(CONVERT(DECIMAL(10,2),MonthlyIncome)) AvgMonthlyIncome,AVG(CONVERT(DECIMAL(10,2),LoanAmount)) AvgLoanAmount,
			SUM(CONVERT(DECIMAL(10,2),MonthlyIncome) / CONVERT(DECIMAL(10,2),LoanAmount)) MonthlyIncomeVSLoanAmount
FROM		[Mortgage].[dbo].[Fact_Financials] a
LEFT JOIN	dbo.Dim_Loan b
ON			a.Loan_ID = b.Loan_ID
LEFT JOIN	Dim_Property c
ON			a.Property_ID = c.Property_ID
LEFT JOIN	dbo.Dim_Borrower d
ON			a.Borrower_ID = d.Borrower_ID
WHERE		LoanDate <= '6/25/2013'	
GROUP BY	DATEPART(MM,LoanDate),DATEPART(YY,LoanDate)
ORDER BY	DATEPART(YY,LoanDate) DESC,DATEPART(MM,LoanDate) DESC

SELECT		DATEPART(QQ,LoanDate) LoanQuarter,DATEPART(YY,LoanDate) LoanYear,
			AVG(CONVERT(DECIMAL(10,2),MonthlyIncome)) AvgMonthlyIncome,AVG(CONVERT(DECIMAL(10,2),LoanAmount)) AvgLoanAmount,
			SUM(CONVERT(DECIMAL(10,2),MonthlyIncome) / CONVERT(DECIMAL(10,2),LoanAmount)) MonthlyIncomeVSLoanAmount
FROM		[Mortgage].[dbo].[Fact_Financials] a
LEFT JOIN	dbo.Dim_Loan b
ON			a.Loan_ID = b.Loan_ID
LEFT JOIN	Dim_Property c
ON			a.Property_ID = c.Property_ID
LEFT JOIN	dbo.Dim_Borrower d
ON			a.Borrower_ID = d.Borrower_ID
WHERE		LoanDate <= '6/25/2013'	
GROUP BY	DATEPART(QQ,LoanDate),DATEPART(YY,LoanDate)
ORDER BY	DATEPART(YY,LoanDate) DESC,DATEPART(QQ,LoanDate) DESC
*/