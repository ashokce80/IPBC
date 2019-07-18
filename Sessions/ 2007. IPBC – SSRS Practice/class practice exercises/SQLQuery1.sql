--Curriculum Count (Pie Chart) – This will display a pie chart showing the Count of Active Paths / Courses / Sections / Events

Select		S.CourseID, C.CourseName, C.CourseDesc, S.SectionID,						  S.SectionName, S.SectionOrder,S.SectionDesc, C.CourseActive,					  S.SectionActive
From		[dbo].[ADF_Section] as S
Inner join	[dbo].[ADF_Course] as C
On			S.CourseID = C.CourseID
Where		C.CourseActive = 'y'
AND			S.SectionActive = 'y'


Go
Alter View [CurriculumOutline]
as
Select		S.CourseID, C.CourseName, C.CourseDesc, S.SectionID, S.SectionName, S.SectionOrder,S.SectionDesc,C.CourseActive, S.SectionActive, E.EventActive, E.EventID, C.PathID
From		[dbo].[ADF_Section] as S
Inner join	[dbo].[ADF_Course] as C
On			S.CourseID = C.CourseID
Inner join	[dbo].[ADF_Event] as E
On			E.SectionID = S.SectionID
Go

Select 		 *
From		[CurriculumOutline]

Select 	distinct	CourseName , CourseActive-- SectionActive --,
From		[CurriculumOutline]

Select 	distinct	SectionName, SectionActive 
From		[CurriculumOutline]

Select 		 EventActive	
From		[CurriculumOutline]

Select		CourseActive
From		[dbo].[ADF_Course]
Where		CourseActive ='y'


Select		distinct EventID
From		[dbo].[ADF_Event]

--Count of Active Paths / Courses / Sections / Events

Select 		*
From		[CurriculumOutline]

Select 		*
From		[dbo].[ADF_Path]

Select 		*
From		[dbo].[ADF_Course] 

Select 		*
From		[dbo].[ADF_Section] 

Select		*
From		[dbo].[ADF_Event]

Select 		Count(distinct CourseName),
			Count(distinct SectionName) --,	Count(CourseName)  -- SectionActive
From		[CurriculumOutline]
Where		CourseActive = 'y'
or			SectionActive = 'y'

Select 		Count(distinct CourseName) as ActCourseCnt
From		[CurriculumOutline]
Where		CourseActive = 'y'
union all
Select		Count(distinct SectionName) as ActSectionCnt
From		[CurriculumOutline]
Where		SectionActive = 'y'
union all
Select		Count(distinct EventID) as ActSectionCnt
From		[dbo].[ADF_Event]
Where		EventActive = 'y'






Select 	distinct	SectionName
From		[CurriculumOutline]
Where		 SectionActive ='y'

--And			SectionActive ='y'

group by	CourseName

union all

Select 	distinct	SectionName
From		[CurriculumOutline]
Where		 SectionActive ='y'


Select 		 EventActive	
From		[CurriculumOutline]

Select 	distinct  c.SectionName, C.SectionActive
				  ,c.CourseName, C.CourseActive,C.EventActive			--,P.PathActive
From		[CurriculumOutline] as C


Inner join	[dbo].[ADF_Path] as P
ON			C.PathID = P.PathID


-----------------------------------

Select 		*
From		[dbo].[ADF_Path]

Select 		*
From		[dbo].[ADF_Course] 
Where		CourseActive = 'y'

Select 		*
From		[dbo].[ADF_Section] 
Where		SectionActive = 'y'

Select		*
From		[dbo].[ADF_Event]
Where		EventActive = 'y'

Select 		Count( Case 
					when S.SectionActive = 'y' then S.SectionActive end),
			Count(Case 
					when c.CourseActive = 'y' then C.CourseActive end)
From		[dbo].[ADF_Course] as C
full join	[dbo].[ADF_Section] as S
On			s.CourseID = c.CourseID


Select 		Count( Case 
					when S.SectionActive = 'y' then S.SectionActive end)
From			[dbo].[ADF_Section] as S

Select			Count(Case 
					when c.CourseActive = 'y' then C.CourseActive end)
From		[dbo].[ADF_Course] as C

full join	[dbo].[ADF_Path] as p
on			C.PathID = p.PathID  
Where		s.SectionActive ='y'
And			c.CourseActive = 'y'
And			P.PathActive = 'y'

Select		E.EventID,S.SectionID,C.CourseID,P.PathID
--into		#allID
From		[dbo].[ADF_Event] E
left join	[dbo].[ADF_Section] S 
On			E.SectionID = S.SectionID
left join	[dbo].[ADF_Course] C
on			C.CourseID = S.CourseID
left join	[dbo].[ADF_Path] P
on			P.PathID = C.PathID	
Where		E.EventActive = 'y'
And			s.SectionActive ='y'
And			c.CourseActive = 'y'
And			P.PathActive = 'y'

group by	E.EventID,S.SectionID,C.CourseID,P.PathID
HAVING		count(*) >= 1 		

Select		 PathID,CourseID
From		#allID
Group by	 PathID,CourseID
HAVING count(*) >= 1 



Select			*
From			(Select COUNT([PathID]) AS CountOfActivePath FROM [dbo].[ADF_Path] WHERE								[PathActive] = 'Y') p
Cross join		(Select COUNT([CourseID]) AS CountOfActiveCourse FROM [dbo].[ADF_Course] WHERE							[CourseActive] = 'Y') C
Cross join		(Select COUNT([SectionID]) AS CountOfActiveSection FROM [dbo].[ADF_Section] WHERE						[SectionActive] = 'Y') S
Cross join		(Select COUNT([EventID]) AS CountOfEventActive FROM [dbo].[ADF_Event] WHERE								[EventActive] = 'Y' ) E

Select distinct [PathID] as Path
FROM			[dbo].[ADF_Path]
WHERE			[PathActive] = 'Y'

create table	ActiveCount(Name varchar(50), cnt int)

Insert into		ActiveCount
Select			('Path'),( Select COUNT([PathID]) AS CountOfActivePath FROM [dbo].[ADF_Path] WHERE								[PathActive] = 'Y')
Union			
Select			('Course'),(Select COUNT([CourseID]) AS CountOfActiveCourse FROM [dbo].[ADF_Course]						WHERE [CourseActive] = 'Y')
Union			
Select			('Section'),(Select COUNT([SectionID]) AS CountOfActiveSection FROM [dbo].								[ADF_Section] WHERE	[SectionActive] = 'Y')
Union
Select			('Event'),(Select COUNT([EventID]) AS CountOfEventActive FROM [dbo].[ADF_Event]							WHERE [EventActive] = 'Y' )

Select			*
From			ActiveCount

----------------------------
--Course Event Count (Bar Chart) – This will display each course with a label that displays a count of the # of Events in that course.

Select		CourseID, CourseName, Count(EventID) as EventCount
From		[CurriculumOutline]
Where		CourseID in (Select distinct CourseID From [CurriculumOutline])
Group by	CourseID, CourseName
Order by	CourseID


-------------------------
--Curriculum Manager (Matrix) – This will display a matrix with Drilldowns for every group on the following …


Select 		*
From		[dbo].[ADF_Path]

Select 		*
From		[dbo].[ADF_Course] 

Select 		*
From		[dbo].[ADF_Section] 

Select		*
From		[dbo].[ADF_Event]

Select		P.PathID,P.PathName, P.PathDesc
			,C.CourseID,C.CourseName,c.CourseDesc
			,S.SectionID,S.SectionName,S.SectionDesc
			,E.EventID,ISNULL(E.EventName,'No Name') as EventName
From		[dbo].[ADF_Event] E
left join	[dbo].[ADF_Section] S 
On			E.SectionID = S.SectionID
left join	[dbo].[ADF_Course] C
on			C.CourseID = S.CourseID
left join	[dbo].[ADF_Path] P
on			P.PathID = C.PathID	
Where		P.PathID is not null
Order by	P.PathID,C.CourseID,S.SectionID,E.EventID

