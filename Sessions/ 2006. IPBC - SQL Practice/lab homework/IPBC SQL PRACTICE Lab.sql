/* 1. How many are active from each group. Return the answers in one query and put the results in a table variable.
a. Paths
b. Courses
c. Sections
d. Events
*/

Declare @ActiveCountTable table (ActiveCount int)

Insert into		@ActiveCountTable 
Select			Count(E.EventActive) as ActiveCount
From			[dbo].[ADF_Event] as E
Where			E.EventActive = 'y'
Union All
Select			Count(S.SectionActive) as SectionActiveCount 
From			[dbo].[ADF_Section] as S
Where			S.SectionActive  = 'y'
Union All
Select			Count(C.CourseActive) as CourseActiveCount
From			[dbo].[ADF_Course] as C
Where			C.CourseActive = 'y'
Union All
Select			Count(p.PathActive) as PathActiveCount
From			[dbo].[ADF_Path] as P
Where			p.PathActive = 'y'

Select			*
From			@ActiveCountTable

Go

--2. How many documents have been created but not attached to the Curriculum.

Select  Count(*) As DocNotAttached
From	[dbo].[ADF_Document]
Where	IsAttached = 0

--3. How many active events are there in each Course? Sort from largest to smallest


Select			Count(*) as ActiveCourseCount, C.CourseName
From			[dbo].[ADF_Event] as e
Inner join		[dbo].[ADF_Section] as s
On				s.SectionID = e.SectionID
Inner join		[dbo].[ADF_Course] as c
on				c.CourseID = S.CourseID
Where			e.EventActive = 'y'
Group by		C.CourseName
Order by		ActiveCourseCount desc

--4. Create a View that outlines the whole curriculum in the correct order.
Go
Create View [CurriculumOutline]
as
Select		S.CourseID, C.CourseName, C.CourseDesc, S.SectionID, S.SectionName, S.SectionOrder,						S.SectionDesc
From		[dbo].[ADF_Section] as S
Inner join	[dbo].[ADF_Course] as C
On			S.CourseID = C.CourseID
Go

Select		*
From		[CurriculumOutline]

--5. How many of each Event Type’s are included in the Active Curriculum.

Select		E.EventTypeName, Count(E.EventTypeID) as timesIncluded
From		[dbo].[ADF_Document] as D
Inner join	[dbo].[ADF_EventType] as E
on			E.EventTypeID = D.EventTypeID
Where		D.IsActive = 1
Group by	E.EventTypeName


--6. Create a SP that accepts CourseID as a parameter and returns SectionName, DocumentName and			   EventType’s stored in the Course passed into the SP.
go
Create proc UDF_SP_RtnNamesEType
 @CourseID int
As
	set nocount on
	Begin
		Select		s.SectionName,D.DocumentName,E.EventTypeName --,d.DocumentID, D.EventTypeID
		From		[dbo].[ADF_Document] as d
		inner join		[dbo].[ADF_Section] as s
		on			D.DocumentName like  Concat(S.SectionName , '%')
		inner join		[dbo].[ADF_EventType] as E
		On			E.EventTypeID = D.EventTypeID
		Where		S.CourseID =@CourseID --1000
End

Exec UDF_SP_RtnNamesEType'1000'

--7. Create INSERT Statements to add 1 record into each of the 6 tables.

Insert into [dbo].[ADF_Section]
values (5000,getdate(),5001,'Know what to ask on serch engine',1,'Searching specific error to solve',1,'y',Null)

Insert into [dbo].[ADF_Course]
values	(5000,'Search errors',5000,1,'Learn to search online for errors','y',getdate())

Insert into		[dbo].[ADF_Event](EventName,DocumentID,SectionID,EventOrder,EventActive,Insertdate,Repeat)
values(null,5011,5001,1,'Y',getdate(),null)

Insert into		[dbo].[ADF_Path]
values(5000,'SQL Error','Search online solution in sql','y',getdate(),1,0,5002,'This is basic course to understand how to seach online for sql query errors','2 wks',0,'Internet and laptop')

Insert into		[dbo].[ADF_EventType](EventTypeName)
Values			('Online')

Insert into		[dbo].[ADF_Document](DocumentName,DocumentDesc,DocumentLink,EventTypeID,IsAttached,IsActive)
values('Class 1','class 1 of course 5000','www.google.com',1008,1,1)

--8. Create UPDATE Statements for each table (Except ADF_EventType) to mark one Active record from each table as Inactive.

Update		[dbo].[ADF_Document]
set			IsActive = 0
Where		EventTypeID = 1008

Update		[dbo].[ADF_Path]
set			PathActive = 'N'
Where		PathID = 5000

Update		[dbo].[ADF_Event]
Set			EventActive = 'N'
Where		EventID = 1744

Update		[dbo].[ADF_Course]
Set			CourseActive = 'N'
Where		CourseID = 5000

Update		[dbo].[ADF_Section]
Set			SectionActive = 'N'
Where		CourseID = 5000


