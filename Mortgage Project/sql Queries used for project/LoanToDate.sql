Use Mortgage_DW
Go

Alter Proc UDF_SP_LoanProcessed_ToDate
/*
Ashok
LoanProcessed to date 
note: to get different part of time frame to get loan date and loan count
*/
@ReportDate date,
@LoanAmount varchar(max) = NULL,
@LoanPurpose varchar(max) = NULL,
@PropertyUsage varchar(max) = Null,
@Demographics2 varchar(max) = Null 
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
	
	Select		L.*,P.[Property Usage],B.[Marital Status],B.[Sex],B.[Race]
				,[Borrower FirstName]+' '+[Borrower LastName] as BorrwerName
				,[MonthlyIncome],[LoanAmount],[Purchase Price]
				--,DateName(Month,[Loan Date])+' '+ Convert(varchar(10),DATEPART(YYYY,[Loan Date])) as FormattedReportMonth
				,DATEDIFF(YY,[Date of Birth],@ReportDate) As Age
				,Case When DatePart(YYYY,[Loan Date]) = DatePart(YYYY,@ReportDate) 
						Then DateName(Month,[Loan Date])+' '+ Convert(varchar(10),DATEPART(YYYY,[Loan Date]))
						End FormattedReportMonth
				,CASE when [Loan Date] >= @BiginOfWeek AND 
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
						End		LoanAmountGroupOrder,
				Case	When	DATEDIFF(yy,[Date of Birth],@ReportDate) < 25 
						then	'<=25'
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) between		26 and 35 then '26-35'
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) between		36 and 45 then '36-45'
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) > 46 
						then '46+'
						End		AgeGroup,
				Case	When	DATEDIFF(yy,[Date of Birth],@ReportDate) < 25 
						then	1
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) between		26 and 35 then 2
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) between		36 and 45 then 3
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) > 45 
						then	4
						End		AgeGroupOrder
	Into		#Financials
	From		[dbo].[Fact_Financials] as F
	Left join	[dbo].[Dim_Loan] as L
	On			F.[LoanKey] = L.[LoanKey]
	Left join	[dbo].[Dim_Property] as P
	On			F.[PropertyKey] = P.[PropertyKey]
	Left join	[dbo].[Dim_Borrower] as B
	On			F.BorrowerKey = B.BorrowerKey
	Where		DatePart(YYYY,[Loan Date]) = DatePart(YYYY,@ReportDate)
				And  [Loan Date] <= @ReportDate



	Select		*
	From		#Financials 
	Where		DatePart(YYYY,[Loan Date]) = DatePart(YYYY,@ReportDate)				  And
				LoanAmountGroup in (
				Select items From dbo.Split(@LoanAmount,',')) 
				AND	
				[Purpose of Loan] in (
				Select items from dbo.split(@LoanPurpose,',')) 
				AND
				[Property Usage] in (
				Select	items from	dbo.split(@PropertyUsage,','))
				ANd
				AgeGroup in (
				Select	items from	dbo.split(@Demographics2,','))
				OR
				[Marital Status] in (
				Select	items from	dbo.split(@Demographics2,','))
				OR
				[Sex] in (
				Select items from dbo.split(@Demographics2,','))
				OR
				[Race] in (
				Select items from dbo.Split(@Demographics2,''))

End

/*
Exec 
UDF_SP_LoanProcessed_ToDate
'08/03/2019','Less Than $100K,$100k to $200K', 'Construction,Purchase','Investment,PrimaryResidence,SecondHome'
	/*Select		*
	From		#Financials*/

	
	--drop table	#Financials
	
	
Declare @ReportDate date = getdate()
Select	Distinct	'Age' DemographicGroup,
					Case	When	DATEDIFF(yy,[Date of Birth],@ReportDate) < 25 
						then	'<=25'
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) between		26 and 35 then '26-35'
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) between		36 and 45 then '36-45'
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) > 46 
						then '46+'
						End		Lable,
				Case	When	DATEDIFF(yy,[Date of Birth],@ReportDate) < 25 
						then	1
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) between		26 and 35 then 2
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) between		36 and 45 then 3
						When	DATEDIFF(yy,[Date of Birth],@ReportDate) > 45 
						then	4
						End		LableOrder
Into					#demoTbl
From					[dbo].[Dim_Borrower] as B
Union		
Select					'Marital Status', [Marital Status], 1
From					[dbo].[Dim_Borrower]
Union
Select					'Race', [Race], 1
From					[dbo].[Dim_Borrower]
Union
Select					'Sex', [Sex], 1
From					[dbo].[Dim_Borrower]

Select			*, DemographicGroup+'-'+Lable as RealLable
From			#demoTbl
Where			DemographicGroup in (@DemographicGroups)

Select	DateName(Month,getdate())
Select DateName(Month,getdate())+' '+ Convert(varchar(10),DATEPART(YYYY,getdate()))


--- indicator for detail report
=Switch((Fields!MonthlyIncome.Value/Fields!LoanAmount.Value)*100 > 10, "Arrow_Green_15"
,(Fields!MonthlyIncome.Value/Fields!LoanAmount.Value)*100 >= 7
And (Fields!MonthlyIncome.Value/Fields!LoanAmount.Value)*100 <= 10, "Arrow_Yellow_15"
,(Fields!MonthlyIncome.Value/Fields!LoanAmount.Value)*100 < 7, "Arrow_Red_15")
*/
