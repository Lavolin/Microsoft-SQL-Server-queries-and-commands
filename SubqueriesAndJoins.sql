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

--17. Highest Peak and Longest River by Country

    SELECT TOP 5 c.CountryName,
      MAX(p.Elevation) AS HighestPeakElevation,
      MAX(r.Length) AS LongestRiverLenght
      FROM Countries AS c 
LEFT JOIN CountriesRivers AS cr 
  ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r 
  ON cr.RiverId = r.Id
LEFT JOIN MountainsCountries AS mc 
  ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m
  ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p 
  on p.MountainId = m.Id
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLenght DESC, CountryName

--18. Highest Peak Name and Elevation by Country

 SELECT TOP (5) Country,
            CASE 
              WHEN PeakName IS NULL THEN '(no highest peak)'
              ELSE PeakName
            END AS [Highest Peak Name],
            CASE 
              WHEN Elevation IS NULL THEN 0
              ELSE Elevation
            END AS [Highest Peak Elevation],
            CASE
              WHEN MountainRange IS NULL THEN '(no mountain)'
              ELSE MountainRange 
            END AS [Mountain]
            FROM(   
                    SELECT c.CountryName AS Country,
                          m.MountainRange,
                          p.PeakName,
                          p.Elevation, 
                          DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC)
                          AS PeakRank
                    FROM Countries AS c
                LEFT JOIN MountainsCountries AS mc 
                    ON mc.CountryCode = c.CountryCode
                LEFT JOIN Mountains AS m 
                    ON mc.MountainId = m.Id
                LEFT JOIN Peaks AS p 
                    on p.MountainId = m.Id
                ) AS PeakRankingQuery
WHERE PeakRank =1
ORDER BY Country, [Highest Peak Name]









