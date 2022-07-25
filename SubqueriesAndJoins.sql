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

--8.	Employee 24











