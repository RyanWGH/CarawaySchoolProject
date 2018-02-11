DROP DATABASE IF EXISTS facilitationsystem;

CREATE DATABASE facilitationsystem;

\c facilitationsystem

CREATE TABLE rooms (
  roomId serial PRIMARY KEY,

  colour text NOT NULL
);

CREATE TABLE users (
  userId serial PRIMARY KEY,

  firstName text NOT NULL,
  lastName text NOT NULL,
  phone text NOT NULL,
  email text NOT NULL
);

CREATE TABLE familyUnits (
  familyUnitId serial PRIMARY KEY,

  numberOfChildren integer NOT NULL,
  
  --Hours are gotten through facilitations can be null
  weeklyHours float,		--Hours gained through facilitation
  weeklyHoursDonated float,	--Hours given to another family
  weeklyDonation float,  	--Hours gained through donation
  monthlyHours float,		--Hours gained through facilitation
  monthlyHoursDonated float,	--Hours given to another family
  monthlyDonation float,  	--Hours gained through donation
  yearlyHours float,		--Hours gained through facilitation
  yearlyHoursDonated float,	--Hours given to another family
  yearlyDonation float,  	--Hours gained through donation
);

CREATE TABLE familyMembers (
  familyMemberId serial PRIMARY KEY,

  userId integer NOT NULL REFERENCES users(userId), 
  familyUnitId integer NOT NULL REFERENCES familyUnits(familyUnitId) 
);

CREATE TABLE admins (
  adminId serial PRIMARY KEY,

  userId integer NOT NULL REFERENCES users(userId), 
  adminLevel integer NOT NULL
);

CREATE TABLE boards (
  boardId serial PRIMARY KEY,

  userId integer NOT NULL REFERENCES users(userId), 
  boardLevel integer NOT NULL
);

CREATE TABLE teachers (
  teacherId serial PRIMARY KEY,

  userId integer NOT NULL REFERENCES users(userId) 
);

CREATE TABLE teacherRooms (
  teacherRoomId serial PRIMARY KEY,

  teacherId integer NOT NULL REFERENCES teachers(teacherId),
  roomId integer NOT NULL REFERENCES rooms(roomId) 
);

CREATE TABLE facilitations (
  facilitationId serial PRIMARY KEY,

  userId integer NOT NULL REFERENCES users(userId),
  roomId integer NOT NULL REFERENCES rooms(roomId),
  timeStart text NOT NULL,
  timeEnd text NOT NULL,
  day integer NOT NULL,
  month integer NOT NULL,
  year integer NOT NULL
);

--Create Rooms
--Room Id's Blue:1 Purple:2 Green:3 Red:4 Grey:5
INSERT INTO rooms (colour)
VALUES ('Blue');
INSERT INTO rooms (colour)
VALUES ('Purple');
INSERT INTO rooms (colour)
VALUES ('Green');
INSERT INTO rooms (colour)
VALUES ('Red');
INSERT INTO rooms (colour)
VALUES ('Grey');

--Create family units
INSERT INTO familyUnits (numberOfChildren) 
VALUES (1);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (1);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (1);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (1);
INSERT INTO familyUnits (numberOfChildren)
VALUES (1);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (2);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (2);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (2);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (3);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (3);
INSERT INTO familyUnits (numberOfChildren)
VALUES (4);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (4);
INSERT INTO familyUnits (numberOfChildren) 
VALUES (5);

--Create Users
--Names were created with a random name generator, any connection to a real person is accidental
--To ensure no real phone numbers are in the database the same fake 
--number is used to represent the numbers
--<lastName>@email.ca is used, any connection to a real email is accidental

--Family Members & Admin & Board 
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Arun', 'Roberson', '7805550110', 'Roberson@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (1,1);
INSERT INTO boards (userId, boardLevel)
VALUES (1,1);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Mehdi', 'Rubio', '7805550110', 'Rubio@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (2,2);
INSERT INTO boards (userId, boardLevel)
VALUES (2,2);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Bryony', 'Meza', '7805550110', 'Meza@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (3,3);
INSERT INTO boards (userId, boardLevel)
VALUES (3,3);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Hermione', 'Curran', '7805550110', 'Curran@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (4,1);
INSERT INTO boards (userId, boardLevel)
VALUES (4,1);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Mairead', 'Mack', '7805550110', 'Mack@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (5,2);
INSERT INTO boards (userId, boardLevel)
VALUES (5,2);

--Family Members & Admin
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Charlize', 'Sherman', '7805550110', 'Sherman@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (6,3);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Cydney', 'Sweet', '7805550110', 'Sweet@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (7,1);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Arjan', 'Quintana', '7805550110', 'Quintana@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (8,2);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Ayyan', 'Gillespie', '7805550110', 'Gillespie@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (9,3);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Asmaa', 'Livingston', '7805550110', 'Livingston@email.ca');
INSERT INTO admins (userId, adminLevel)
VALUES (10,1);

--Family Members & Board members
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Kris', 'Mcguire', '7805550110', 'Mcguire@email.ca');
INSERT INTO boards (userId, boardLevel)
VALUES (11,3);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Evan', 'Snyder', '7805550110', 'Snyder@email.ca');
INSERT INTO boards (userId, boardLevel)
VALUES (12,1);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Daisy-Mae', 'Nicholson', '7805550110', 'Nicholson@email.ca');
INSERT INTO boards (userId, boardLevel)
VALUES (13,2);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Iosif', 'Greenaway', '7805550110', 'Greenaway@email.ca');
INSERT INTO boards (userId, boardLevel)
VALUES (14,3);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Willow', 'Romero', '7805550110', 'Romero@email.ca');
INSERT INTO boards (userId, boardLevel)
VALUES (15,1);

--Family Members & Teachers
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Lillie-Mai', 'Matthams', '7805550110', 'Matthams@email.ca');
INSERT INTO teachers (userId)
VALUES (16);
INSERT INTO teacherRooms (teacherId, roomId)
VALUES (1,1);

--Family Members
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Kareena', 'Horton', '7805550110', 'Horton@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Cadence', 'Lane', '7805550110', 'Lane@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Mika', 'Mercer', '7805550110', 'Mercer@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Iwan', 'Graves', '7805550110', 'Graves@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Bernice', 'Castaneda', '7805550110', 'Castaneda@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Kezia', 'Scott', '7805550110', 'Scott@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Samson', 'Saunders', '7805550110', 'Saunders@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Yasser', 'Valentine', '7805550110', 'Valentine@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Macaulay', 'Lamb', '7805550110', 'Lamb@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Carlo', 'Valdez', '7805550110', 'Valdez@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Chase', 'Davison', '7805550110', 'Davison@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Felix', 'Malone', '7805550110', 'Malone@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Stevie', 'Milner', '7805550110', 'Milner@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Sharna', 'Snyder', '7805550110', 'Snyder@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Alexis', 'Sparrow', '7805550110', 'Sparrow@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Kylie', 'Gilmore', '7805550110', 'Gilmore@email.ca');
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Keagan', 'Gregory', '7805550110', 'Gregory@email.ca');

--Teachers 
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Hywel', 'Molloy', '7805550110', 'Molloy@email.ca');
INSERT INTO teachers (userId)
VALUES (34);
INSERT INTO teacherRooms (teacherId, roomId)
VALUES (2,2);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Justin', 'Easton', '7805550110', 'Easton@email.ca');
INSERT INTO teachers (userId)
VALUES (35);
INSERT INTO teacherRooms (teacherId, roomId)
VALUES (3,3);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Zainab', 'Mckinney', '7805550110', 'Mckinney@email.ca');
INSERT INTO teachers (userId)
VALUES (36);
INSERT INTO teacherRooms (teacherId, roomId)
VALUES (4,4);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Leoni', 'Kirkpatrick', '7805550110', 'Kirkpatrick@email.ca');
INSERT INTO teachers (userId)
VALUES (37);
INSERT INTO teacherRooms (teacherId, roomId)
VALUES (5,5);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Aneesah', 'Bird', '7805550110', 'Bird@email.ca');
INSERT INTO teachers (userId)
VALUES (38);
INSERT INTO teacherRooms (teacherId, roomId)
VALUES (6,1);
INSERT INTO users (firstName, lastName, phone, email)
VALUES ('Darrell', 'Velasquez', '7805550110', 'Velasquez@email.ca');
INSERT INTO teachers (userId)
VALUES (39);
INSERT INTO teacherRooms (teacherId, roomId)
VALUES (7,2);

--Create the family members
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (1, 1);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (14, 1);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (25, 1);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (32, 1);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (2, 2);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (15, 2);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (26, 2);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (3, 3);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (16, 3);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (4, 4);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (5, 5);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (17, 5);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (27, 5);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (33, 5);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (6, 6);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (18, 6);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (28, 6);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (7, 7);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (19, 7);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (8, 8);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (9, 9);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (20, 9);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (29, 9);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (10, 10);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (21, 10);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (11, 11);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (22, 11);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (30, 11);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (12, 12);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (23, 12);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (13, 13);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (24, 13);
INSERT INTO familyMembers (userId, familyUnitId)
VALUES (31, 13);

--Create example facilitations (for the most predictable people in the world)
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 1, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 1, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 2, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 2, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 3, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 3, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 4, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 4, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '3:45', 5, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 2, '8:45', '3:45', 5, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 3, '8:45', '3:45', 5, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 4, '8:45', '3:45', 5, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 5, '8:45', '3:45', 5, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 8, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 8, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 9, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 9, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 10, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 10, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 11, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 11, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 15, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 15, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 16, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 16, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 17, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 17, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 18, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 18, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '3:45', 19, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 2, '8:45', '3:45', 19, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '3:45', 19, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 4, '8:45', '3:45', 19, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 5, '8:45', '3:45', 19, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 22, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 22, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 23, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 23, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 24, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 24, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 25, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 25, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 29, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 29, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 30, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 30, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 31, 1, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 31, 1, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (2, 1, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (4, 2, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 2, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (6, 2, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (10, 4, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (18, 3, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (25, 1, '1:00', '3:45', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (28, 2, '1:00', '3:45', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (29, 2, '1:00', '3:45', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (30, 3, '1:00', '3:45', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 1, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 1, 2, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (3, 1, '8:45', '3:45', 2, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 2, '8:45', '3:45', 2, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (9, 3, '8:45', '3:45', 2, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 4, '8:45', '3:45', 2, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (5, 5, '8:45', '3:45', 2, 2, 2018);

------------------------------------------------------------------------------------
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (1, 1, '8:45', '12:00', 5, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (7, 2, '8:45', '12:00', 5, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (8, 3, '8:45', '12:00', 5, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 5, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 5, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (26, 1, '1:00', '3:45', 5, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (27, 1, '1:00', '3:45', 5, 2, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 6, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (13, 1, '12:00', '1:00', 6, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (14, 1, '12:00', '1:00', 6, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (15, 2, '12:00', '1:00', 6, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (16, 2, '12:00', '1:00', 6, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (17, 2, '12:00', '1:00', 6, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 6, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (31, 4, '1:00', '3:45', 6, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (32, 5, '1:00', '3:45', 6, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 6, 2, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 7, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (20, 3, '12:00', '1:00', 7, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (21, 3, '12:00', '1:00', 7, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (22, 4, '12:00', '1:00', 7, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (23, 5, '12:00', '1:00', 7, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (24, 5, '12:00', '1:00', 7, 2, 2018);

INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 8, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (11, 5, '8:45', '12:00', 8, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (12, 5, '8:45', '12:00', 8, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (19, 3, '12:00', '1:00', 8, 2, 2018);
INSERT INTO facilitations (userId, roomId, timeStart, timeEnd, day, month, year)
VALUES (33, 5, '1:00', '3:45', 8, 2, 2018);
