
Select * 
From	[dbo].[ADF_Section]

Select * 
From	[dbo].[ADF_Course]

Select			Count(*) as ActiveCourseCount, C.CourseName
From			[dbo].[ADF_Event] as e
Inner join		[dbo].[ADF_Section] as s
On				s.SectionID = e.SectionID
Inner join		[dbo].[ADF_Course] as c
on				c.CourseID = S.CourseID
Where			e.EventActive = 'y'
Group by		C.CourseName
Order by		ActiveCourseCount desc

Select			*
From			[dbo].[ADF_Event] as E
Inner join		[dbo].[ADF_Section] as S
On				E.SectionID = S.SectionID
Where			S.CourseID = 1000
