Use Mortgage_DW
Go

Alter Proc UDF_SP_LoanGuage

@ReportDate date,
@LoanAmount varchar(max) = NULL,
@LoanPurpose varchar(max) = NULL,
@PropertyUsage varchar(max) = Null,
@Demographics2 varchar(max) = Null
As
Begin

	--drop table	#Financials 
	--drop table	#Financials2
	Declare	@CurrentMonth int,
			@CurrentYear int,
			@PriorMonth int,
			@PriorYear int,
			@CurrentQuarter int,
			@MTD int,
			@QTD int,
			@LastFullMonth int,
			@Prior6MonthAvg int,
			@Prior6MonthAvgExcludeCurrMonth int,
			@LastFullQuarter int
			--,@ReportDate datetime = getdate() - 15 --Comment it later one

	Set		@CurrentMonth = DATEPART(MM,@ReportDate)
	Set		@CurrentYear = DatePart(YY,@ReportDate)
	Set		@CurrentQuarter = DATEPART(QQ,@ReportDate)
	Set		@PriorMonth = DATEPART(MM, DATEADD(MM,-1,@ReportDate))
	Set		@PriorYear = DATEPART(YY,DATEADD(YY,-1,@ReportDate)) 
						--(			Select Case when DATEPART(MM, DATEADD(MM,-1,@ReportDate)) = 1 Then DATEPART(YY,DATEADD(YY,-1,@ReportDate)) else @CurrentYear			End			)
	--Select	@CurrentMonth,@CurrentYear,@PriorMonth,@PriorYear
	
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
				,DATEDIFF(YY,[Date of Birth],@ReportDate) As Age 
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
	Where		[Loan Date] <= @ReportDate



	Select		*
	Into		#Financials2
	From		#Financials 
	Where		LoanAmountGroup in (
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
	
	Set			@MTD = (
						Select Count(*)
						From	#Financials2
						Where	DATEPART(MM,[Loan Date]) = @CurrentMonth
						And		DATEPART(YY,[Loan Date]) = @CurrentYear
						And		[Loan Date] <= @ReportDate
						)
	Set			@Prior6MonthAvg = (Select avg(LoanCount) From (
				
				Select top 6 DATEPART(MM,[Loan Date]) as LoanMonth, DATEPART(YY,[Loan Date]) as LoanYear, Count(*) as LoanCount
				From		#Financials2
				Where		
				Convert(Varchar(20),DATEPART(MM,[Loan Date])) + 
				Convert(Varchar(20),DATEPART(YY,[Loan Date])) 
				<> Convert(Varchar(20),@CurrentMonth) + 
					Convert(Varchar(20),@CurrentYear)
				And			[Loan Date] <= @ReportDate
				Group by	DATEPART(MM,[Loan Date]), DATEPART(YY,[Loan Date])
				Order by	DATEPART(YY,[Loan Date]) desc,DATEPART(MM,[Loan Date])					desc
				) As A
				)
	Set			@LastFullMonth = (Select avg(LoanCount) From (
				
				Select top 1 DATEPART(MM,[Loan Date]) as LoanMonth, DATEPART(YY,[Loan Date]) as LoanYear, Count(*) as LoanCount
				From		#Financials2
				Where		
				Convert(Varchar(20),DATEPART(MM,[Loan Date])) + 
				Convert(Varchar(20),DATEPART(YY,[Loan Date])) 
				<> Convert(Varchar(20),@CurrentMonth) + 
					Convert(Varchar(20),@CurrentYear)
				And			[Loan Date] <= @ReportDate
				Group by	DATEPART(MM,[Loan Date]), DATEPART(YY,[Loan Date])
				Order by	DATEPART(YY,[Loan Date]) desc,DATEPART(MM,[Loan Date])					desc
				) As B
				)
	Set			@Prior6MonthAvgExcludeCurrMonth = (Select avg(LoanCount) From (
				
				Select top 6 DATEPART(MM,[Loan Date]) as LoanMonth, DATEPART(YY,[Loan Date]) as LoanYear, Count(*) as LoanCount
				From		#Financials2
				Where		
				Convert(Varchar(20),DATEPART(MM,[Loan Date])) + 
				Convert(Varchar(20),DATEPART(YY,[Loan Date])) 
				<> Convert(Varchar(20),@CurrentMonth) + 
					Convert(Varchar(20),@CurrentYear)
				And	
				Convert(Varchar(20),DATEPART(MM,[Loan Date])) + 
				Convert(Varchar(20),DATEPART(YY,[Loan Date])) 
				<> Convert(Varchar(20),@PriorMonth) + 
					Convert(Varchar(20),@PriorYear)
				And			[Loan Date] <= @ReportDate
				Group by	DATEPART(MM,[Loan Date]), DATEPART(YY,[Loan Date])
				Order by	DATEPART(YY,[Loan Date]) desc,DATEPART(MM,[Loan Date])					desc
				) As C
				)
	Set			@QTD = ( Select		LoanCnt From (
						Select	top 1 DATEPART(QQ,[Loan Date]) LoanQuarter, DATEPART(YY,[Loan Date]) LoanYear, Count(*) as LoanCnt
						From	#Financials2
						Where	Convert(varchar(20),datepart(QQ,[Loan Date])) +
								Convert(varchar(20),DATEPART(yy,[Loan Date]))
								= 
								Convert(varchar(20),@CurrentQuarter) +
								Convert(varchar(20),@CurrentYear)
						And		[Loan Date] <= @ReportDate
						Group by 
							DATEPART(YY,[Loan Date]), DATEPART(QQ,[Loan Date])
						Order by
							DATEPART(YY,[Loan Date]) desc, 
							DATEPART(QQ,[Loan Date]) desc
						) as A
						)
	Set			@LastFullQuarter = ( Select		LoanCnt From (
						Select	top 1 DATEPART(QQ,[Loan Date]) LoanQuarter, DATEPART(YY,[Loan Date]) LoanYear, Count(*) as LoanCnt
						From	#Financials2
						Where	Convert(varchar(20),datepart(QQ,[Loan Date])) +
								Convert(varchar(20),DATEPART(yy,[Loan Date]))
								<> 
								Convert(varchar(20),@CurrentQuarter) +
								Convert(varchar(20),@CurrentYear)
						And		[Loan Date] <= @ReportDate
						Group by 
							DATEPART(YY,[Loan Date]), DATEPART(QQ,[Loan Date])
						Order by
							DATEPART(YY,[Loan Date]) desc, 
							DATEPART(QQ,[Loan Date]) desc
						) as A
						)
	
	--we need to show data in guage as % so need to result is * by 100					--Find MTDvsPrior6MonthAvg_Perg
	Select @MTD as MonthToDateLoanCnt ,@Prior6MonthAvg as Prior6MonthAvg
			,Convert(Decimal(10,0),((@MTD * 1.00)/@Prior6MonthAvg ) * 100 ) as MTDvsPrior6MonthAvg_Perg
			
			--Find LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg
			,@LastFullMonth as LastFullMonth , @Prior6MonthAvgExcludeCurrMonth as Prior6MonthAvgExcludeCurrMonth
			,Convert(Decimal(10,0),((@LastFullMonth * 1.00)/@Prior6MonthAvgExcludeCurrMonth ) * 100 )as LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg
				
			--Find QTDvsLastFullQuarter			
			,@QTD as QTD,@LastFullQuarter as LastFullQuarterExcludeCurrQuarter
			,Convert(Decimal(10,0),((@QTD * 1.00)/@LastFullQuarter ) * 100 )
			as QTDvsLastFullQuarterExcludeCurrQuarter

	/*Select		Convert(Varchar(20),DATEPART(MM,[Loan Date])) + 
				Convert(Varchar(20),DATEPART(YY,[Loan Date])) ,
				Convert(Varchar(20),@CurrentMonth) + 
					Convert(Varchar(20),@CurrentYear)
	From		#Financials2
	Where		[Loan Date] <= @ReportDate*/
End

/*

				@CurrentMonth int,
				@CurrentYear int,
				@PriorMonth int,
				@PriorYear int,
				@CurrentQuarter int,
			    @MTD int,
				@QTD int,
				@LastFullMonth int,
			    @Prior6MonthAvg int,
				@Prior6MonthAvgExcludeCurrMonth int,
			@LastFullQuarter int,

Exec 
UDF_SP_LoanProcessed_ToDate
'08/03/2019','Less Than $100K,$100k to $200K', 'Construction,Purchase','Investment,PrimaryResidence,SecondHome'
	/*Select		*
	From		#Financials*/

	
	--drop table	#Financials
	
Select	datepart(qq,getdate()-45) --shows quarter 1,2,3or4

Exec UDF_SP_LoanGuage
--for directional images
=Switch(
	Sum(Fields!LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg.Value,"LoanGuages") <= 50, "Arrow_Red_15"
	,Sum(Fields!LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg.Value, "LoanGuages") > 50 
	And Sum(Fields!LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg.Value, "LoanGuages") <= 75, "Arrow_Yellow_15"
	,Sum(Fields!LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg.Value, "LoanGuages") > 75, "Arrow_Green_15")
 )

 =Switch(Sum(Fields!LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg.Value, "LoanGuages") <= 50, "Arrow_Red_15", Sum(Fields!LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg.Value, "LoanGuages") > 50 And Sum(Fields!LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg.Value, "LoanGuages") <= 75, "Arrow_Yellow_15", Sum(Fields!LastFullMonthvsPrior6MonthAvgExcludeCurrMonthAVG_Perg.Value, "LoanGuages") > 75, "Arrow_Green_15")

 =Switch(Sum(Fields!QTDvsLastFullQuarterExcludeCurrQuarter.Value, "LoanGuages") <= 50, "Arrow_Red_15", Sum(Fields!QTDvsLastFullQuarterExcludeCurrQuarter.Value, "LoanGuages") > 50 And Sum(Fields!QTDvsLastFullQuarterExcludeCurrQuarter.Value, "LoanGuages") <= 75, "Arrow_Yellow_15", Sum(Fields!QTDvsLastFullQuarterExcludeCurrQuarter.Value, "LoanGuages") > 75, "Arrow_Green_15")

*/
