Select	DATENAME(dw,getdate())
Select	DATEADD(dd,-5,getdate())
Select	getdate()

Begin Transaction
Update 	Dim_Loan
Set		[Loan Date] =  Convert(datetime,Convert(varchar(50),DATEPART(yyyy,getdate()))+'/'+  
Convert(varchar(50),DATEPART(MM,[Loan Date]))  +'/'+
Convert(varchar(50),DATEPART(dd,[Loan Date])))
Commit
Select *
From	Dim_Loan



	Declare 
		@LDate date,
		@RDate date = getdate(),
		@BOfMonth date

	Set @BOfMonth = (Select Convert(DATE,Convert(Varchar								(50),DATEPART(MM,@RDate))+'/1/'+ Convert					(varchar(50),DATEPART(YY,@RDate))))
	set @LDate = (Select [Loan Date] from Dim_Loan where LoanKey = 49)
	Select	@LDate
	Select  @RDate
	Select  @BOfMonth

	if(@LDate <= @BOfMonth and @LDate <= @RDate)
	Begin	
			Select	'loand date < biginofmonth and < reportdate'
	End

	/* Select		[Loan Date]
	From		Dim_Loan
	Where		[Loan Date] >= '07/28/2019' 
	
	Select		*
	From		#Financials
	where		ToDateOrder = 1
	--Select	([Loan Date] >= @BiginOfWeek)*/

		Select		ToDate,ToDateOrder,Count(*) countforIT
	From		#Financials
	Group by	ToDate,ToDateOrder

If( @ReportDate >= @BiginOfMonth)
		Begin	
			Select	'LoanDate >= this month ,,,,,'
		End
--- get all load datas for report date to select default we need most recent one so use order by desc
SELECT 		DISTINCT CONVERT(VARCHAR(13), [Loan Date],101) AS LoanDate
FROM     	Dim_Loan
ORDER BY 	CONVERT(VARCHAR(13), [Loan Date],101) DESC

Select		[Loan Date]
FROM     	Dim_Loan
