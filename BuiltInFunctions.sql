--Problem 1.	Find Names of All Employees by First Name

SELECT FirstName, LastName
FROM Employees
--WHERE FirstName LIKE 'Sa%' -- With WildCards
WHERE LEFT(FirstName, 2) = 'Sa'

--Problem 2.	Find Names of All employees by Last Name 

SELECT FirstName, LastName
FROM Employees
--WHERE LastName LIKE '%ei%'
WHERE CHARINDEX('ei', LastName) != 0

--Problem 3.	Find First Names of All Employees

SELECT FirstName
FROM Employees
WHERE DepartmentID IN (3, 10) AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

--Problem 4.	Find All Employees Except Engineers

SELECT FirstName, LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

--Problem 5.	Find Towns with Name Length

SELECT Name
FROM Towns
WHERE LEN(Name) IN (5, 6)
ORDER BY Name

--Problem 6.	Find Towns Starting With

SELECT *
FROM Towns
WHERE LEFT([Name], 1) In ('M', 'K', 'B', 'E')
ORDER BY [Name]

--Problem 10.	 Rank Employees by Salary

SELECT EmployeeID, FirstName, LastName, Salary,
    DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID)
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--Problem 11.	Find All Employees with Rank 2 *

SELECT *
FROM (
            SELECT EmployeeID, FirstName, LastName, Salary,
        DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID)
            AS [Rank]
    FROM Employees
    WHERE Salary BETWEEN 10000 AND 50000 
        )
    AS [RankingSubquery]
WHERE [Rank] = 2
ORDER by Salary DESC

--Problem 12.	Countries Holding 'A' 3 or More Times
GO
USE [Geography]
GO

SELECT CountryName, IsoCode
--,REPLACE(CountryName, 'a', '') AS [R]
FROM Countries
--WHERE LOWER(CountryName)  LIKE '%a%a%a%'
WHERE LEN(CountryName) - LEN(REPLACE(CountryName, 'a', '')) >= 3
ORDER BY IsoCode

--Problem 13.	 Mix of Peak and River Names

SELECT  p.PeakName, r.RiverName,
    LOWER(CONCAT(LEFT(p.PeakName, LEN(p.PeakName)-1), r.RiverName))
    AS Mix
FROM Rivers AS [r]
    , Peaks AS [p]
WHERE RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
ORDER BY Mix

--Problem 15.	 User Email Providers
GO
USE Diablo 
GO


  SELECT [Username],
    SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email]))
    AS [Email Provider]
  FROM Users
ORDER BY [Email Provider],[Username]

--Problem 17.	 Show All Games with Duration and Part of the Day

SELECT [Name],
        CASE 
            WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
            WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS [Part of the Day],
        CASE
            WHEN [Duration] <= 3 THEN 'Extra Short'
            WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
            WHEN [Duration] > 6 THEN 'Long'
            ELSE 'Extra Long'
        END AS [Duration]
    FROM Games as [g]
    ORDER BY g.Name, Duration, [Part of the Day]