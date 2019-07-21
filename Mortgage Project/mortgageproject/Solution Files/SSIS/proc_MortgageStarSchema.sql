USE [Mortgage]
GO
/****** Object:  StoredProcedure [dbo].[proc_MortgageStarSchema]    Script Date: 12/24/2013 20:29:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER	PROCEDURE	[dbo].[proc_MortgageStarSchema]   --  EXEC dbo.proc_MortgageStarSchema 
	AS
	
		BEGIN

				/*
				Notes:  This does not include any Type 2 Dimensions in this script.  The columns may be different, 
						so build your own script and use this as a refrence only.
				
				
				--SELECT *  FROM [dbo].[Borrower_source]
				--SELECT *  FROM dbo.Property_source
				--SELECT *  FROM dbo.Loan_source
				--SELECT *  FROM dbo.Financial_source
				--SELECT *  FROM dbo.Mortgage
				*/

				DROP TABLE Dim_Borrower
				DROP TABLE Dim_Property
				DROP TABLE Dim_Loan
				DROP TABLE Fact_Financials

				CREATE TABLE Dim_Borrower(
					[Borrower_Key] INT Identity(1,1),
					[SSN] [int] NOT NULL,
					[BorrowerFirstName] [varchar](50) NULL,
					[BorrowerLastName] [varchar](50) NULL,
					[BorrowerEmail] [varchar](50) NULL,
					[HomePhone] [varchar](50) NULL,
					[CellPhone] [varchar](50) NULL,
					[MaritalStatus] [varchar](50) NULL,
					[DOB] [datetime] NULL,
					[Address] [varchar](50) NULL,
					[State] [varchar](50) NULL,
					[Zip] [varchar](50) NULL,
					[Sex] [varchar](50) NULL,
					[Ethnicity] [varchar](50) NULL,
					[Race] [varchar](50) NULL
				) 

				INSERT INTO Dim_Borrower ([SSN],[BorrowerFirstName],[BorrowerLastName],[BorrowerEmail],[HomePhone],[CellPhone],[MaritalStatus],[DOB],[Address],[State],[Zip],[Sex],[Ethnicity],[Race])
				SELECT		DISTINCT SSN,[Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth],City, State, Zip, Sex, Ethnicity, Race
				FROM		dbo.Mortgage

				CREATE TABLE Dim_Property (
					[Property_Key] INT Identity(1,1),
					[Property_ID] [int] NOT NULL,
					[Property Usage] [varchar](50) NULL,
					[Property City] [varchar](50) NULL,
					[Property State] [varchar](50) NULL,
					[Property Zip] [varchar](50) NULL,
					[RealEstateAgentName] [varchar](50) NULL,
					[RealEstateAgentPhone] [varchar](50) NULL,
					[RealEstateAgentEmail] [varchar](50) NULL
				)

				INSERT INTO Dim_Property ([Property_ID],[Property Usage],[Property City],[Property State],[Property Zip],[RealEstateAgentName],[RealEstateAgentPhone],[RealEstateAgentEmail])
				SELECT		DISTINCT Property_ID, [Property Usage], [Property City], [Property State], [Property Zip], [RealEstateAgentName], [RealEstateAgentPhone], [RealEstateAgentEmail]
				FROM		dbo.Mortgage

				CREATE TABLE Dim_Loan (
					[Loan_Key] INT Identity(1,1),
					[Loan_ID] [int] NOT NULL,
					[Property_ID] [int] NOT NULL,
					[Purpose of Loan] [varchar](50) NULL,
					[CreditCardAuthorization] [varchar](50) NULL,
					[Refferal] [varchar](50) NULL,
					[Co-Borrower SSN] [int] NOT NULL,
					[Rent or Own] [varchar](200) NULL,
					[LoanDate] datetime NULL
				) ON [PRIMARY]

				INSERT INTO Dim_Loan ([Loan_ID],[Property_ID],[Purpose of Loan],[CreditCardAuthorization],[Refferal],[Co-Borrower SSN],[Rent or Own],[LoanDate] )
				SELECT		DISTINCT Loan_ID, Property_ID, [Purpose of Loan], [CreditCardAuthorization], [Refferal], [Co-Borrower SSN],[Rent or Own],[LoanDate]
				FROM		dbo.Mortgage


				CREATE TABLE Fact_Financials (
					[Financial_Key] INT Identity(1,1),
					[Borrower_Key] INT,
					[Property_Key] INT,
					[Loan_Key] INT,
					[YearsAtThisAddress] [int] NULL,
					[LoanAmount] [int] NULL,
					[Purchase Price] [int] NULL,
					[Number of Units] [int] NULL,
					[MonthlyIncome] [varchar](50) NULL,
					[Bonuses] [varchar](50) NULL,
					[Commission] [varchar](50) NULL,
					[OtherIncome] [varchar](50) NULL,
					[Checking] [int] NULL,
					[Savings] [int] NULL,
					[RetirementFund] [int] NULL,
					[MutualFund] [int] NULL
				)

				INSERT INTO Fact_Financials ([Borrower_Key],	[Property_Key],[Loan_Key],[YearsAtThisAddress],[LoanAmount],[Purchase Price],[Number of Units],[MonthlyIncome],[Bonuses],[Commission],[OtherIncome],[Checking],[Savings],[RetirementFund],[MutualFund])
				SELECT		DISTINCT b.Borrower_Key,c.Property_Key,d.Loan_Key, a.[YearsAtThisAddress],a.[LoanAmount],a.[Purchase Price],a.[Number of Units],a.[MonthlyIncome],a.[Bonuses],a.[Commission],a.[OtherIncome],a.[Checking],a.[Savings],a.[RetirementFund],a.[MutualFund]
				FROM		dbo.Mortgage a
				LEFT JOIN	Dim_Borrower b
				ON			a.SSN = b.SSN
				LEFT JOIN	Dim_Property c
				ON			a.Property_ID = c.Property_ID
				LEFT JOIN	Dim_Loan d
				ON			a.Loan_ID = d.Loan_ID

		END