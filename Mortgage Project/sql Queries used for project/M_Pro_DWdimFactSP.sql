Create database Mortgage_DW
Go

Use Mortgage_DW

-- creating 3 dimensions tables and 1 fact table


				DROP TABLE Dim_Borrower
				DROP TABLE Dim_Property
				DROP TABLE Dim_Loan
				DROP TABLE Fact_Financials

Select	*
From	[Mortgage_ODS].[dbo].[Final_Mortgage]

---- Create dim_Borrower dimension SCD type 2
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
		  From [Mortgage_ODS].[dbo].[Final_Mortgage]) As Source
		  On	Target.SSN = Source.SSN

		  When Matched 
				and Target.[Dim_B_Checksum] <> Source.BorrowerChecksum
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
			OUTPUT	$action
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
			action
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
			) Where Action = 'UPDATE' ; 
--- end for Dim_Borrower crud operations with merge

---------------- Creating Dim_Property















-----------------------------------testing
Select		*
From		[dbo].[Dim_Borrower]

Select		*
From		[Mortgage_ODS].[dbo].[Final_Mortgage]





