USE SoftUni

GO

CREATE OR ALTER PROC usp_AddEmployeeToProject (@EmployeeID INT, @ProjectID INT)
AS
BEGIN
    DECLARE @NumberOfProjects INT
    SET @NumberOfProjects = 
    (SELECT COUNT(*) FROM EmployeesProjects 
    WHERE EmployeeID = @EmployeeID)
    IF(@NumberOfProjects > 3)
    BEGIN
        THROW 50001, 'Cant work that hard', 1
    END
    INSERT INTO EmployeesProjects(EmployeeID, ProjectID) VALUES (@EmployeeID, @ProjectID)
END

EXEC dbo.usp_AddEmployeeToProject 237, 12


--1.	Employees with Salary Above 35000

GO

CREATE OR ALTER PROC usp_GetEmployeesSalaryAbove35000 
AS
BEGIN
	SELECT FirstName,
		   LastName
	  FROM Employees
	 WHERE Salary > 35000
END

GO

EXEC dbo.usp_GetEmployeesSalaryAbove35000

GO

--2.	Employees with Salary Above Number

CREATE PROC usp_GetEmployeesSalaryAboveNumber @minSalary DECIMAL(18,4)
AS
BEGIN
	SELECT FirstName,
		   LastName
	  FROM Employees
	  WHERE Salary >= @minSalary
END

GO

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100
EXEC dbo.usp_GetEmployeesSalaryAboveNumber 35000
EXEC dbo.usp_GetEmployeesSalaryAboveNumber 20000

GO

--4.	Employees from Town

CREATE PROC usp_GetEmployeesFromTown @townName VARCHAR(50)
AS
BEGIN
	SELECT FirstName,
		   LastName
	  FROM Employees
	    AS e
LEFT JOIN Addresses
		AS a
		ON e.AddressID = a.AddressID
LEFT JOIN Towns
		AS t
		ON a.TownID = t.TownID
	WHERE t.Name = @townName
END

GO

EXEC dbo.usp_GetEmployeesFromTown 'Sofia'
EXEC dbo.usp_GetEmployeesFromTown 'Monroe'

GO

--5.	Salary Level Function

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(8)

	IF @salary < 30000
	BEGIN
		SET @salaryLevel = 'Low'
	END

	ELSE IF @salary BETWEEN 30000 AND 50000
	BEGIN
		SET @salaryLevel = 'Average'
	END

	ELSE IF @salary > 50000
	BEGIN
		SET @salaryLevel = 'High'
	END

	RETURN @salaryLevel
END

GO

SELECT Salary,
	   dbo.ufn_GetSalaryLevel(Salary)
    AS SalaryLevel
  FROM Employees

GO

--6.	Employees by Salary Level

CREATE PROCEDURE usp_EmployeesBySalaryLevel @salaryLevel VARCHAR(8)
AS
BEGIN
	SELECT FirstName,
		   LastName
	  FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel
END

GO

EXECUTE dbo.usp_EmployeesBySalaryLevel 'Low'
EXECUTE dbo.usp_EmployeesBySalaryLevel 'High'

GO

--7.	Define Function

CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
AS
BEGIN
	DECLARE @isWordCompromised BIT = 1
	DECLARE @i INT = 1

	WHILE @i <= LEN(@word)
	BEGIN
		DECLARE @currentWordLetter CHAR(1) = SUBSTRING(@word, @i, 1)
		DECLARE @j INT = 1

		WHILE @j <= LEN(@setOfLetters)
		BEGIN
			DECLARE @currentSetLetter CHAR(1) = SUBSTRING(@setOfLetters, @j, 1)

			IF @currentWordLetter = @currentSetLetter
			BEGIN
				SET @isWordCompromised = 1
				BREAK
			END

			SET @j += 1
		END

		IF @isWordCompromised = 0
		BEGIN
			RETURN 0
		END
		SET @isWordCompromised = 0
		SET @i += 1

	END

	RETURN 1
END

GO

SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia')
SELECT dbo.ufn_IsWordComprised('oistmiahf', 'halves')

GO

--8.	* Delete Employees and Departments

CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN

	DELETE FROM EmployeesProjects
		WHERE EmployeeID IN (
							 SELECT EmployeeID
							   FROM Employees
							  WHERE DepartmentID = @departmentId	
							)
	   UPDATE Employees
		  SET ManagerID = NULL
		WHERE ManagerID IN (
							 SELECT EmployeeID
							   FROM Employees
							  WHERE DepartmentID = @departmentId
							)
						
	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT

	UPDATE Departments 
	SET ManagerID = NULL
	WHERE ManagerID IN (
							 SELECT EmployeeID
							   FROM Employees
							  WHERE DepartmentID = @departmentId
							)

	DELETE FROM Employees
		  WHERE DepartmentID = @departmentId

	DELETE FROM Departments
		  WHERE DepartmentID = @departmentId

	SELECT COUNT(EmployeeID)
		FROM Employees
		WHERE DepartmentID = @departmentId
END

GO

EXEC dbo.usp_DeleteEmployeesFromDepartment 2

GO

USE Diablo

GO

--13.	*Table Function: Cash in User Games Odd Rows
CREATE FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(50))
RETURNS TABLE
AS RETURN (
			SELECT SUM(Cash)
					AS SumCash
				FROM (
						SELECT  ug.Cash,
								ROW_NUMBER() OVER(ORDER BY ug.Cash DESC)
							AS RowNumber
							FROM UsersGames
							AS ug
						LEFT JOIN Games
							AS g
							ON ug.GameID = g.ID
							WHERE g.Name = 'Love in a mist' 
					) AS RowNumberSubquery
				WHERE RowNumber % 2 != 0
		)	

GO


SELECT * FROM ufn_CashInUsersGames('Love in a mist') 
