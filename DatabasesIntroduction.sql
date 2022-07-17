-- Exercise 01 
CREATE DATABASE [Minions]

USE [Minions]

GO -- разделя изпълнението на командите

GO

CREATE TABLE [Minions] (
	[Id] INT PRIMARY KEY, 
	[Name] NVARCHAR(50) NOT NULL,
	[Age] INT NOT NULL,
)

CREATE TABLE [Towns] (
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(70) NOT NULL 
)

ALTER TABLE [Minions]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL -- Създаване на рефенция към друга таблица


ALTER TABLE [Minions] 
ALTER COLUMN [Age] INT

GO -- EX 04

INSERT INTO [Towns]([Id], [Name])
	VALUES
(1,'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')


INSERT INTO [Minions]([Id], [Name], [Age], [TownId])
	VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)

GO

SELECT * FROM [Towns]
SELECT * FROM [Minions]

SELECT [Name], [Age] FROM [Minions]


GO -- EX 11

ALTER TABLE Users ADD CONSTRAINT DV_DateTime
DEFAULT GETDATE() FOR LastLoginTime

GO

TRUNCATE TABLE [Minions]		-- EX 6

GO -- EX 7

CREATE TABLE [People](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL, 
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3,2),
	[Weight] DECIMAL(3,2),
	[Gender] CHAR(1) NOT NULL,
	CHECK ([Gender] = 'm' OR [Gender] = 'f'),
	[Birthdate] DATETIME2 NOT NULL,
	[Biography] NVARCHAR(MAX)
)


INSERT INTO [People]([Name], [Height], [Weight], [Gender], [Birthdate])
	VALUES
	('Tosho', NULL, NULL, 'm', '1980-12-19'),
	('Heni', NULL, NULL, 'f', '1980-03-08'),
	('Eli', NULL, NULL, 'f', '2012-08-02'),
	('Adi', NULL, NULL, 'f', '2019-06-04'),
	('Bobi', NULL, NULL, 'm', '1956-09-26')

SELECT * FROM [People]

ALTER TABLE [People]
ADD CONSTRAINT DF_DefaultBiography DEFAULT ('No biography..') FOR [Biography]