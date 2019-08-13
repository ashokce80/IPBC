---this file is for creating pk and fk in dims and fact so we can use them in creating cube later in ssas

Select		*
From		[dbo].[Dim_Loan] as L
left join	[dbo].[Fact_Financials] as F
On			L.LoanKey = F.LoanKey
Order by	L.LoanKey, F.LoanKey

Select		*
From		[dbo].[Fact_Financials]

Alter Table	[dbo].[Fact_Financials]
Add		Foreign key ([PropertyKey]) References [dbo].[Dim_Property]([PropertyKey])

-- creating fullname for customers in borrows dim for cube
Select		*--[Borrower FirstName]+' '+[Borrower LastName]
From		[dbo].[Dim_Borrower]

Select		Datediff(YYYY,[Date of Birth],[Loan Date]) as Age
			,L.LoanKey,B.BorrowerKey
From		[dbo].[Dim_Borrower] B
Left join	[dbo].[Fact_Financials] F
On			B.BorrowerKey = F.BorrowerKey
Left join	[dbo].[Dim_Loan] as L
On			F.LoanKey = L.LoanKey
Where		B.[Dim_B_Current] = 'Yes'

Create database Mortgage_Project_SSAS_CUBE

Select	[Loan Date]  
From	[dbo].[Dim_Loan]

Select	*
From	[dbo].[Time]

Select		L.[Loan Date],T.PK_Date
From		[dbo].[Time] T
left join	[dbo].[Dim_Loan] L
On			T.PK_Date = L.[Loan Date]
Where		L.[Loan Date] is not NULL


Alter table [dbo].[Fact_Financials]
Add		[PK_Date] date 

Select	*
From	[dbo].[Fact_Financials]

----------- query by creating cube in ssas
SELECT [dbo_Fact_Financials].[dbo_Fact_FinancialsSSN0_0] AS [dbo_Fact_FinancialsSSN0_0],[dbo_Fact_Financials].[dbo_Fact_FinancialsLoanAmount0_1] AS [dbo_Fact_FinancialsLoanAmount0_1],[dbo_Fact_Financials].[dbo_Fact_FinancialsPurchase_x0020_Price0_2] AS [dbo_Fact_FinancialsPurchase_x0020_Price0_2],[dbo_Fact_Financials].[dbo_Fact_FinancialsMonthlyIncome0_3] AS [dbo_Fact_FinancialsMonthlyIncome0_3],[dbo_Fact_Financials].[dbo_Fact_FinancialsBonuses0_4] AS [dbo_Fact_FinancialsBonuses0_4],[dbo_Fact_Financials].[dbo_Fact_FinancialsCommission0_5] AS [dbo_Fact_FinancialsCommission0_5],[dbo_Fact_Financials].[dbo_Fact_FinancialsOtherIncome0_6] AS [dbo_Fact_FinancialsOtherIncome0_6],[dbo_Fact_Financials].[dbo_Fact_FinancialsChecking0_7] AS [dbo_Fact_FinancialsChecking0_7],[dbo_Fact_Financials].[dbo_Fact_FinancialsSavings0_8] AS [dbo_Fact_FinancialsSavings0_8],[dbo_Fact_Financials].[dbo_Fact_Financials0_9] AS [dbo_Fact_Financials0_9],[dbo_Fact_Financials].[dbo_Fact_FinancialsPropertyKey0_10] AS [dbo_Fact_FinancialsPropertyKey0_10],[dbo_Fact_Financials].[dbo_Fact_FinancialsLoanKey0_11] AS [dbo_Fact_FinancialsLoanKey0_11],[dbo_Fact_Financials].[dbo_Fact_FinancialsBorrowerKey0_12] AS [dbo_Fact_FinancialsBorrowerKey0_12]
FROM 
(

SELECT [SSN] AS [dbo_Fact_FinancialsSSN0_0],[LoanAmount] AS [dbo_Fact_FinancialsLoanAmount0_1],[Purchase Price] AS [dbo_Fact_FinancialsPurchase_x0020_Price0_2],[MonthlyIncome] AS [dbo_Fact_FinancialsMonthlyIncome0_3],[Bonuses] AS [dbo_Fact_FinancialsBonuses0_4],[Commission] AS [dbo_Fact_FinancialsCommission0_5],[OtherIncome] AS [dbo_Fact_FinancialsOtherIncome0_6],[Checking] AS [dbo_Fact_FinancialsChecking0_7],[Savings] AS [dbo_Fact_FinancialsSavings0_8],1   AS [dbo_Fact_Financials0_9],[PropertyKey] AS [dbo_Fact_FinancialsPropertyKey0_10],[LoanKey] AS [dbo_Fact_FinancialsLoanKey0_11],[BorrowerKey] AS [dbo_Fact_FinancialsBorrowerKey0_12]
FROM [dbo].[Fact_Financials]
)
 AS [dbo_Fact_Financials]
 ----------- query by creating cube in ssas with time dim as snowflack
 SELECT [dbo_Fact_Financials].[dbo_Fact_FinancialsSSN0_0] AS [dbo_Fact_FinancialsSSN0_0],[dbo_Fact_Financials].[dbo_Fact_FinancialsLoanAmount0_1] AS [dbo_Fact_FinancialsLoanAmount0_1],[dbo_Fact_Financials].[dbo_Fact_FinancialsPurchase_x0020_Price0_2] AS [dbo_Fact_FinancialsPurchase_x0020_Price0_2],[dbo_Fact_Financials].[dbo_Fact_FinancialsMonthlyIncome0_3] AS [dbo_Fact_FinancialsMonthlyIncome0_3],[dbo_Fact_Financials].[dbo_Fact_Financials0_4] AS [dbo_Fact_Financials0_4],[dbo_Fact_Financials].[dbo_Fact_FinancialsPropertyKey0_5] AS [dbo_Fact_FinancialsPropertyKey0_5],[dbo_Fact_Financials].[dbo_Fact_FinancialsLoanKey0_6] AS [dbo_Fact_FinancialsLoanKey0_6],[dbo_Fact_Financials].[dbo_Fact_FinancialsBorrowerKey0_7] AS [dbo_Fact_FinancialsBorrowerKey0_7],[dbo_Dim_Loan_4].[Loan Date] AS [dbo_Dim_LoanLoan_x0020_Date2_0]
FROM 
(

SELECT [SSN] AS [dbo_Fact_FinancialsSSN0_0],[LoanAmount] AS [dbo_Fact_FinancialsLoanAmount0_1],[Purchase Price] AS [dbo_Fact_FinancialsPurchase_x0020_Price0_2],[MonthlyIncome] AS [dbo_Fact_FinancialsMonthlyIncome0_3],1   AS [dbo_Fact_Financials0_4],[PropertyKey] AS [dbo_Fact_FinancialsPropertyKey0_5],[LoanKey] AS [dbo_Fact_FinancialsLoanKey0_6],[BorrowerKey] AS [dbo_Fact_FinancialsBorrowerKey0_7]
FROM [dbo].[Fact_Financials]
)
 AS [dbo_Fact_Financials],[dbo].[Dim_Loan] AS [dbo_Dim_Loan_4]
WHERE 
(

(
[dbo_Fact_Financials].[dbo_Fact_FinancialsLoanKey0_6] = [dbo_Dim_Loan_4].[LoanKey]
)

)