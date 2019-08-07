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

Select		*
FROM     	Dim_Loan

Select Distinct	[LoanAmount]
From			[dbo].[Fact_Financials]


Select Distinct	[Purpose of Loan]
From			[dbo].[Dim_Loan]

SELECT DISTINCT CONVERT(varchar(15), LoanAmount) AS Expr1
FROM   Fact_Financials

Alter FUNCTION [dbo].[Split]
(
    @String NVARCHAR(4000),
    @Delimiter NCHAR(1)
)
RETURNS TABLE
AS
RETURN
(
    WITH Split(stpos,endpos)
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        'items' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
    FROM Split
)
GO


Select items From dbo.Split('Less Than $100K,$100k to $200K',',')

Select		distinct [Property Usage]
From		[dbo].[Dim_Property] 
Order by	[Property Usage]

Investment,PrimaryResidence,SecondHome

SELECT 'WeekToDate' ToDate, 1 SortORDER
UNION
SELECT 'MonthToDate', 2
UNION
SELECT 'YearToDate', 3
ORDER BY SortORDER

Select	Datediff(mm,'05/10/2019',getdate())

Update		[dbo].[Dim_Borrower]
Set			[Marital Status] = 'Divorced'
Where		[Marital Status] = 'Divorsed'


Select	DATEDIFF(yy,[Date of Birth],getdate())
From	[dbo].[Dim_Borrower]

Declare  @ReportDate date = getdate()
SELECT DISTINCT    'Age' DemographicGroup, 
					CASE WHEN DATEDIFF(YY, [Date of Birth], @ReportDate) < 25 THEN '<=25' WHEN DATEDIFF(YY, [Date of Birth], @ReportDate) BETWEEN 25 AND 
                  35 THEN '26-35' WHEN DATEDIFF(YY, [Date of Birth], @ReportDate) BETWEEN 36 AND 45 THEN '36-45' WHEN DATEDIFF(YY, [Date of Birth], @ReportDate) > 45 THEN '46+' END Label, 
                  CASE WHEN DATEDIFF(YY, [Date of Birth], @ReportDate) < 25 THEN 1 WHEN DATEDIFF(YY, [Date of Birth], @ReportDate) BETWEEN 25 AND 35 THEN 2 WHEN DATEDIFF(YY, [Date of Birth], 
                  @ReportDate) BETWEEN 36 AND 45 THEN 3 WHEN DATEDIFF(YY, [Date of Birth], @ReportDate) > 45 THEN 4 END GroupOrder
INTO        #Demo2
FROM     [dbo].[Dim_Borrower]
UNION
SELECT DISTINCT 'Marital Status', [Marital Status], 1
FROM     [dbo].[Dim_Borrower]
UNION
SELECT DISTINCT 'Race', Race, 1
FROM     [dbo].[Dim_Borrower]
UNION
SELECT DISTINCT 'Sex', Sex, 1
FROM     [dbo].[Dim_Borrower]

                      SELECT   *,DemographicGroup + ' - ' + Label RealLabel
                      FROM     #Demo2
                      WHERE  DemographicGroup IN (@Demographics1)
                      ORDER BY DemographicGroup, GroupOrder