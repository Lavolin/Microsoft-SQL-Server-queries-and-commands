CREATE TABLE [People](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL, 
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3,2),
	[Weight] DECIMAL(5,2),
	[Gender] CHAR(1) NOT NULL,
	CHECK ([Gender] = 'm' OR [Gender] = 'f'),
	[Birthdate] DATETIME2 NOT NULL,
	[Biography] NVARCHAR(MAX)
)


SELECT 
	CONCAT(FirstName, ' ',LastName) AS [FullName]
	,JobTitle
	,FORMAT(Salary, N'0.00 лв.') AS Salary
FROM Employee


SELECT DISTINCT
	CONCAT(FirstName, ' ',LastName) AS FullName
FROM Employee
WHERE DepartmentId = 7

SELECT *
FROM Employee
ORDER BY Salary DESC
-- ORDER BY Salary ASC


CREATE VIEW v_EmployeeSalary AS -- създаване на вю
SELECT
	FirstName,
	LastName,
	Salary
FROM Employee


SELECT *
FROM v_EmployeeSalary
WHERE Salary > 10000
ORDER BY FirstName, LastName


CREATE VIEW v_HighestPeak AS
SELECT TOP(1) *
FROM Peaks
ORDER BY Elevation DESC


INSERT INTO Towns ([Name]) 
VALUES ('Paris')
	,('Sofia');


INSERT INTO Projects
([Name], StartDate)
SELECT 
	CONCAT('Department', [Name])
	,GETDATE()
FROM Departments

DELETE FROM Towns
WHERE TownId > 32


UPDATE v_Employees
	SET 
		FirstName = 'Petar',
		LastName = 'Petrov'
	WHERE EmployeeId = 1


UPDATE Projects
	SET EndDate = GETDATE()
	WHERE EndDate = NULL