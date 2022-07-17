USE [SoftUni]

--3.Find all Department Names
SELECT [Name]
	FROM [Departments]

--4. Find Salary of Each Employee
select FirstName, LastName, Salary 
	from Employees

--5.	Find Full Name of Each Employee
select FirstName, MiddleName, LastName
	from Employees

--6.	Find Email Address of Each Employee
select FirstName + '.' + LastName + '@'+ 'softuni.bg'
	as [Full Email Address]
	from Employees

	-- втори вариант с конкат

select CONCAT(FirstName, '.',LastName,'@','softuni.bg')
	as [Full Email Address]
	from Employees
	-- извън задачата

select CONCAT_WS('! ',FirstName, '.',LastName,'@','softuni.bg') -- WS - with separator - string.Join

	as [Full Email Address]
	from Employees

--7.	Find All Different Employees’ Salaries

SELECT DISTINCT [Salary] -- distinct изважда само уникални стойности
	FROM [Employees]

--9.	Find Names of All Employees by Salary in Range

SELECT [FirstName], [LastName], [JobTitle]
	FROM [Employees]
	WHERE [Salary] BETWEEN 20000 AND 30000

--10.	Find Names of All Employees

SELECT CONCAT([FirstName],' ',[MiddleName],' ', [LastName])
	AS [Full Name]
	FROM [Employees]
	WHERE [Salary] IN(25000, 14000, 12500, 23600)
	
--11.	Find All Employees Without a Manager

SELECT [FirstName], [LastName]
	FROM [Employees]
	WHERE [ManagerId] IS NULL -- IS NOT

--13.	Find 5 Best Paid Employees.

SELECT TOP (5) [FirstName], [LastName]
	FROM [Employees]
	ORDER BY [Salary]  DESC

--15.	Sort Employees Table

SELECT *
	FROM [Employees]
	ORDER BY [Salary]  DESC, [FirstName], [LastName] DESC, [MiddleName] 

--17.	Create View Employees with Job Titles

GO
CREATE VIEW [V_EmployeeNameJobTitle]
	AS
	SELECT CONCAT([FirstName],' ',[MiddleName],' ', [LastName])
		AS [Full Name], 
			[JobTitle]
	FROM [Employees]
GO

GO

SELECT * FROM [V_EmployeeNameJobTitle]

GO

--19.	Find First 10 Started Projects

SELECT TOP (10) *
	FROM [Projects]
ORDER BY [StartDate], [Name]


	-- как се форматира дата
	SELECT TOP (10) *, FORMAT([StartDate], 'dd-MM-yyyy') AS [StartDate Formatted]
		FROM [Projects]
	ORDER BY [StartDate], [Name]

--21.	Increase Salaries --Helper Queries
	
SELECT *
	FROM [Employees]

SELECT *
	FROM [Departments]
WHERE [Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')
	------------
--21.	Increase Salaries
UPDATE [Employees]
	SET [Salary] += [Salary] * 0.12
WHERE [DepartmentID] IN (1, 2, 4, 11)

SELECT [Salary]
	FROM [Employees]

	-- друг вариант 
UPDATE [Employees]
	SET [Salary] *= 1.12
WHERE [DepartmentID] IN (
						SELECT [DepartmentID]
						FROM [Departments]
						WHERE [Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')
						)
---


USE [Geography]

--24.	*Countries and Currency (Euro / Not Euro)
SELECT [CountryName], [CountryCode],
		CASE
			WHEN [CurrencyCode] = 'EUR' then 'Euro'
			ELSE 'Not Euro'
		END AS [Currency]
	FROM [Countries]
ORDER BY [CountryName]