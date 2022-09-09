create database CountriesInfo
use CountriesInfo

CREATE TABLE  Country
(
	Id int  Primary key not null Identity(1,1),
	CountryName nvarchar(50) not null,
	Code nvarchar(50) 
)
CREATE TABLE  City
(
	Id int  Primary key not null Identity(1,1),
	CityName nvarchar(50) not null,
	Code nvarchar(50) ,
	CountryId int foreign key  (Id) references Country(Id) not null
)
CREATE TABLE  District
(
	Id int  Primary key not null Identity(1,1),
	DistrictName nvarchar(50) not null,
	Code nvarchar(50) ,
	CountryId int foreign key  (Id) references Country(Id) not null,
	CityId int foreign key  (Id) references City(Id) not null
)
CREATE TABLE Town
(
	Id int  Primary key not null Identity(1,1),
	TownName nvarchar(50) not null,
	Code nvarchar(50) ,
	CountryId int foreign key  (Id) references Country(Id) not null,
	CityId int foreign key  (Id) references City(Id) not null,
	DistrictId int foreign key  (Id) references District(Id) not null
)

CREATE PROCEDURE CountryCheck
@CountryName VARCHAR(50),
@CityName VARCHAR(50),
@DistrictName VARCHAR(50),
@TownName VARCHAR(50)
AS
BEGIN
DECLARE @CountryId INT
DECLARE @CityId INT
DECLARE @DistrictId INT
DECLARE @TownId INT

SELECT @CountryId = Id FROM Country WHERE CountryName = @CountryName
SELECT @CityId = Id FROM City WHERE CityName = @CityName
SELECT @DistrictId = Id FROM District WHERE DistrictName = @DistrictName
SELECT @TownId = Id FROM Town WHERE TownName = @TownName

IF @CountryId IS NULL
BEGIN
INSERT INTO Country(CountryName,Code) VALUES(@CountryName,NEWID())
SELECT @CountryId = Id FROM Country WHERE CountryName = @CountryName
END
ELSE
BEGIN
PRINT 'Country Already Exists'
END

IF @CityId IS NULL
BEGIN
INSERT INTO City(CityName,CountryId,Code) VALUES(@CityName,@CountryId,NEWID())
SELECT @CityId = Id FROM City WHERE CityName = @CityName
END
ELSE
BEGIN
PRINT 'City Already Exists'
END

IF @DistrictId IS NULL
BEGIN


INSERT INTO District(DistrictName,CountryId,CityId,Code
) VALUES(@DistrictName,@CountryId,@CityId,NEWID())
SELECT @DistrictId = Id FROM District WHERE DistrictName = @DistrictName
END
ELSE
BEGIN
PRINT 'District Already Exists'
END

IF @TownId IS NULL
BEGIN
INSERT INTO Town(TownName,CountryId,CityId,DistrictId,Code) VALUES(@TownName,@CountryId,@CityId,@DistrictId,NEWID())
SELECT @TownId = Id FROM Town WHERE TownName = @TownName
END
ELSE
BEGIN
PRINT 'Town Already Exists'
END

END

GO
