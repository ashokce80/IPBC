USE [Mortgage]
GO
/****** Object:  StoredProcedure [dbo].[proc_LoansProcessed_ToDate]    Script Date: 06/29/2013 17:48:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE	[dbo].[proc_LoansProcessed_ToDate]    --EXEC proc_LoansProcessed_ToDate '6/25/2013'
	
	@ReportDate Datetime,
	@LoanAmount varchar(max) = null,
	@LoanPurpose varchar(max) = null,
	@PropertyUsage varchar(max) = null,
	@Demographics2 varchar(max)	= null
	
	AS
		BEGIN
		
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

			SELECT		b.*,c.[Property Usage],d.MaritalStatus,d.Sex,d.Race,DATEDIFF(YY,d.DOB,@ReportDate) Age,BorrowerFirstName + ' ' + BorrowerLastName BorrowerName,MonthlyIncome,
						DATENAME(MONTH,LoanDate) + ' ' + CONVERT(VARCHAR(10),DATEPART(YY,LoanDate)) FormatedReportMonth,LoanAmount,[Purchase Price],
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
			WHERE		LoanDate <= @ReportDate
			
			SELECT		*
			FROM		#Financials
			--/*
			WHERE		LoanAmountGroup IN (SELECT items FROM dbo.Split(@LoanAmount,','))
			AND			[Purpose of Loan] IN (SELECT items FROM dbo.Split(@LoanPurpose,','))
			AND			[Property Usage] IN (SELECT items FROM dbo.Split(@PropertyUsage,','))
			AND			(AgeGroup IN (SELECT items FROM dbo.Split(@Demographics2,','))
				OR		 MaritalStatus IN (SELECT items FROM dbo.Split(@Demographics2,','))
				OR		 Race IN (SELECT items FROM dbo.Split(@Demographics2,','))
				OR		 Sex IN (SELECT items FROM dbo.Split(@Demographics2,',')))
			--*/
		END
		
		
