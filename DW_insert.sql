-- IT8704 Data Management Systems CA2
-- JAYE LIN JIAQI (9707406Q)
-- SQL INSERT INTO statements to populate DW (CA2DW9707406) tables from OLTP (CA29707406)

USE CA2DW9707406;

INSERT INTO DimDepartment (DepartmentID, DepartmentName)
SELECT 
    d.DepartmentID,
    d.DepartmentName
FROM CA29707406.department d
WHERE d.DepartmentID NOT IN (SELECT DepartmentID FROM DimDepartment);

INSERT INTO DimRoom (RoomID, Purpose)
SELECT 
    r.RoomID,
    r.Purpose
FROM CA29707406.room r
WHERE r.RoomID NOT IN (SELECT RoomID FROM DimRoom);

INSERT INTO DimDoctor (DoctorID, DoctorName, DepartmentID)
SELECT 
	d.DoctorID,
    d.DoctorName,
    d.DepartmentID
FROM CA29707406.doctor d
WHERE d.DoctorID NOT IN (SELECT DoctorID FROM DimDoctor);

INSERT INTO DimPatient (PatientID, PatientName, DOB, Sex, Address)
SELECT 
	p.PatientID,
    p.PatientName,
    p.DOB,
    p.Sex,
    p.Address
FROM CA29707406.patient p
WHERE p.PatientID NOT IN (SELECT PatientID FROM DimPatient);

INSERT INTO DimDate (FullDate, Year, Quarter, Month, Day, DayName)
SELECT
	DISTINCT(DATE_FORMAT(a.ScheduledStart, '%Y%m%d')) AS FullDate,
	YEAR(a.ScheduledStart),
    QUARTER(a.ScheduledStart),
	MONTH(a.ScheduledStart),
    DAY(a.ScheduledStart),
	DAYNAME(a.ScheduledStart)
FROM CA29707406.Appointment a
WHERE (DATE_FORMAT(a.ScheduledStart, '%Y%m%d')) NOT IN (SELECT DISTINCT(DateKey) FROM DimDate);

INSERT INTO FactAppointment (
    PatientKey, DoctorKey, RoomKey, DepartmentKey, DateKey, ScheduledStartTime, ScheduledEndTime,
    ArrivalTime, StartTime, FinishTime, Weight, Temperature
)
SELECT 
    dp.PatientKey,
    dd.DoctorKey,
    dr.RoomKey,
    dpt.DepartmentKey,
    ddate.DateKey,
    TIME(a.ScheduledStart) AS ScheduledStartTime,
    Time(a.ScheduledEnd) AS ScheduledEndTime,
    TIME(a.ArrivalTime) AS ArrivalTime,
    TIME(a.StartTime) AS StartTime,
    TIME(a.FinishTime) as FinishTime,
    a.Weight,
    a.Temperature
FROM CA29707406.Appointment a
JOIN DimPatient dp ON a.PatientID = dp.PatientID
JOIN DimDoctor dd ON a.DoctorID = dd.DoctorID
JOIN DimRoom dr ON a.RoomID = dr.RoomID
JOIN DimDepartment dpt ON dd.DepartmentID = dpt.DepartmentID
JOIN DimDate ddate ON DATE_FORMAT(a.ScheduledStart, '%Y%m%d') = ddate.FullDate
WHERE NOT EXISTS (
    SELECT 1
    FROM FactAppointment fa
    WHERE fa.PatientKey = dp.PatientKey
      AND fa.DoctorKey = dd.DoctorKey
      AND fa.RoomKey = dr.RoomKey
      AND fa.ScheduledStartTime = TIME(a.ScheduledStart)
);

/*
-- Verify that insertion is successful by comparing the number of rows in DW & OLTP
SELECT 
(SELECT COUNT(*) FROM CA29707406.room) 'OLTPRoom',
(SELECT COUNT(*) FROM CA2DW9707406.dimroom) 'DWRoom',
(SELECT COUNT(*) FROM CA29707406.department) 'OLTPDept',
(SELECT COUNT(*) FROM CA2DW9707406.dimdepartment) 'DWDept',
(SELECT COUNT(*) FROM CA29707406.doctor) 'OLTPDoc',
(SELECT COUNT(*) FROM CA2DW9707406.dimdoctor) 'DWDoc',
(SELECT COUNT(*) FROM CA29707406.patient) 'OLTPPatient',
(SELECT COUNT(*) FROM CA2DW9707406.dimdoctor) 'DWPatient',
(SELECT COUNT(*) FROM CA29707406.appointment) 'OLTPAppt',
(SELECT COUNT(*) FROM CA2DW9707406.factappointment) 'DWAppt',
(SELECT COUNT(DISTINCT(DATE_FORMAT(ScheduledStart, '%Y%m%d'))) FROM CA29707406.appointment) 'OLTPApptDate',
(SELECT COUNT(*) FROM CA2DW9707406.dimdate) 'DWApptDate';
*/
