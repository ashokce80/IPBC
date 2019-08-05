Use Mortgage_DW
Go

Alter Proc UDF_SP_LoanProcessed_ToDate

@ReportDate date,
@LoanAmount varchar(max) = NULL,
@LoanPurpose varchar(max) = NULL,
@PropertyUsage varchar(max) = Null

As
Begin
	
	--drop table	#Financials
	Declare
			--@ReportDate datetime = getdate() - 15, -- comment this line later
			@DayOfWeek varchar(50),
			@BiginOfWeek date,
			@BiginOfMonth date,
			@BiginOfYear date

	Set		@DayOfWeek = (Select DATENAME(dw,@ReportDate))--replace getdate with @reportDate later at SSRS time
	Set		@BiginOfWeek = (
			Select Case 
			When @DayOfWeek = 'Sunday' then DATEADD(dd,0,@ReportDate)
			When @DayOfWeek = 'Monday' then DATEADD(dd,-1,@ReportDate)
			When @DayOfWeek = 'Tuesday' then DATEADD(dd,-2,@ReportDate)
			When @DayOfWeek = 'Wednesday' then DATEADD(dd,-3,@ReportDate)
			When @DayOfWeek = 'Thursday' then DATEADD(dd,-4,@ReportDate)
			When @DayOfWeek = 'Friday' then DATEADD(dd,-5,@ReportDate)
			When @DayOfWeek = 'Saturday' then DATEADD(dd,-6,@ReportDate)
			End BiginOfWeek)
	Set		@BiginOfMonth =(Select Convert(DATE,Convert(Varchar								(50),DATEPART(MM,@ReportDate))+'/1/'+ Convert					(varchar(50),DATEPART(YY,@ReportDate))))
	--Select	@BiginOfMonth

	Set		@BiginOfYear = (
							Select Convert(DATE,'1/1/' + 
							Convert(varchar(10),DATEPART							(yy,@ReportDate)))
							)
	--Select	@BiginOfYear
	
	Select		L.*,P.[Property Usage],
				CASE when [Loan Date] >= @BiginOfWeek AND 
								[Loan Date] <= @ReportDate
							Then	'WeekToDate'
					when [Loan Date] >= @BiginOfMonth AND 
								[Loan Date] <= @ReportDate
							Then	'MonthToDate'
					when [Loan Date] >= @BiginOfYear AND 
								[Loan Date] <= @ReportDate
							Then	'YearToDate'
					Else Null 
					End ToDate,
					
				CASE	when [Loan Date] >= @BiginOfWeek AND 
								[Loan Date] <= @ReportDate
							Then	1
						when [Loan Date] >= @BiginOfMonth AND 
								[Loan Date] <= @ReportDate
							Then	2
						when [Loan Date] >= @BiginOfYear AND 
								[Loan Date] <= @ReportDate
							Then	3
						Else Null 
				End ToDateOrder,
					
				Case	When	LoanAmount <= 100000 
						Then 'Less Than $100K'
						When	LoanAmount Between 100000 And 200000 
						Then '$100k to $200K'
						When	LoanAmount	> 200000 
						Then 'More Than $200K'
						End		LoanAmountGroup,
				Case	When	LoanAmount <= 100000 Then 1
						When	LoanAmount Between 100000 And 200000 Then         2
						When	LoanAmount	> 200000 Then 3
						End		LoanAmountGroupOrder

	Into		#Financials
	From		[dbo].[Fact_Financials] as F
	Left join	[dbo].[Dim_Loan] as L
	On			F.[LoanKey] = L.[LoanKey]
	Left join	[dbo].[Dim_Property] as P
	On			F.[PropertyKey] = P.[PropertyKey]
	Where		[Loan Date] <= @ReportDate



	Select		*
	From		#Financials 
	Where		LoanAmountGroup in (
				Select items From dbo.Split(@LoanAmount,',')) 
				AND	
				[Purpose of Loan] in (
				Select items from dbo.split(@LoanPurpose,',')) 
				AND
				[Property Usage] in (
				Select	items from	dbo.split(@PropertyUsage,',')) 

End

/*
Exec 
UDF_SP_LoanProcessed_ToDate
'08/03/2019','Less Than $100K,$100k to $200K', 'Construction,Purchase','Investment,PrimaryResidence,SecondHome'
	/*Select		*
	From		#Financials*/

	
	--drop table	#Financials
	
	*/
