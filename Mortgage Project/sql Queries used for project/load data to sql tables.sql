
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

--2 zipcode

declare @Zip varchar(15) = '12456'--'45895-1234'--'47894-1234123'--'nnjjb 12345-4567 '--'Me 92806-4043'
		Select (REVERSE(SUBSTRING(REVERSE(@Zip),
				Charindex('-',REVERSE(@Zip))+1,
				6)))


