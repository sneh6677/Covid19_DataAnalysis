SELECT Gender, COUNT(Gender) As count
FROM EmployeeDemographics
Group by Gender
Order by count;

/* Joins */
SELECT JobTitle, AVG(s.Salary)
FROM EmployeeDemographics e
INNER JOIN EmployeeSalary s 
ON e.EmployeeID = s.EmployeeID
Where JobTitle = 'Salesman'
GROUP by JobTitle;

SELECT *
FROM EmployeeDemographics e
Full OUTER JOIN EmployeeSalary s
ON e.EmployeeID = s.EmployeeID;

SELECT * FROM EmployeeDemographics;
SELECT * FROM EmployeeSalary;

/* Unions, Union All inlcudes even the duplicates */
SELECT *
FROM EmployeeDemographics e
Full OUTER JOIN WareHouseEmployeeDemographics s
ON e.EmployeeID = s.EmployeeID;

SELECT * FROM EmployeeDemographics
UNION SELECT * FROM WareHouseEmployeeDemographics;

/* case Statements */
SELECT FirstName, LastName, Age,
Case 
    When Age > 45 Then 'Old'
    Else 'Young' 
END as Category
FROM EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age;

SELECT e.FirstName, e.LastName, s.JobTitle, s.Salary,
Case 
    When JobTitle = 'Salesman' Then Salary + (Salary * 0.10)
    When JobTitle = 'Accountant' Then Salary + (Salary * 0.05)
    When JobTitle = 'HR' Then Salary + (Salary * 0.00001)
Else 
    Salary + (Salary * 0.3)
END As Hike_Salary
From EmployeeDemographics e
JOIN EmployeeSalary s 
ON e.EmployeeID = s.EmployeeID;

/* Having: used when an aggregate function is used in the select statement and I want to add a condition w.r.t Group by clause */
SELECT JobTitle, COUNT(JobTitle) As Jcount, Avg(Salary) As A_Salary
From EmployeeSalary
GROUP by JobTitle
HAVING COUNT(JobTitle) > 1
ORDER By Avg(Salary);

/* Aliasing */
SELECT FirstName + ' ' +LastName As FullName
From EmployeeDemographics;

/* Partition By */
SELECT FirstName, LastName, Age, Gender, Salary,
COUNT(Gender) OVER (Partition by Gender) As Total_Gender
From EmployeeDemographics e 
JOIN EmployeeSalary s 
on e.EmployeeID = s.EmployeeID;

/* CTEs, Common Table Expression: used to manipulate the compplex sub queries data, Similar to temp table but not stored in any memory.*/
WITH CTE_EMP AS
(SELECT FirstName, LastName, Age, Gender, Salary,
COUNT(Gender) OVER (Partition by Gender) As Total_Gender
From EmployeeDemographics e 
JOIN EmployeeSalary s 
on e.EmployeeID = s.EmployeeID)
SELECT FirstName, Age, Total_Gender
From CTE_EMP;

/* Temp Tables */
--Drop TABLE #temp_Employee;
CREATE TABLE #temp_Employee(EmployeeID int, JobTitle varchar(50), Salary int)

INSERT Into #temp_Employee Select * FROM EmployeeSalary

SELECT * from #temp_Employee
--------------------------------------
CREATE TABLE #temp_EMP (JobTitle varchar(50), EmplueesPerJOb int, AbgAge int, AvgSalary int)

INSERT into #temp_EMP 
Select JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics e 
JOIN EmployeeSalary s 
ON e.EmployeeID = s.EmployeeID
GROUP BY JobTitle

Select * FROM #temp_EMP

/* String Functions Trim: gets rid of blank spaces, Ltrim, Rtrim*/

SELECT EmployeeID, TRIM(EmployeeID) As ID
From EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) As ID
From EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) As ID
From EmployeeErrors

/* Replace */
SELECT LastName, REPLACE(LastName, '- Fired', '') As LastNameFixed
From EmployeeErrors

/* Substring */
SELECT SUBSTRING(FirstName, 1,3)
From EmployeeErrors

/* Stored Procedure: group of sql statements created and stored in the database: a single stored procedure can be used by several individuals over th
network: reduces n/w traffic */

CREATE PROCEDURE Test 
As 
SELECT *
FROM EmployeeDemographics;


EXEC Test

create PROCEDURE Temp_Employee2
AS
CREATE TABLE #temp_EMP (JobTitle varchar(50), EmplueesPerJOb int, AbgAge int, AvgSalary int)
INSERT into #temp_EMP 
Select JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics e 
JOIN EmployeeSalary s 
ON e.EmployeeID = s.EmployeeID
GROUP BY JobTitle

Select * from #temp_EMP

EXEC Temp_Employee2

/* Subqueries, solve questions */

SELECT *,
 (Select AVG(Salary) from EmployeeSalary) as Avg_salary FROM EmployeeSalary

SELECT EmployeeId, JobTitle, Salary 
From EmployeeSalary
WHERE EmployeeID in (Select EmployeeID from EmployeeDemographics where age >35)
