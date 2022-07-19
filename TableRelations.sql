use Geography

-- Lab

SELECT 
	m.MountainRange
	, p.PeakName
	, p.Elevation
	FROM Mountains AS m
JOIN Peaks AS p ON 
	m.Id = p.MountainId
	AND m.MountainRange = 'Rila'
ORDER By p.Elevation DESC

-- EX
GO

CREATE DATABASE [EntityRelationsDemo22]

GO 

USE [EntityRelationsDemo22]

GO

--Problem 1.	One-To-One Relationship

CREATE TABLE [Passports](
	[PassportID] INT PRIMARY KEY IDENTITY(101,1)
	,[PassportNumber] VARCHAR(10) NOT NULL
)
	 -- One to One Relation
CREATE TABLE [Persons](
	[PersonID] INT PRIMARY KEY IDENTITY
	,[FirstName] NVARCHAR(30) NOT NULL
	,[Salary] DECIMAL(8,2) NOT NULL
	,[PassportID] INT FOREIGN KEY REFERENCES [Passports]([PassportID]) UNIQUE NOT NULL
)

INSERT INTO [Passports]([PassportNumber])
	VALUES
	('N34FG21B')
	,('K65LO4R7')
	,('ZE657QP2')

INSERT INTO [Persons]([FirstName], [Salary],[PassportID]) 
	VALUES
	('Roberto', 43300.00, 102)
	,('Tom', 56100.00, 103)
	,('Yana', 60200.00, 101)

--Problem 2.	One-To-Many Relationship

CREATE TABLE [Manufacturers](
	[ManufacturerID] INT PRIMARY KEY IDENTITY 
	,[Name] VARCHAR(30) NOT NULL
	,[EstablishedOn] DATE NOT NULL
)

CREATE TABLE [Models](
	[ModelID] INT PRIMARY KEY IDENTITY (101, 1)
	,[Name] VARCHAR(35) NOT NULL
	,[ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers]([ManufacturerID]) NOT NULL
)

INSERT INTO [Manufacturers]([Name], [EstablishedOn]) 
	VALUES
	('BMW',	'07/03/1916')
	,('Tesla','01/01/2003')
	,('Lada','01/05/1966')

INSERT INTO [Models]([Name], [ManufacturerID]) 
	VALUES
	('X1',	1)
	,('i6',	1)
	,('Model S', 2)
	,('Model X', 2)
	,('Model 3', 2)
	,('Nova', 3)
	------
select * from Manufacturers
select * from Models as mo
left join Manufacturers as [ma]
on [mo].ManufacturerID = [ma].ManufacturerID

--Problem 3.	Many-To-Many Relationship

use EntityRelationsDemo22

CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(40) NOT NULL
)
	-- the following column is no longer IDENTITY
	-- SET IDENTITY_INSERT [StudentsID] OFF

CREATE TABLE [Exams](
	[ExamID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(70) NOT NULL
)

		-- Mapping Table with composite keys
CREATE TABLE [StudentsExams](
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]),
	[ExamID] INT FOREIGN KEY REFERENCES [Exams]([ExamID]),
	PRIMARY KEY([StudentID], [ExamID])
)

INSERT INTO [Students]([Name]) 
	VALUES
	('Mila')
	,('Toni')
	,('Ron')

INSERT INTO [Exams]([Name]) 
	VALUES
	('SpringMVC')
	,('Neo4j')
	,('Oracle 11g')

INSERT INTO [StudentsExams]([StudentID], [ExamID]) 
	VALUES
	(1, 101),
	(1, 102),
	(2, 101),
	(3, 103),
	(2, 102),
	(2, 103)

--Problem 4.	Self-Referencing 
CREATE TABLE Teachers(
	[TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(50) NOT NULL,
	[ManagerID] INT FOREIGN KEY REFERENCES [Teachers]([TeacherID])
)

INSERT INTO [Teachers]([Name], [ManagerID]) 
	VALUES
	('John', NULL),
	('Maya', 106),
	('Silvia', 106),
	('Ted', 105),
	('Mark', 101),
	('Greta', 101)

--select * from Teachers

--Problem 6.	University Database

GO

CREATE DATABASE [UniversityDatabase]

GO

CREATE TABLE [Majors](
	[MajorID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(70) NOT NULL
)

CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY,
	[StudentNumber] VARCHAR(15) NOT NULL,
	[StudentName] NVARCHAR(70) NOT NULL,
	[MajorID] INT FOREIGN KEY REFERENCES [Majors]([MajorID]) NOT NULL
)

CREATE TABLE [Payments](
	[PaymentID] INT PRIMARY KEY IDENTITY,
	[PaymentDate] DATETIME2 NOT NULL,
	[PaymentAmount] DECIMAL(8, 2) NOT NULL,
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]) NOT NULL
)

CREATE TABLE [Subjects](
	[SubjectID] INT PRIMARY KEY IDENTITY,
	[SubjectName] NVARCHAR(70) NOT NULL
)

CREATE TABLE [Agenda](
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]),
	[SubjectID] INT FOREIGN KEY REFERENCES [Subjects]([SubjectID]),
	PRIMARY KEY ([StudentID], [SubjectID])
)

--Problem 9.	*Peaks in Rila
go

use [Geography]

go

select [m].MountainRange, [p].PeakName, [p].Elevation
	from Mountains as [m]
	left join Peaks as [p]
	on [p].MountainId = [m].Id
	where MountainRange = 'Rila'
order by [p].Elevation desc
