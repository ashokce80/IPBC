Use ashok_lab1
Go
--create temp table if not exist in tempDB will hold them
IF OBJECT_ID ('tempDB..#Customer_Orig') IS NOT NULL DROP TABLE #Customer_Orig;
IF OBJECT_ID ('tempDB..#Customer_New')  IS NOT NULL DROP TABLE #Customer_New;
 
CREATE TABLE #Customer_Orig
(  CustomerNum    TINYINT NOT NULL
  ,CustomerName   VARCHAR (25) NULL
  ,Planet         VARCHAR (25) NULL);
 
CREATE TABLE #Customer_New
(  CustomerNum    TINYINT NOT NULL
  ,CustomerName   VARCHAR (25) NULL
  ,Planet         VARCHAR (25) NULL);
-- insert data into those tbls
INSERT INTO #Customer_Orig (CustomerNum, CustomerName, Planet)
   VALUES (1, 'Anakin Skywalker', 'Tatooine')
         ,(2, 'Yoda', 'Coruscant')
         ,(3, 'Obi-Wan Kenobi', 'Coruscant');
INSERT INTO #Customer_New (CustomerNum, CustomerName, Planet)
   VALUES (1, 'Anakin Skywalker', 'Tatooine')
         ,(2, 'Yoda', 'Coruscant')
         ,(3, 'Obi-Wan Kenobi', 'Coruscant');

--- Old way to update, insert and delete records
-- here one table is original and another is it's backup

--changes in Customer_Orig tbl
-- Update Yoda's Name
UPDATE #Customer_Orig
   SET CustomerName = 'Master Yoda'
 WHERE CustomerNum = 2
-- Delete Anakin
DELETE #Customer_Orig
 WHERE CustomerNum = 1
--Add Darth
INSERT INTO #Customer_Orig (CustomerNum, CustomerName, Planet)
VALUES (4, 'Darth Vader', 'Death Star')

Select	* 
From	#Customer_Orig

Select	* 
From	 #Customer_New 

-- as original tbl is updated we need to make all changes of data to new tbl or backup tbl
-- with old way using joins

--Process Updates  
Update Tgt
Set		Tgt.CustomerName = Src.CustomerName, Tgt.Planet = Src.Planet
FROM		#Customer_New Tgt 
Inner JOIN	#Customer_Orig Src ON Tgt.CustomerNum = Src.CustomerNum
Where		Tgt.CustomerName <> Src.CustomerName 
Or			Tgt.Planet <> Src.Planet -- Eliminates needless updates.

--Process Inserts
Insert Into #Customer_New
SELECT		Src.CustomerNum, Src.CustomerName, Src.Planet
FROM		#Customer_Orig Src 
LEFT JOIN	#Customer_New Tgt 
ON			Tgt.CustomerNum = Src.CustomerNum
Where		Tgt.CustomerNum is null;
--Process Deletes
Delete From	Tgt
From        #Customer_New as Tgt 
LEFT JOIN	#Customer_Orig Src 
ON			Tgt.CustomerNum = Src.CustomerNum
Where       Src.CustomerNum is null;

--- test for delete
-- delete from original tbl
DELETE #Customer_Orig
WHERE CustomerNum = 3

Select	* 
From	#Customer_Orig

Select	* 
From	#Customer_New 

--delete from new/backup tbl
Delete			Tgt -- eliminated extra from
From			#Customer_New as Tgt
Left join		#Customer_Orig as Src 
On				Tgt.CustomerNum = Src.CustomerNum
Where			Src.CustomerNum is null;

--- above same 3 statement with Merge which is one statement

MERGE	#Customer_New AS Target
USING	#Customer_Orig AS Source
ON		Target.CustomerNum = Source.CustomerNum
WHEN	MATCHED
        AND (Target.CustomerName <> Source.CustomerName
			OR Target.Planet <> Source.Planet)
THEN
UPDATE 
SET		 Target.CustomerName = Source.CustomerName
		,Target.Planet = Source.Planet

WHEN NOT MATCHED BY TARGET
THEN
INSERT (CustomerNum, CustomerName, Planet)
VALUES (Source.CustomerNum, Source.CustomerName, Source.Planet)

WHEN NOT MATCHED BY SOURCE THEN DELETE;-- ; is needed to end merge

-- what if original tbl have Null
-- lets make null in original first

Update	CO set Planet = NULL
FROM	#Customer_Orig CO
WHERE	CustomerNum = 2 -- Obi-Wan Kenobi

Select	* 
From	#Customer_Orig

Select	* 
From	#Customer_New 
--- lets update data in backup/ target tbl for Null to handle with Exists word

MERGE  #Customer_New AS Target
 USING #Customer_Orig AS Source
    ON Target.CustomerNum = Source.CustomerNum
WHEN MATCHED AND EXISTS --- this one is used and some next line code
                    (SELECT Source.CustomerName, Source.Planet
                     EXCEPT
                     SELECT Target.CustomerName, Target.Planet)
THEN
   UPDATE SET
      Target.CustomerName = Source.CustomerName
     ,Target.Planet = Source.Planet
WHEN NOT MATCHED BY TARGET
THEN
   INSERT (CustomerNum, CustomerName, Planet)
   VALUES (CustomerNum, Source.CustomerName, Source.Planet)
WHEN NOT MATCHED BY SOURCE THEN DELETE;

Select	* 
From	#Customer_Orig

Select	* 
From	#Customer_New 

Update	[dbo].[boy]
Set		Name = 'RrrYYY'
WHERE	id = 1

Select	*
From	 [dbo].[boy]

Select	Binary_CheckSum(*) as BCH from [dbo].[boy]
