create database CA29707406;
use CA29707406;

create table Department(
DepartmentID VARCHAR(10) PRIMARY KEY,
DepartmentName VARCHAR(50) NOT NULL
);

Create table Room(
RoomID VARCHAR(10) PRIMARY KEY,
Purpose VARCHAR(50) NOT NULL
);

create table Doctor(
DoctorID VARCHAR(10) PRIMARY KEY,
DoctorName VARCHAR(50) NOT NULL,
Contact VARCHAR(10) NOT NULL,
Email VARCHAR(50) NOT NULL,
DepartmentID VARCHAR(10) NOT NULL,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

create table Patient(
PatientID VARCHAR(10) PRIMARY KEY,
PatientName VARCHAR(50) NOT NULL,
Contact VARCHAR(10) NOT NULL,
DOB DATE NOT NULL,
Sex CHAR(1) NOT NULL,
Address VARCHAR(100) NOT NULL,
Email VARCHAR(50) NOT NULL
);

create table Appointment(
PatientID VARCHAR(10),
DoctorID VARCHAR(10),
RoomID VARCHAR(10),
ScheduledStart DATETIME NOT NULL,
PRIMARY KEY(PatientID, DoctorID, RoomID, ScheduledStart),
ScheduledEND DATETIME NOT NULL,
ArrivalTime DATETIME NULL,
StartTime DATETIME NULL,
FinishTime DATETIME NULL,
Weight FLOAT NULL,
Temperature FLOAT NULL,
DoctorComment VARCHAR(200) NULL,
FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
);


