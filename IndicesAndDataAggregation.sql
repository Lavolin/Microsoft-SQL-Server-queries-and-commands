USE Gringotts

GO

--3. Longest Magic Wand Per Deposit Groups

SELECT DepositGroup,
    MAX(MagicWandSize) AS LongestMagicWand
    FROM WizzardDeposits
GROUP BY DepositGroup

--4. * Smallest Deposit Group Per Magic Wand Size

SELECT TOP(2) DepositGroup
        FROM WizzardDeposits
    GROUP BY DepositGroup
    ORDER BY AVG(MagicWandSize)

--5. Deposits Sum

SELECT DepositGroup,
        SUM(DepositAmount) AS TotalSum
    FROM WizzardDeposits
GROUP BY DepositGroup

--6. Deposits Sum for Ollivander Family

SELECT DepositGroup,
    SUM(DepositAmount) AS TotalSum         
    FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--9. Age Groups
SELECT AgeGroup,
    COUNT(*) AS WizardCount
 FROM(
        SELECT Age,
                CASE
                    WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
                    WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
                    WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
                    WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
                    WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
                    WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
                    WHEN Age > 60 THEN '[61+]'
                END 
            AS AgeGroup
            FROM WizzardDeposits
     ) AS AgeGroupSubQuery
GROUP BY AgeGroup

--11. Average Interest 

SELECT DepositGroup,
       IsDepositExpired,
       AVG(DepositInterest)
     AS AverageInterest
    FROM WizzardDeposits
  WHERE DepositStartDate > '01/01/1985'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

--12. * Rich Wizard, Poor Wizard
-- JOIN Solution
    SELECT wd1.FirstName
        AS [Host Wizard],
           wd1.DepositAmount
        AS [Host Wizard Deposit],
           wd2.FirstName
        AS [Guest Wizard],
            wd2.DepositAmount
        AS [Guest Wizard Deposit]
      FROM WizzardDeposits AS wd1
INNER JOIN WizzardDeposits AS wd2
        ON wd1.Id + 1 = wd2.Id

SELECT SUM([Host Wizard Deposit] - [Guest Wizard Deposit])
    AS [Difference]
    FROM(
         SELECT FirstName
             AS [Host Wizard],
                DepositAmount
             AS [Host Wizard Deposit],
            LEAD(FirstName) OVER(ORDER BY id)
             AS [Guest Wizard],
            LEAD(DepositAmount) OVER(ORDER BY id)
             AS [Guest Wizard Deposit] 
           FROM WizzardDeposits
        )    AS [HostGuestWizardQuery]
    WHERE [Guest Wizard] IS NOT NULL


GO

USE SoftUni

GO 

-- 18. *3rd Highest Salary

SELECT DISTINCT DepartmentID,
                Salary
            FROM (
                    SELECT DepartmentID,
                           Salary,
                           DENSE_RANK() OVER(PARTITION BY [DepartmentID] ORDER BY [Salary] DESC)
                        AS SalaryRank
                      FROM Employees
                ) AS SalaryRankingQuery
               WHERE SalaryRank = 3

--19. **Salary Challenge


SELECT TOP (10) FirstName,
                LastName,
                DepartmentID
           FROM Employees
             AS e
          WHERE e.Salary > (
                    SELECT AVG(Salary) AS AverageSalary
                      FROM Employees
                        AS esub
                     WHERE esub.DepartmentID = e.DepartmentID
                  GROUP BY DepartmentID
                            ) 
ORDER by e.DepartmentID