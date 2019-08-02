--Create database Mortgage_DW
--Go

Use Mortgage_DW

-- creating 3 dimensions tables and 1 fact table

/*
				DROP TABLE Dim_Borrower
				DROP TABLE Dim_Property
				DROP TABLE Dim_Loan
				DROP TABLE Fact_Financials

Select	*
From	#Final_Mortgage_forDW */
Go
Alter Proc	UD_SP_DW_Update
As
/*	Created: Ashok 8.1.19
	Purpose: To update dimensions and Facts as per Mortgage_ODS which is				clean data. Those dimensions and facts will be used for					reporting and analysis. 
*/
Begin
	Set nocount on;
-- Create temp table so we can utilize it further
If OBJECT_ID (N'tempdb..#Final_Mortgage_forDW') is not null Begin drop table #Final_Mortgage_forDW end--- drop temp tbl if its there

Select	*
Into	#Final_Mortgage_forDW
From	[Mortgage_ODS].[dbo].[Final_Mortgage]

---- Create dim_Borrower dimension SCD type 2 and rest are type 1
If Not Exists (Select * From sysobjects where name = 'Dim_Borrower' and xtype = 'U')
	Begin	
		Create Table	Dim_Borrower
					(	BorrowerKey int Identity(1,1),
						[SSN] [int] NOT NULL,
						[Borrower FirstName] [varchar](50) NULL,
						[Borrower LastName] [varchar](50) NULL,
						[Borrower Email] [varchar](50) NULL,
						[Home Phone] [varchar](50) NULL,
						[Cell Phone] [varchar](50) NULL,
						[Marital Status] [varchar](50) NULL,
						[Date of Birth] [date] NULL,
						[Current Street Address] [varchar](50) NULL,
						[City] [varchar](50) NULL,
						[State] [varchar](50) NULL,
						[Zip] [varchar](15) NULL,
						[YearsAtThisAddress] [int] NULL,
						[Sex] [varchar](50) NULL,
						[Ethnicity] [varchar](50) NULL,
						[Race] [varchar](50) NULL,
						[Co-Borrower SSN] [int] NOT NULL,
						[Co-Borrower FirstName] [varchar](50) NULL,
						[Co-Borrower LastName] [varchar](50) NULL,
						[Co-Borrower Email] [varchar](50) NULL,
						Dim_B_Checksum	int,
						Dim_B_EffectiveDate datetime,
						Dim_B_EndDate	datetime,
						Dim_B_Current	varchar(5)
					)
	End
-- use merge to insert or update  dim_Borrower dimension
/*  Dim_Borrower is type 2 SCD (slowly changing Dimension) so if there is any change in record value then previos record will be there but not current and end date will be set for that row, now bran new row will be added with new data from source table with other info like checksum and dates  to dim_borrowe table
So every little to little change  in source table will create brand new row in dim_borrowe table */

Insert Into Dim_Borrower([SSN], [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], [City], [State], [Zip], [YearsAtThisAddress], [Sex], [Ethnicity], [Race], [Co-Borrower SSN], [Co-Borrower FirstName], [Co-Borrower LastName], [Co-Borrower Email], [Dim_B_Checksum], [Dim_B_EffectiveDate], [Dim_B_EndDate], [Dim_B_Current])
Select		[SSN]
			, [Borrower FirstName]
			, [Borrower LastName]
			, [Borrower Email]
			, [Home Phone]
			, [Cell Phone]
			, [Marital Status]
			, [Date of Birth]
			, [Current Street Address]
			, [City]
			, [State]
			, [Zip]
			, [YearsAtThisAddress]
			, [Sex]
			, [Ethnicity]
			, [Race]
			, [Co-Borrower SSN]
			, [Co-Borrower FirstName]
			, [Co-Borrower LastName]
			, [Co-Borrower Email]
			, [Dim_B_Checksum]
			, [Dim_B_EffectiveDate]
			, [Dim_B_EndDate]
			, [Dim_B_Current]
From	
(
		Merge	Dim_Borrower as Target
		Using (	Select Distinct [SSN], [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], [City], [State], [Zip], [YearsAtThisAddress], [Sex], [Ethnicity], [Race], [Co_Borrower SSN], [Co_Borrower FirstName], [Co_Borrower LastName], [Co_Borrower Email],
		  BINARY_CHECKSUM([SSN], [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], [City], [State], [Zip], [YearsAtThisAddress], [Sex], [Ethnicity], [Race], [Co_Borrower SSN], [Co_Borrower FirstName], [Co_Borrower LastName], [Co_Borrower Email])
		  as BorrowerChecksum 
		  From #Final_Mortgage_forDW ) As Source
		  On	Target.SSN = Source.SSN

		  When	Matched 
				and Target.[Dim_B_Checksum] <> Source.BorrowerChecksum
				and Target.[Dim_B_Current] ='Yes'
		  Then
			Update 
			Set		Target.[Dim_B_EndDate] = getdate() -1
					,Target.[Dim_B_Current] = 'No'
		  When Not Matched 
		  Then
			Insert( [SSN], [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], [City], [State], [Zip], [YearsAtThisAddress], [Sex], [Ethnicity], [Race], [Co-Borrower SSN], [Co-Borrower FirstName], [Co-Borrower LastName], [Co-Borrower Email], [Dim_B_Checksum], [Dim_B_EffectiveDate], [Dim_B_EndDate], [Dim_B_Current]
			)
			Values(Source.[SSN], Source.[Borrower FirstName], Source.[Borrower LastName], Source.[Borrower Email], Source.[Home Phone], Source.[Cell Phone], Source.[Marital Status], Source.[Date of Birth], Source.[Current Street Address], Source.[City], Source.[State], Source.[Zip], Source.[YearsAtThisAddress], Source.[Sex], Source.[Ethnicity], Source.[Race], Source.[Co_Borrower SSN], Source.[Co_Borrower FirstName], Source.[Co_Borrower LastName], Source.[Co_Borrower Email],
		  BINARY_CHECKSUM(Source.[SSN], Source.[Borrower FirstName], Source.[Borrower LastName], Source.[Borrower Email], Source.[Home Phone], Source.[Cell Phone], Source.[Marital Status], Source.[Date of Birth], Source.[Current Street Address], Source.[City], Source.[State], Source.[Zip], Source.[YearsAtThisAddress], Source.[Sex], Source.[Ethnicity], Source.[Race], Source.[Co_Borrower SSN], Source.[Co_Borrower FirstName], Source.[Co_Borrower LastName], Source.[Co_Borrower Email]), getdate(), '12/31/9999','Yes'
			)
			OUTPUT	$Action
					,Source.[SSN]
					, Source.[Borrower FirstName]
					, Source.[Borrower LastName]
					, Source.[Borrower Email]
					, Source.[Home Phone]
					, Source.[Cell Phone]
					, Source.[Marital Status]
					, Source.[Date of Birth]
					, Source.[Current Street Address]
					, Source.[City]
					, Source.[State]
					, Source.[Zip]
					, Source.[YearsAtThisAddress]
					, Source.[Sex]
					, Source.[Ethnicity]
					, Source.[Race]
					, Source.[Co_Borrower SSN]
					, Source.[Co_Borrower FirstName]
					, Source.[Co_Borrower LastName]
					, Source.[Co_Borrower Email]
					, Source.BorrowerChecksum
					, getdate()
					, '12/31/9999'
					,'Yes'
) As Changes (
			Action
			,[SSN]
			, [Borrower FirstName]
			, [Borrower LastName]
			, [Borrower Email]
			, [Home Phone]
			, [Cell Phone]
			, [Marital Status]
			, [Date of Birth]
			, [Current Street Address]
			, [City]
			, [State]
			, [Zip]
			, [YearsAtThisAddress]
			, [Sex]
			, [Ethnicity]
			, [Race]
			, [Co-Borrower SSN]
			, [Co-Borrower FirstName]
			, [Co-Borrower LastName]
			, [Co-Borrower Email]
			, [Dim_B_Checksum]
			, [Dim_B_EffectiveDate]
			, [Dim_B_EndDate]
			, [Dim_B_Current]
			) Where [Action] = 'UPDATE' ; 
--- end for Dim_Borrower crud operations with merge

---------------- Creating Dim_Property Type 1 dimension
If not exists (Select * From Sys.Objects Where name ='Dim_Property' and type ='U')
	Begin
		Create Table Dim_Property(
						PropertyKey int Identity(1,1),
						[Property_ID] [int] NOT NULL,
						[Property Usage] [varchar](50) NULL,
						[Property City] [varchar](50) NULL,
						[Property State] [varchar](50) NULL,
						[Property Zip] [varchar](15) NULL,
						[RealEstateAgentName] [varchar](50) NULL,
						[RealEstateAgentPhone] [varchar](50) NULL,
						[RealEstateAgentEmail] [varchar](50) NULL,
						PropertyCheckSum int
						)
	End

--- using merget to insert and update  [dbo].[Dim_Property] table

Merge		[Dim_Property] as Target
Using		( Select distinct [Property_ID], [Property Usage], 
			[Property City], [Property State], [Property Zip],			
			[RealEstateAgentName], [RealEstateAgentPhone],				
			[RealEstateAgentEmail], Binary_Checksum([Property_ID],[Property Usage], [Property City], [Property State],		[Property Zip], [RealEstateAgentName],						[RealEstateAgentPhone], [RealEstateAgentEmail]) as						PropertyChecksum 
			  From	#Final_Mortgage_forDW
			) as Source
On			Target.Property_ID   = Source.Property_ID
When		Matched 
			and Target.PropertyCheckSum <> Source.PropertyChecksum
Then		Update		
			Set		
			Target.[Property_ID]=Source.[Property_ID],
			Target.[Property Usage]=Source.[Property Usage],
			Target.[Property City]=Source.[Property City],
			Target.[Property State]=Source.[Property State],
			Target.[Property Zip]=Source.[Property Zip],
			Target.[RealEstateAgentName]=Source.[RealEstateAgentName],
			Target.[RealEstateAgentPhone]=Source.[RealEstateAgentPhone],
			Target.[RealEstateAgentEmail]=Source.[RealEstateAgentEmail],
			Target.[PropertyCheckSum]=Source.[PropertyCheckSum]
When		Not Matched
Then
			Insert ([Property_ID], [Property Usage], 
			[Property City], [Property State], [Property Zip],			
			[RealEstateAgentName], [RealEstateAgentPhone],				
			[RealEstateAgentEmail],PropertyCheckSum)
			Values(	Source.[Property_ID],
					Source.[Property Usage],
					Source.[Property City],
					Source.[Property State],
					Source.[Property Zip],
					Source.[RealEstateAgentName],
					Source.[RealEstateAgentPhone],
					Source.[RealEstateAgentEmail],
					Binary_CheckSum(
						Source.[Property_ID],
						Source.[Property Usage],
						Source.[Property City],
						Source.[Property State],
						Source.[Property Zip],
						Source.[RealEstateAgentName],
						Source.[RealEstateAgentPhone],
						Source.[RealEstateAgentEmail]
					)
			);
---------------- Creating Dim_Loan Type 1 dimension------
IF NOT EXISTS (Select	* From sys.objects where name ='Dim_Loan' and type ='U')
Begin
	Create table Dim_Loan(
						LoanKey int identity(1,1),
						[Loan_ID] [int] NOT NULL,
						[Property_ID] [int] NOT NULL,
						[Purpose of Loan] [varchar](50) NULL,
						[CreditCardAuthorization] [varchar](50) NULL,
						[Number of Units] [int] NULL,
						[Refferal] [varchar](50) NULL,
						[Co-Borrower SSN] [int] NOT NULL,
						[Rent or Own] [varchar](50) NULL,
						[Loan Date] [date] NOT NULL,
						LoanChecksum int	
						)
End
--- using merget to insert and update  Dim_Loan table

Merge		[Dim_Loan] as Target
Using		(	Select	[Loan_ID], [Property_ID], [Purpose of Loan],						[CreditCardAuthorization], [Number of Units],							[Refferal], [Co_Borrower SSN], [Rent or Own],
				  [Loan Date],								Binary_Checksum(
				   [Loan_ID], [Property_ID], [Purpose of Loan],			[CreditCardAuthorization], [Number of Units],			[Refferal], [Co_Borrower SSN],[Rent or Own],[Loan Date]
				  ) as LoanCheckSum
				From	#Final_Mortgage_forDW
			) as Source
On			Target.Loan_ID  = Source.Loan_ID
When		Matched and Target.LoanChecksum <> Source.LoanCheckSum
Then
			Update	
			Set		
			Target.[Loan_ID]= Source.[Loan_ID], 
			Target.[Property_ID]= Source.[Property_ID], 
			Target.[Purpose of Loan]=Source.[Purpose of Loan],
			Target.[CreditCardAuthorization]=Source.[CreditCardAuthorization],
			Target.[Number of Units]=Source.[Number of Units],
			Target.[Refferal]=Source.[Refferal],
			Target.[Co-Borrower SSN]=Source.[Co_Borrower SSN],
			Target.[Rent or Own]=Source.[Rent or Own],
			Target.[Loan Date]=Source.[Loan Date],
			Target.[LoanCheckSum]=Source.[LoanCheckSum]
When Not Matched
Then
			Insert([Loan_ID], [Property_ID], [Purpose of Loan],					[CreditCardAuthorization], [Number of Units],				[Refferal], [Co-Borrower SSN],[Rent or Own], 
				  [Loan Date],[LoanCheckSum])
			Values(	Source.[Loan_ID], 
					Source.[Property_ID], 
					Source.[Purpose of Loan],
					Source.[CreditCardAuthorization],
					Source.[Number of Units],
					Source.[Refferal],
					Source.[Co_Borrower SSN],
					Source.[Rent or Own],
					Source.[Loan Date],
					Binary_CheckSum([Loan_ID], [Property_ID], [Purpose of Loan],[CreditCardAuthorization], [Number of Units],	 [Refferal],[Co_Borrower SSN],[Rent or Own],
					[Loan Date])
				);

-----Creating fact Fact_Financials 
If Not Exists (Select * From sys.objects where name='Fact_Financials' and type ='U')
Begin		
		Create Table Fact_Financials(
						FinancialKey int identity(1,1),
						BorrowerKey int,
						PropertyKey int,
						LoanKey int,
						[SSN] int,
						[LoanAmount] [int] NULL,
						[Purchase Price] [int] NULL,
						[MonthlyIncome] int NULL,
						[Bonuses] int NULL,
						[Commission] int NULL,
						[OtherIncome] int NULL,
						[Checking] [int] NULL,
						[Savings] [int] NULL,
						[RetirementFund] [int] NULL,
						[MutualFund] [int] NULL,
						FinancialCheckSum int	
					)
End
-- using merget to insert and update  Fact_Financials table

Merge		Fact_Financials as Target
Using		( Select 
				BorrowerKey, PropertyKey, LoanKey, F_M.[SSN],[LoanAmount],[Purchase Price],[MonthlyIncome],[Bonuses],[Commission], [OtherIncome],[Checking], [Savings],	[RetirementFund],[MutualFund],
					Binary_checksum(BorrowerKey, PropertyKey, LoanKey,	[LoanAmount],[Purchase Price],[MonthlyIncome], [Bonuses], [Commission], [OtherIncome],[Checking], [Savings], [RetirementFund], [MutualFund]) as FinancialCheckSum
				From		#Final_Mortgage_forDW as F_M
				left join	[Dim_Borrower] as B
				On			B.[Dim_B_Current] = 'Yes' and F_M.SSN = B.SSN
				left join	[Dim_Property] as P
				On			F_M.[Property_ID] = P.[Property_ID]
				left join	[Dim_Loan] as L
				On			F_M.[Loan_ID] = L.[Loan_ID]
			) as Source
On			Target.[SSN] = Source.[SSN]
When		Matched 
			and Target.FinancialCheckSum <> Source.FinancialCheckSum
Then
			Update
			Set		Target.[BorrowerKey]=Source.[BorrowerKey],
					Target.[PropertyKey]=Source.[PropertyKey],
					Target.[LoanKey]=Source.[LoanKey],
					Target.[SSN]=Source.[SSN],
					Target.[LoanAmount]=Source.[LoanAmount],
					Target.[Purchase Price]=Source.[Purchase Price],
					Target.[MonthlyIncome]=Source.[MonthlyIncome],
					Target.[Bonuses]=Source.[Bonuses],
					Target.[Commission]=Source.[Commission],
					Target.[OtherIncome]=Source.[OtherIncome],
					Target.[Checking]=Source.[Checking],
					Target.[Savings]=Source.[Savings],
					Target.[RetirementFund]=Source.[RetirementFund],
					Target.[MutualFund]=Source.[MutualFund],
					Target.[FinancialCheckSum]=Source.[FinancialCheckSum]
When		Not Matched
Then
			Insert ([BorrowerKey],[PropertyKey],[LoanKey],[SSN],[LoanAmount],[Purchase Price],[MonthlyIncome],[Bonuses],[Commission],[OtherIncome],[Checking],[Savings],[RetirementFund],[MutualFund],[FinancialCheckSum]
			) Values(
				Source.[BorrowerKey], Source.[PropertyKey], 
				Source.[LoanKey],Source.[SSN],
				Source.[LoanAmount] ,Source.[Purchase Price],
				Source.[MonthlyIncome],Source.[Bonuses],
				Source.[Commission],Source.[OtherIncome], 
				Source.[Checking],Source.[Savings],
				Source.[RetirementFund],Source.[MutualFund],
				Binary_CheckSum(
					Source.[BorrowerKey], Source.[PropertyKey], 
					Source.[LoanKey],Source.[SSN],
					Source.[LoanAmount] ,Source.[Purchase Price],
					Source.[MonthlyIncome],Source.[Bonuses],
					Source.[Commission],Source.[OtherIncome], 
					Source.[Checking],Source.[Savings],
					Source.[RetirementFund],Source.[MutualFund]
				)
			);
End
-----------------------------------testing  103 2004066439 1970512007
/*
Select		*
From		Fact_Financials --123011118

Select		* 
From		[Dim_Loan]

Select		* 
From		[dbo].[Dim_Property]

Select		*
From		[dbo].[Dim_Borrower]

Select		*
From		#Final_Mortgage_forDW

use ssis sql task or sql server agent to automare store procedure
*/

--- Run Store proc to update DW dimensons and facts
Exec [dbo].[UD_SP_DW_Update]

