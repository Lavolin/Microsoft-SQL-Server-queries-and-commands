USE SoftUni

GO
--1.	Employee Address

SELECT TOP 5 EmployeeID, JobTitle, e.AddressID, a.AddressText
FROM Employees AS e
    LEFT JOIN Addresses AS a 
    ON e.AddressID = a.AddressID
    ORDER BY a.AddressID

--5.	Employees Without Project

SELECT TOP 3 e.EmployeeID, e.FirstName
FROM Employees AS e
    LEFT JOIN EmployeesProjects AS ep 
    ON e.EmployeeID = ep.EmployeeID
    WHERE ep.ProjectID IS NULL
    ORDER BY e.EmployeeID

--7.	Employees with Project

 SELECT TOP 5 e.EmployeeID, e.FirstName,
                p.Name AS ProjectName
  FROM Employees AS e
INNER JOIN EmployeesProjects AS ep
 ON e.EmployeeID = ep.EmployeeID 
INNER JOIN Projects AS p
    ON ep.ProjectID = p.ProjectID
  WHERE p.StartDate > 08/13/2002 AND p.EndDate IS NULL
    ORDER BY e.EmployeeID

--9.	Employee Manager Self refference

SELECT e.EmployeeID, 
       e.FirstName,
         m.EmployeeID AS ManagerID,
         m.FirstName AS ManagerName
  FROM Employees AS e
INNER JOIN Employees AS m
  ON e.ManagerID = m.EmployeeID
WHERE m.EmployeeID IN (3, 7)
ORDER BY e.EmployeeID

GO

USE [Geography]

GO

--12. Highest Peaks in Bulgaria

SELECT mc.CountryCode,
      m.MountainRange,
      p.PeakName,
      p.Elevation
  FROM Peaks AS p
INNER JOIN Mountains AS m
  ON p.MountainId = m.Id
INNER JOIN MountainsCountries AS mc
  ON m.Id = mc.MountainId
WHERE mc.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

--13. Count Mountain Ranges

SELECT c.CountryCode,
 COUNT(mc.CountryCode) AS MountainRanges
  FROM Countries AS c
LEFT JOIN MountainsCountries AS mc
  ON c.CountryCode = mc.CountryCode
  WHERE c.CountryName IN ('Bulgaria', 'Russia', 'United States')
GROUP BY c.CountryCode

--15. *Continents and Currencies

SELECT ContinentCode,
      CurrencyCode,
      CurrencyUsage
FROM(
  SELECT *,
  DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY CurrencyUsage DESC) 
  AS CurrencyRank
  FROM(
      SELECT co.ContinentCode,
          c.CurrencyCode,
      COUNT(c.CurrencyCode) AS CurrencyUsage
      FROM Continents AS co
    LEFT JOIN Countries AS c
    ON c.ContinentCode = co.ContinentCode
  GROUP BY co.ContinentCode, c.CurrencyCode
  ) AS CurrencyUsage
  WHERE CurrencyUsage > 1
  ) AS CurrencyRankingQuerry
WHERE CurrencyRank = 1
ORDER BY ContinentCode











