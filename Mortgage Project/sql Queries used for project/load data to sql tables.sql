
Select	*
From	[dbo].[Borrower_details] --where SSN != 67656473
Select	*
From	[dbo].[Financial_details] --where SSN != 67656473
Select	*
From 	[dbo].[Property_details] --where SSN != 67656473
Select	* 
From 	[dbo].[Loan_details] 

-- Create a sequence
CREATE SEQUENCE Seq_MPLoanTbl_Property_ID
    START WITH 100
    INCREMENT BY 1 ;
GO
--- reset identity for table as we missed some data before on loan and property tbl for id
DBCC CHECKIDENT ('[dbo].[Loan_details]', RESEED, 0);
GO
DBCC CHECKIDENT ('[dbo].[Property_details]', RESEED, 0);
GO

Delete	[dbo].[Borrower_details]
Delete	[dbo].[Financial_details]
Delete	[dbo].[Loan_details]
Delete	[dbo].[Property_details]

truncate table  [dbo].[Borrower_details]
truncate table [dbo].[Financial_details]
truncate table [dbo].[Property_details]
truncate table [dbo].[Loan_details]

Select	*
From	[dbo].[MoLoanAppDatafromExcel]

Alter table [dbo].[MoLoanAppDatafromExcel]
Add Loan_ID int not null, Propery_ID int not null

Select		[Co-Borrower SSN]
From		[dbo].[MoLoanAppDatafromExcel]
----------- 
--reverse string and get specific num of char from specific dash
  declare @a varchar(15)  = 'Mi 10234-4569' 
  declare @b varchar(15) 
   Set @b = right(@a,CHARINDEX('-',@a)+1)--left(@a, CHARINDEX('-',@a))
   --SUBSTRING(@a,CHARINDEX('-',@a),Len(@a))
   Select	Len(@a)
   Select	@b

   Select	'Mi 10234-4569'
   Select	Select	SUBSTRING('Mi 10234-4569',CHARINDEX(' ','Mi 10234-4569'),len('Mi 10234-4569')) 
   Select REVERSE('Mi 10234-4569')
   Select Substring(REVERSE('Mi 10234-4569'),CHARINDEX('-',REVERSE('Mi 10234-4569')),6) + '-'+left(REVERSE('Mi 10234-4569'),4)
   --Final
   Select	'10234-4569'
   Select Reverse(left(REVERSE('Mi 10234-4569'),4) + Substring(REVERSE('Mi 10234-4569'),CHARINDEX('-',REVERSE('Mi 10234-4569')),6))

   (LEN([Zip])  >=  FINDSTRING([TEXT_LINE1],"MXPC",1) + 9  ?   SUBSTRING([TEXT_LINE1],FINDSTRING([TEXT_LINE1],"MXPC",1),10)  : ""))

   (LEN([Zip])  > 10  ?   REVERSE(LEFT(REVERSE(Zip),4) + SUBSTRING(REVERSE(Zip),FINDSTRING(REVERSE(Zip),"-",1),6))  : Zip))


   REVERSE(LEFT(REVERSE(Zip),4) + SUBSTRING(REVERSE(Zip),FINDSTRING(REVERSE(Zip),"-",1),6))

   LEN([Zip]>10?REVERSE(LEFT(REVERSE(Zip),4)+SUBSTRING(REVERSE(Zip),FINDSTRING(REVERSE(Zip),"-",1),6)):""


  ------------ Finally in SSIS working one is ---------------
   LEN(Zip) > 10 ? REVERSE(LEFT(REVERSE(Zip),4) + SUBSTRING(REVERSE(Zip),FINDSTRING(REVERSE(Zip),"-",1),6)) : Zip
   /*
  !ISNULL(SSN) && !ISNULL([Borrower FirstName]) && !ISNULL([Borrower LastName]) && !ISNULL([Borrower Email]) && !ISNULL([Home Phone]) && !ISNULL([Marital Status]) && !ISNULL([Date of Birth]) && !ISNULL(City) && !ISNULL(State) && !ISNULL(Zip) && !ISNULL(YearsAtThisAddress) && !ISNULL(MonthlyIncome) && !ISNULL([Rent or Own]) && !ISNULL(Checking) && !ISNULL(Savings) && !ISNULL(Property_ID) && !ISNULL([Property Usage]) && !ISNULL([Property City]) && !ISNULL([Property State]) && !ISNULL([Property Zip]) && !ISNULL(Loan_ID) && !ISNULL([Purpose of Loan]) && !ISNULL(LoanAmount) && !ISNULL([Purchase Price]) && !ISNULL(CreditCardAuthorization) && !ISNULL([Number of Units]) && !ISNULL(Refferal)


  declare @SourceFileName varchar(250)
declare @Body varchar(8000)
declare @Subject varchar (100)

set @SourceFileName =  ?
set @Body=?
set @Body = '"' + @SourceFileName + '" is not in the correct format.Please check for the errors' 
+ Char(13)+ Char(13)+
@Body
set @Subject =  ' Check for errors in the file.'

select @Body as Body , @Subject as Subject


----
DECLARE @recipients varchar(2000)
DECLARE @filename varchar(200)
DECLARE @subject varchar(2000)
DECLARE @body  varchar(8000)

SET @recipients = ISNULL(?, ' ')
SET @subject = ISNULL(?, ' ')
SET @body  = ISNULL(?, ' ')
SET @filename = ISNULL(?, ' ')


EXEC msdb.dbo.sp_send_dbmail
@recipients=@recipients,
@subject=@subject ,
@body=@body,
@profile_name = 'EmailAlert'  

   */

Create database Mort_Project_SSIS

Create table sendEmail(body varchar(8000), recipients varchar(100))

Select	* From	sendEmail

---- Create view for error handling in SSIS for table columns

Select		*
From		[dbo].[Borrower_details] as B
left join	[dbo].[Financial_details] as F
on			B.SSN = F.SSN
left join	[dbo].[Loan_details] as L
on			L.SSN = F.SSN
left join	[dbo].[Property_details] as  P
on			P.SSN = L.SSN


--- Clean up data

--1... Phone number as below
declare @num varchar(20) = '404-828-3036'  --'(123) 2349823'
Select replace(replace(replace(replace(rtrim(ltrim(@num)), '-', ''), '(', ''),')',''),' ','')
--in ssis replace(replace(replace(replace(rtrim(ltrim([Home Phone])), "-", ""), "(", ""),")","")," ","")
--2 zipcode

declare @Zip varchar(15) = '12456'--'45895-1234'--'47894-1234123'--'nnjjb 12345-4567 '--'Me 92806-4043'
		Select 
(REVERSE(SUBSTRING(REVERSE(@Zip),Charindex('-',REVERSE(@Zip))+1,6)))
----------------------------/*  
--old for zipcode
--(DT_STR,15,1252)(LEN(Zip) > 10 ? REVERSE(LEFT(REVERSE(Zip),4) + SUBSTRING(REVERSE(Zip),FINDSTRING(REVERSE(Zip),"-",1),6)) : Zip)

--------------

SELECT COUNT(COLUMN_NAME)
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = [dbo].[MoLoanAppDatafromExcel]

 SELECT COUNT(COLUMN_NAME) 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE 
    TABLE_CATALOG = '[STG_Mortgage_Project]' 
    AND TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 

SELECT Count(*) FROM INFORMATION_SCHEMA.Columns where TABLE_NAME = '[dbo].[MoLoanAppDatafromExcel]'

exec sp_columns MyTable

EXEC sp_describe_first_result_set N'SELECT * FROM [dbo].[MoLoanAppDatafromExcel]'

Select		*
From		[dbo].[MoLoanAppDatafromExcel]

delete		[dbo].[MoLoanAppDatafromExcel]
Where		[Borrower FirstName]='Chaitu'
--------------- IMP stored proc for update middle table 
GO
GO
Create Proc dbo.UD_SP_UpdateMoLoanAppDataTbl
	@BorrowerFirstName varchar(50) ,
	@BorrowerLastName varchar(50) ,
	@BorrowerEmail varchar(50) ,
	@SSN int  ,
	@HomePhone varchar(50) ,
	@CellPhone varchar(50) ,
	@MaritalStatus varchar(50) ,
	@DateofBirth datetime ,
	@CurrentStreetAddress varchar(50),
	@City varchar(50),
	@State varchar(50) ,
	@Zip varchar(15) ,
	@YearsAtThisAddress varchar(50) ,
	@MonthlyIncome varchar(50) ,
	@Bonuses varchar(50) ,
	@Commission varchar(50) ,
	@OtherIncome varchar(50) ,
	@RentorOwn varchar(50) ,
	@Loan_Date date ,
	@PurposeofLoan varchar(50) ,
	@PropertyUsage varchar(50) ,
	@LoanAmount int ,
	@PurchasePrice int ,
	@NumberofUnits int ,
	@PropertyCity varchar(50) ,
	@PropertyState varchar(50) ,
	@PropertyZip varchar(15) ,
	@Sex varchar(50) ,
	@Ethnicity varchar(50) ,
	@Race varchar(50) ,
	@CoBorrowerSSN int  ,
	@CoBorrowerFirstName varchar(50) ,
	@CoBorrowerLastName varchar(50) ,
	@CoBorrowerEmail varchar(50) ,
	@CreditCardAuthorization varchar(50) ,
	@Checking int ,
	@Savings int ,
	@RetirementFund int ,
	@MutualFund int ,
	@Referral varchar(50) ,
	@RealEstateAgentName varchar(50) ,
	@RealEstateAgentPhone varchar(50) ,
	@RealEstateAgentEmail varchar(50) ,
	@Loan_ID int  ,
	@Propery_ID int  

as
	Begin
		Update		[dbo].[MoLoanAppDatafromExcel]
		Set			[Borrower FirstName] = @BorrowerFirstName
				  ,[Borrower LastName] = @BorrowerLastName
				  ,[Borrower Email] = @BorrowerEmail
				  ,[Home Phone] = @HomePhone
				  ,[Cell Phone] = @CellPhone
				  ,[Marital Status] = @MaritalStatus
				  ,[Date of Birth] = @DateofBirth
				  ,[Current Street Address] = @CurrentStreetAddress
				  ,[City] = @City
				  ,[State] = @State
				  ,[Zip] = @Zip
				  ,[YearsAtThisAddress] = @YearsAtThisAddress
				  ,[MonthlyIncome] = @MonthlyIncome
				  ,[Bonuses] = @Bonuses
				  ,[Commission] = @Commission
				  ,[OtherIncome] = @OtherIncome
				  ,[Rent or Own] = @RentorOwn
				  ,[Loan_Date] = @Loan_Date
				  ,[Purpose of Loan] = @PurposeofLoan
				  ,[Property Usage] = @PropertyUsage
				  ,[LoanAmount] = @LoanAmount
				  ,[Purchase Price] = @PurchasePrice
				  ,[Number of Units] = @NumberofUnits
				  ,[Property City] = @PropertyCity
				  ,[Property State] = @PropertyState
				  ,[Property Zip] = @PropertyZip
				  ,[Sex] = @Sex
				  ,[Ethnicity] = @Ethnicity
				  ,[Race] = @Race
				  ,[Co-Borrower SSN] = @CoBorrowerSSN
				  ,[Co-Borrower FirstName] = @CoBorrowerFirstName
				  ,[Co-Borrower LastName] = @CoBorrowerLastName
				  ,[Co-Borrower Email] = @CoBorrowerEmail
				  ,[CreditCardAuthorization] = @CreditCardAuthorization
				  ,[Checking] = @Checking
				  ,[Savings] = @Savings
				  ,[RetirementFund] = @RetirementFund
				  ,[MutualFund] = @MutualFund
				  ,[Referral] = @Referral
				  ,[RealEstateAgentName] = @RealEstateAgentName
				  ,[RealEstateAgentPhone] = @RealEstateAgentPhone
				  ,[RealEstateAgentEmail] = @RealEstateAgentEmail
				  ,[Loan_ID] = @Loan_ID
				  ,[Propery_ID] = @Propery_ID
		Where		[SSN] = @SSN
	End

Exec dbo.UD_SP_UpdateMoLoanAppDataTbl ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?

----- Update borrower table with oledb command in ssis
GO
Alter Proc dbo.UD_SP_UpdateBorrowerTBL
	@SSN int,
	@BorrowerFirstName varchar(50) ,
	@BorrowerLastName varchar(50) ,
	@BorrowerEmail varchar(50) ,
	@HomePhone varchar(50) ,
	@CellPhone varchar(50) ,
	@MaritalStatus varchar(50) ,
	@DateofBirth date ,
	@CurrentStreetAddress varchar(50) ,
	@City varchar(50) ,
	@State varchar(50) ,
	@Zip varchar(15) ,
	@YearsAtThisAddress int ,
	@Sex varchar(50) ,
	@Ethnicity varchar(50) ,
	@Race varchar(50) ,
	@CoBorrowerSSN int  ,
	@CoBorrowerFirstName varchar(50) ,
	@CoBorrowerLastName varchar(50) ,
	@CoBorrowerEmail varchar(50) 
As
	Begin
		Update	[dbo].[Borrower_details]
		Set			[Borrower FirstName]= @BorrowerFirstName
				  ,[Borrower LastName]= @BorrowerLastName 
				  ,[Borrower Email]= @BorrowerEmail 
				  ,[Home Phone]= @HomePhone 
				  ,[Cell Phone]= @CellPhone 
				  ,[Marital Status]= @MaritalStatus 
				  ,[Date of Birth]= @DateofBirth 
				  ,[Current Street Address]= @CurrentStreetAddress 
				  ,[City]= @City 
				  ,[State]= @State 
				  ,[Zip]= @Zip 
				  ,[YearsAtThisAddress]= @YearsAtThisAddress 
				  ,[Sex]= @Sex 
				  ,[Ethnicity]= @Ethnicity 
				  ,[Race]= @Race 
				  ,[Co-Borrower FirstName]= @CoBorrowerFirstName 
				  ,[Co-Borrower LastName]= @CoBorrowerLastName 
				  ,[Co-Borrower Email]= @CoBorrowerEmail  
		Where	SSN = @SSN
		And		[Co-Borrower SSN]= @CoBorrowerSSN
	End

Exec  dbo.UD_SP_UpdateBorrowerTBL ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?

---- SP for financial table update in oledb command in ssis
GO
Create Proc dbo.UD_SP_UpdateFinancialTBL
	@SSN int  ,
	@MonthlyIncome varchar(50) ,
	@Bonuses varchar(50) ,
	@Commission varchar(50) ,
	@OtherIncome varchar(50) ,
	@RentorOwn varchar(50) ,
	@Checking int ,
	@Savings int ,
	@RetirementFund int ,
	@MutualFund int 
As 
	Begin
		Update	[dbo].[Financial_details]
		Set		[MonthlyIncome] = @MonthlyIncome 
				,[Bonuses] = @Bonuses 
				,[Commission] = @Commission 
				,[OtherIncome] = @OtherIncome 
				,[Rent or Own] = @RentorOwn 
				,[Checking] = @Checking 
				,[Savings] = @Savings 
				,[RetirementFund] = @RetirementFund 
				,[MutualFund] = @MutualFund 
		Where	[SSN] = @SSN 
	End

Exec dbo.UD_SP_UpdateFinancialTBL ?,?,?,?,?,?,?,?,?,?

----------------- SP for Property table
Go
Create Proc dbo.UD_SP_UpdatePropertyTBL
			@Property_ID int,
			@SSN int  ,
			@PropertyUsage varchar(50) ,
			@PropertyCity varchar(50) ,
			@PropertyState varchar(50) ,
			@PropertyZip varchar(15) ,
			@RealEstateAgentName varchar(50) ,
			@RealEstateAgentPhone varchar(50) ,
			@RealEstateAgentEmail varchar(50) 
As
	Begin
		Update		[dbo].[Property_details]
		Set			[Property_ID] = @Property_ID ,
					[Property Usage] = @PropertyUsage ,
					[Property City] = @PropertyCity ,
					[Property State] = @PropertyState, 
					[Property Zip] = @PropertyZip ,
					[RealEstateAgentName] = @RealEstateAgentName ,
					[RealEstateAgentPhone] = @RealEstateAgentPhone ,
					[RealEstateAgentEmail] = @RealEstateAgentEmail 
		Where		[SSN] = @SSN

	End

Exec dbo.UD_SP_UpdatePropertyTBL ?,?,?,?,?,?,?,?,?,
----- update Loan tbl with SP

Go
Create	Proc dbo.UD_SP_UpdateLoanTBL	
	@Loan_ID int  ,
	@SSN int  ,
	@Property_ID int  ,
	@PurposeofLoan varchar(50) ,
	@LoanAmount int ,
	@PurchasePrice int ,
	@CreditCardAuthorization varchar(50) ,
	@NumberofUnits int ,
	@Refferal varchar(50) ,
	@CoBorrowerSSN int  ,
	@LoanDate date  
AS
	Begin
		Update	[dbo].[Loan_details]
		Set		[Loan_ID] = @Loan_ID ,
				[Property_ID] = @Property_ID ,
				[Purpose of Loan] = @PurposeofLoan ,
				[LoanAmount] = @LoanAmount ,
				[Purchase Price] = @PurchasePrice ,
				[CreditCardAuthorization] = @CreditCardAuthorization ,
				[Number of Units] = @NumberofUnits,
				[Refferal] = @Refferal ,
				[Co-Borrower SSN] = @CoBorrowerSSN ,
				[Loan Date] = @LoanDate
		Where	[SSN] = @SSN
	End

Exec	dbo.UD_SP_UpdateLoanTBL	?,?,?,?,?,?,?,?,?,?,?






