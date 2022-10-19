------------------------------------------------------------------------------------------------------
-- PostgreSQL create, load, and query script for Cain's Jawbone Project.
--
-- SQL statements for the Cain's Jawbone database
--
--
-- Daisy Kopycienski
--
-- Tested on Postgres 14 (For versions < 10 you may need
-- to remove the "if exists" clause from the DROP TABLE commands.)
------------------------------------------------------------------------------------------------------


DROP VIEW IF EXISTS MurderDetails;
DROP VIEW IF EXISTS PageDetails;


DROP TABLE IF EXISTS Solvers;
DROP TABLE IF EXISTS PagesPeople;
DROP TABLE IF EXISTS PagesMurders;
DROP TABLE IF EXISTS PagesPoems;
DROP TABLE IF EXISTS PagesPuzzles;
DROP TABLE IF EXISTS PoemPairs;
DROP TABLE IF EXISTS Puzzles;
DROP TABLE IF EXISTS Competitions;
DROP TABLE IF EXISTS Murders;
DROP TABLE IF EXISTS Murderers;
DROP TABLE IF EXISTS Victims;
DROP TABLE IF EXISTS Pages;
DROP TABLE IF EXISTS Poems;
DROP TABLE IF EXISTS Zipcodes;
DROP TABLE IF EXISTS Characters;
DROP TABLE IF EXISTS People;


--People--
CREATE TABLE People (
    PID int NOT NULL,
    FirstName text,
    LastName text,
PRIMARY KEY(PID)
);

--Characters--
CREATE TABLE Characters (
    PID int NOT NULL references People(PID),
    Gender char(1) CHECK (Gender in ('M', 'F')), 
    Nickname text, 
    Profession text,
PRIMARY KEY(PID)
);


--Competitions--
CREATE TABLE Competitions (
    CompID int NOT NULL,
    YearStart numeric(4) CHECK (YearStart <= YearEnd),
    YearEnd numeric(4) CHECK (YearEnd >= YearStart),
    PrizeAmountEuros numeric(6,2),
PRIMARY KEY(CompID)
);

--Zipcodes--
CREATE TABLE Zipcodes (
    Zipcode numeric(5) NOT NULL,
    City text,
    State text,
PRIMARY KEY(Zipcode)
);

--Solvers--
CREATE TABLE Solvers (
    PID int NOT NULL references People(PID),
    CompID int NOT NULL references Competitions(CompID),
    Address text,
    Zipcode numeric(5) references Zipcodes(Zipcode),
PRIMARY KEY(PID)
);




--Murderers--
CREATE TABLE Murderers (
    PID int NOT NULL references People(PID),
PRIMARY KEY(PID)
);


--Victims--
CREATE TABLE Victims (
    PID int NOT NULL references People(PID),
    CauseOfDeath text,
PRIMARY KEY(PID)
);


--Murders--
CREATE TABLE Murders (
    MurderID int NOT NULL references Murders(MurderID),
    VictimPID int NOT NULL references Victims(PID) UNIQUE,
    MurdererPID int NOT NULL references Murderers(PID),
PRIMARY KEY(MurderID)
);


--Pages--
CREATE TABLE Pages (
    PageNum int NOT NULL CHECK (PageNum <= 100),
    SequenceNum int CHECK (SequenceNum <= 100) UNIQUE,
    Location text,
    Genre text,
PRIMARY KEY(PageNum)
);


--PagesMurders--
CREATE TABLE PagesMurders (
    PageNum int NOT NULL references Pages(PageNum),
    MurderID int NOT NULL references Murders(MurderID),
PRIMARY KEY(PageNum, MurderID)
);




--PagesPeople--
CREATE TABLE PagesPeople (
    PageNum int NOT NULL references Pages(PageNum),
    PID int NOT NULL references People(PID),
PRIMARY KEY(PageNum, PID)
);


--Poems--
CREATE TABLE Poems (
    PoemID int NOT NULL,
    PoemDesc text,
PRIMARY KEY(PoemID)
);


--PagesPoems--
CREATE TABLE PagesPoems (
    PageNum int NOT NULL references Pages(PageNum),
    PoemID int NOT NULL references Poems(PoemID),
PRIMARY KEY(PageNum, PoemID)
);


--PoemPairs--
CREATE TABLE PoemPairs (
    BeginningPoemID int NOT NULL references Poems(PoemID),
    EndPoemID int NOT NULL references Poems(PoemID),
PRIMARY KEY(BeginningPoemID, EndPoemID)
);


--Puzzles--
CREATE TABLE Puzzles (
    PuzzleID int NOT NULL,
    PuzzleType text NOT NULL,
    PuzzleText text NOT NULL ,
    Solution text DEFAULT '?',
PRIMARY KEY(PuzzleID)
);


--PagesPuzzles--
CREATE TABLE PagesPuzzles (
    PageNum int NOT NULL references Pages(PageNum),
    PuzzleID int NOT NULL references Puzzles(PuzzleID),
PRIMARY KEY(PageNum, PuzzleID)
);


-- SQL statements for loading example data


-- People --
INSERT INTO People (pid, firstName, lastName)
VALUES
 (001, 'Samantha', 'Turner'),
 (002, 'William', 'Kennedy'),
 (003, 'Charles', 'Day'),
 (004, 'Francis', 'Ferdinand'),
 (005, 'John', 'Finnemore'),
 (006, 'Henry', 'Peterson'),
 (007, 'Alan', 'Labouseur'),
 (008, 'William', 'Smith'),
 (009, 'Katherine', 'Snyder'),
 (010, 'Trinder', 'Adams'),
 (011, 'Olivia', 'Adams')
;

-- Characters --
INSERT INTO Characters (PID, Nickname, Gender, Profession)
VALUES
 (003, 'Charlie', 'M', 'Professor’s Assistant' ),
 (004, NULL    ,  'F', 'Doctor'),
 (005, NULL, 'M',  'Poet'),
 (008, 'Bills', 'M',  'Race Car Driver'),
 (009, 'Kate', 'F',  'Jockey'),
 (010, NULL, 'F',  'Elementary School Teacher'),
 (011, 'Olive', 'F'    , 'Scientist')
;

-- Competitions --
INSERT INTO Competitions(CompID, YearStart, YearEnd, PrizeAmountEuros)
VALUES
(001, 1934, 1935, 15.00),
(002, 2019, 2020, 1000.00),
(003, 2021, 2023, 250.00)
;

-- Zipcodes --
INSERT INTO Zipcodes( Zipcode, City, State)
VALUES
(90706, 'Santa Fe Springs', 'California'),
(90077, 'Los Angeles',   'California'),
(12602, 'Poughkeepsie',    'New York'),
(12601, 'Poughkeepsie',   'New York')
;

--Solvers--
INSERT INTO Solvers (pid, CompID, Address, Zipcode)
VALUES
 (001, 001, '3731 Saratoga Place',  90706),
 (002, 001, '1200 Bel Air Road',  90077),
 (005, 002, '45 Reade Place',    12602),
 (007, 003, '3399 North Road',     12601)
;



-- Murderers --
INSERT INTO Murderers(PID)
VALUES
(003),
(004),
(009),
(011)
;

-- Victims --
INSERT INTO Victims(PID, CauseOfDeath)
VALUES
(004, 'Poison'),
(008, 'Firearm Homicide'),
(010, 'Poison')
;

-- Murders --
INSERT INTO Murders(MurderID, VictimPID, MurdererPID)
VALUES
(001, 010, 011),
(002, 008, 004),
(003, 004, 009)
;

-- Pages --
INSERT INTO Pages(PageNum, SequenceNum, Location, Genre)
VALUES
(023, 004, 'Peebles University', 'Murder'),
(034, 005, 'Peebles University', 'Murder'),
(074, 099, 'Staircase', 'Murder'),
(001, 088, 'Bedroom', 'Romance'),
(099, 051, NULL, 'Narration'),
(098, 089, 'Hallway', 'Romance')
;

-- PagesMurders --
INSERT INTO PagesMurders(MurderID, PageNum)
VALUES
(001, 023),
(001, 034),
(002, 074),
(003, 023)
;


-- PagesPeople --
INSERT INTO PagesPeople(PageNum, PID)
VALUES
(023, 010),
(023, 011),
(034, 010),
(034, 011),
(074, 008),
(074, 004),
(023, 004),
(023, 009),
(074, 003),
(001, 003)
;

-- Poems --
INSERT INTO Poems(PoemID, PoemDesc)
VALUES
(001, 'Rose'),
(002, 'Viking ship'),
(003, 'Flower garden'),
(004, 'Ocean')
;

-- PagesPoems --
INSERT INTO PagesPoems(PageNum, PoemID)
VALUES
(001, 001),
(098, 003),
(023, 002),
(034, 004)
;

-- PoemPairs --
INSERT INTO PoemPairs(BeginningPoemID, EndPoemID)
VALUES
(003, 001),
(002, 004)
;

-- Puzzles --
INSERT INTO Puzzles(PuzzleID, PuzzleType, PuzzleText, Solution)
VALUES
(001, 'Spoonerism', 'The Lord is a shoving leopard', 'The Lord is a loving shepherd'),
(002, 'Riddle', 'What has many words but never speaks?', 'a book')
;

insert into Puzzles(puzzleID, puzzleType, puzzleText)
values
(003, 'Riddle', 'What question can you never answer yes to?')
;

-- PagesPuzzles --
INSERT INTO PagesPuzzles(PageNum, PuzzleID)
VALUES
(074, 001),
(099, 002),
(001,003),
(023, 002)
;


-- SQL statements for displaying this example data:
select *
from People;

select *
from Characters;

select *
from Solvers;

select *
from Zipcodes;

select *
from Murderers;

select *
from Victims;

select *
from Murders;

select *
from PagesMurders;

select *
from Competitions;

select *
from Pages;

select *
from PagesPeople;

select *
from Poems;

select *
from PagesPoems;

select *
from PoemPairs;

select *
from Puzzles;

select *
from PagesPuzzles;


--VIEWS--

--VIEW 1-- 
CREATE VIEW MurderDetails
AS
Select ms.MurderID, ms.victimPID as VPID, p1.firstname as VFirstName, p1.lastname as VLastName, c1.nickname as VNickname, c1.gender as VGender, c1.profession as VProfession, v.causeofdeath, ms.murdererpid as MPID, p2.firstname as MFirstName, p2.lastname as MLastName, c2.nickname as MNickName, c2.gender as MGender, c2.profession as MProfession
FROM 
Murders ms inner join victims v on ms.victimpid = v.pid
		   inner join murderers m on ms.murdererpid = m.pid
		   inner join characters c1 on ms.victimpid = c1.pid
		   inner join characters c2 on ms.murdererpid = c2.pid
		   inner join people p1 on ms.victimpid = p1.pid
		   inner join people p2 on ms.murdererpid = p2.pid
ORDER BY ms.murderid ASC;

--query 1--
select *
from murderDetails;

--query 2--
select murderID, vfirstName, vlastname, mfirstname, mlastname
from murderDetails
where vgender = 'F'and mgender = 'F';

--query 3--
select murderID, vfirstName, vlastname, Mfirstname, Mlastname
from murderDetails;


--View 2--
Create view PageDetails
AS
select p.pageNum as PageNum, p.sequenceNum, p.location, p.genre, ppl.PID, ppl.firstName, ppl.lastName
from PagesPeople pppl right outer join Pages p on pppl.pageNum = p.pagenum
					  left outer join People ppl on pppl.pid = ppl.pid;

--query 1--
select *
from pageDetails;

--query 2--
select distinct sequencenum, pagenum
from pageDetails
order by sequenceNum ASC;

--query 3--
select Distinct pd.pid, pd.firstName, pd.lastname
from pageDetails pd
where pid in (select pd.pid
				from pageDetails  pd
				group by pd.pid
				order by count(pd.pid) DESC
				limit 1)
;

--query 4--
select pd.pageNum, pd.location
from pageDetails pd
where pd.PID is NULL
;

--Report 1--
select distinct pageNum, location
from pageDetails pd left outer join murderDetails md1 on pd.pid = md1.Vpid
					left outer join murderDetails md2 on pd.pid = md2.Mpid
where genre = 'Murder';

--report 2--
select puzzleID, solution
from Puzzles 
where Solution != '?' and 
	  puzzleID in (select puzzleID
				   from PagesPuzzles
				   where pageNum in (select pageNum
									 from pageDetails
									  where location like '%University'));
									  
--report 3--
select location, count(pid)
from pageDetails
where pagenum in (select pageNum
				from pagespoems
				where poemID in (select poemID
								from poems
								where poemID in (select beginningPoemID
												 from poemPairs)
								)

				)
Group by location
having count(distinct pid) >= 2;



create role admin;
grant all 
on all tables in schema public 
to admin;

create role client;
grant select, insert, update 
on all tables in schema public 
to client;

create role assistant;
grant insert, update
on all tables in schema public 
to assistant;

--Stored Procedures--

--1--
create or replace function PagesFor(int, REFCURSOR) returns refcursor as 
$$
declare
   personID int       := $1;
   resultset   REFCURSOR := $2;
begin	
   open resultset for 
      select pageNum
      from   PagesPeople
       where  personID = PID;
   return resultset;
end;
$$ 
language plpgsql;

-- Example for person 11 
select PagesFor(011, 'results');
Fetch all from results;


--Trigger 1--
CREATE OR REPLACE FUNCTION PersonOnPageIsCharacter() 
RETURNS TRIGGER AS $$ 
BEGIN 
		IF new.pid not in(select ch.pid
						  from Characters ch
						  where (new.pid = ch.pid)
		)THEN RAISE EXCEPTION 'Person needs to be a character';
		END IF; 
RETURN NULL;
END; 
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER PersonOnPageIsCharacter
BEFORE INSERT ON PagesPeople
FOR EACH ROW
EXECUTE PROCEDURE PersonOnPageIsCharacter();

--Example for trigger 1
insert into PagesPeople(pageNum, PID)
values
(23, 007);


--Trigger 2--

CREATE OR REPLACE FUNCTION OnlySixMurders() 
RETURNS TRIGGER AS $$ 
BEGIN 
		IF (select count(MurderID)
		   	from Murders
		   	) > 6
		THEN RAISE EXCEPTION 'There are already 6 murders, can not add another.';
		END IF; 
RETURN NULL;
END; 
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER OnlySixMurders
AFTER INSERT ON Murders
FOR EACH ROW
EXECUTE PROCEDURE OnlySixMurders();


--Example for trigger 2

--Additional victim PIDs necessary to add more entries to Murder table
insert into Victims(PID)
values
(005),
(003),
(009),
(011);

--These will be entered with no error--
INSERT INTO Murders(MurderID, VictimPID, MurdererPID)
VALUES
(004, 005, 003),
(005, 009, 003),
(006, 011, 003)
;

--This insert returns the error, as there are not allowed to be more that 6--
insert into Murders(MurderID, VictimPID, MurdererPID)
values
(007, 003, 011);









