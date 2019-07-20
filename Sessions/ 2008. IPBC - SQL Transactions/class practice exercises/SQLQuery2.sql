
Select	*
From	[dbo].[emp]


Begin Tran
	Update	emp Set empName = 'Tiffanny' where empId = 11
	waitfor delay '00:00:15'
Rollback tran

	Select	*
	From	[dbo].[emp]


 	Select	*
	From	[dbo].[emp]

Select	@@TRANCOUNT

	Update	emp Set empName = 'Tiffan' where empId = 11

	Dbcc useroptions 

Set Transaction	isolation level read committed
begin tran
	Select	* From emp
	waitfor delay '00:00:15'
	Select	* From	emp
commit

Update	emp Set empName = 'Tianny' where empId = 11 

