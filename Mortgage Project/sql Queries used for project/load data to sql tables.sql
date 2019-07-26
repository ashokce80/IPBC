
Select	*
From	[dbo].[Borrower_details] --where SSN != 67656473
Select	*
From	 [dbo].[Financial_details] --where SSN != 67656473

Select	*
From 	[dbo].[Property_details]
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
  

REVERSE(LEFT(REVERSE(Zip),4) + SUBSTRING(REVERSE(Zip),FINDSTRING(REVERSE(Zip),"-",1),6))

[Data Conversion [2]] Error: Data conversion failed while converting column "ZipCode" (21) to column "Copy of ZipCode" (7).  The conversion returned status value 2 and status text "The value could not be converted because of a potential loss of data.".


[Derived Column [16]] Error: SSIS Error Code DTS_E_INDUCEDTRANSFORMFAILUREONERROR.  The "Derived Column" failed because error code 0xC0049064 occurred, and the error row disposition on "Derived Column.Outputs[Derived Column Output].Columns[ZipCode]" specifies failure on error. An error occurred on the specified object of the specified component.  There may be error messages posted before this with more information about the failure.

[Derived Column [16]] Error: An error occurred while attempting to perform a type cast.


[To Borrower Tbl [173]] Error: SSIS Error Code DTS_E_OLEDBERROR.  An OLE DB error has occurred. Error code: 0x80004005.
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80004005  Description: "The statement has been terminated.".
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80004005  Description: "Violation of UNIQUE KEY constraint 'UK_Borrower_details'. Cannot insert duplicate key in object 'dbo.Borrower_details'. The duplicate key value is (123234578).".


[To Loan Tbl [267]] Error: SSIS Error Code DTS_E_OLEDBERROR.  An OLE DB error has occurred. Error code: 0x80004005.
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80004005  Description: "The statement has been terminated.".
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80004005  Description: "The INSERT statement conflicted with the FOREIGN KEY constraint "FK_LoanToBorrower_tbls". The conflict occurred in database "STG_Mortgage_Project", table "dbo.Borrower_details", column 'SSN'.".

[To Financiall tbl [228]] Error: SSIS Error Code DTS_E_OLEDBERROR.  An OLE DB error has occurred. Error code: 0x80004005.
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80004005  Description: "The statement has been terminated.".
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80004005  Description: "The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Borrower_details". The conflict occurred in database "STG_Mortgage_Project", table "dbo.Borrower_details", column 'SSN'.".


   */