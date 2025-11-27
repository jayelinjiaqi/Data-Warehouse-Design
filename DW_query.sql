-- Analytical queries to extract insights from the available data in the data warehouse

USE CA2DW9707406;
-- Q1. Are there any trends or patterns in consultation duration over time?
-- Appointment hours by quarter
-- There is a year on year increase every year from 2020 - 2024
-- Appointment hours are consistent accross quarters
SELECT dd.Year,
ROUND(SUM(CASE WHEN dd.Quarter = 1 
THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Q1_Hrs,
ROUND(SUM(CASE WHEN dd.Quarter = 2 
THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Q2_Hrs,
ROUND(SUM(CASE WHEN dd.Quarter = 3 
THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Q3_Hrs,
ROUND(SUM(CASE WHEN dd.Quarter = 4 
THEN TIMESTAMPDIFF(SECOND,TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Q4_Hrs,
ROUND((SUM(TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0) / 4), 0) AS AvgConsultationDurationPerYear_Hrs
FROM FactAppointment fa JOIN DimDate dd ON fa.DateKey = dd.DateKey
GROUP BY dd.Year
ORDER BY dd.Year DESC;

-- Appointment count by year and month
-- April 2020 is an outlier, could be attributed to outbreak of major pandemic
SELECT Year, Month, COUNT(*) AS AppointmentCount
FROM FactAppointment a
JOIN DimDate ON a.DateKey = DimDate.DateKey
GROUP BY Year, Month
ORDER BY Year, Month;

-- Appointment hours by DayName (eg. Monday, Tuesday...)
-- Consistent accross all DayName (i.e. Monday - Sunday)
-- Similar year on year increase as per the observations in appointment hours by quarter
SELECT
dd.Year,
ROUND(SUM(CASE WHEN dd.DayName = 'Monday' THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Mon_Hrs,
ROUND(SUM(CASE WHEN dd.DayName = 'Tuesday' THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Tue_Hrs,
ROUND(SUM(CASE WHEN dd.DayName = 'Wednesday' THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Wed_Hrs,
ROUND(SUM(CASE WHEN dd.DayName = 'Thursday' THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Thu_Hrs,
ROUND(SUM(CASE WHEN dd.DayName = 'Friday' THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Fri_Hrs,
ROUND(SUM(CASE WHEN dd.DayName = 'Saturday' THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Sat_Hrs,
ROUND(SUM(CASE WHEN dd.DayName = 'Sunday' THEN TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0 ELSE 0 END), 0) AS Sun_Hrs
FROM FactAppointment fa JOIN DimDate dd ON fa.DateKey = dd.DateKey
GROUP BY dd.Year
ORDER BY dd.Year DESC;

-- Appointment count by day of month
-- There is generally lesser appointment and shorter appointment duration on the 31st day of every month, 
-- it is attributed to the fact that some months only have 28, 29 or 30 days
SELECT
dd.Day, COUNT(*) AS AppointmentCount,
ROUND(SUM(TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0), 0) AS Total_Hours
FROM FactAppointment fa JOIN DimDate dd ON fa.DateKey = dd.DateKey
GROUP BY dd.Day
ORDER BY dd.Day;

-- To confirm the assumption that there are lesser appointment on 31st of every month as some months only have 28, 29, 30 days
-- And that there is no seasonal trend 
SELECT Year, DimDate.Day, DimDate.Month, COUNT(*) AS AppointmentCount
FROM FactAppointment
JOIN DimDate ON DATE_FORMAT(ScheduledStart, '%Y%m%d') = DateKey
GROUP BY Year, DimDate.Day, DimDate.Month
ORDER BY Year;

-- No. of appointment at ScheduledStartTime
SELECT HOUR(fa.ScheduledStartTime) AS HourOfDay, COUNT(*) AS AppointmentCount,
ROUND(AVG(TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(fa.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(fa.FinishTime, 0))) / 3600.0), 2) AS Avg_Appt_Hrs
FROM FactAppointment fa JOIN DimDate dd ON fa.DateKey = dd.DateKey
GROUP BY HourOfDay
ORDER BY HourOfDay ASC;

-- Appointment count has a decreasing trend every year but there is an increase in appointment hours every year 
SELECT Year, COUNT(*) AS AppointmentCount
FROM FactAppointment
JOIN DimDate ON FactAppointment.DateKey = DimDate.DateKey
JOIN DimDepartment ON FactAppointment.DepartmentKey = DimDepartment.DepartmentKey
GROUP BY Year
ORDER BY Year;

-- Q2.	Are there any outstanding patients or doctors with significantly higher / lower total consultation time

-- AppointmentCount and AppointmentHours by Department, Doctor and AvgPatientAge
-- Pediatricians generally have longer appointment duration
-- Lily Adams is likely to be wrongly classified under the pediatrics department as her average patient age is 48 years old
-- whereas the average patient age for pediatricians is 11 years old
SELECT DimDepartment.DepartmentName,DimDoctor.DoctorName, AVG(YEAR(CURRENT_DATE()) - YEAR(DimPatient.DOB)) AS AvgPatientAge,
COUNT(*) AS AppointmentCount,
ROUND(SUM(TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, FactAppointment.StartTime), TIMESTAMP(dd.FullDate, FactAppointment.FinishTime))) / 3600.0, 0) AS AppointmentHours
FROM FactAppointment JOIN DimDoctor ON FactAppointment.DoctorKey = DimDoctor.DoctorKey
JOIN DimDate AS dd ON FactAppointment.DateKey = dd.DateKey
JOIN DimDepartment ON FactAppointment.DepartmentKey = DimDepartment.DepartmentKey
JOIN DimPatient ON FactAppointment.PatientKey = DimPatient.PatientKey
GROUP BY DimDepartment.DepartmentName,DimDoctor.DoctorName
ORDER BY DepartmentName DESC, AppointmentHours DESC;



-- AppointmentCount and AppointmentHours by Patient and Age
-- Zachary Johnson has a significantly higher appointment count and appointment hours
-- The appointment hours of Zachary Johnson is x10 that of Erik Wiggins (patient with the second highest appointment hours).
SELECT DimPatient.PatientName, (YEAR(CURRENT_DATE()) - YEAR(DimPatient.DOB)) AS Age,
COUNT(*) AS AppointmentCount, ROUND(SUM(TIMESTAMPDIFF(SECOND, TIMESTAMP(DimDate.FullDate, FactAppointment.StartTime), TIMESTAMP(DimDate.FullDate, FactAppointment.FinishTime))) / 3600.0, 0) AS AppointmentHours
FROM FactAppointment JOIN DimDate ON FactAppointment.DateKey = DimDate.DateKey
JOIN DimPatient ON FactAppointment.PatientKey = DimPatient.PatientKey
JOIN DimDoctor ON FactAppointment.DoctorKey = DimDoctor.DoctorKey
JOIN DimDepartment ON FactAppointment.DepartmentKey = DimDepartment.DepartmentKey
GROUP BY DimPatient.PatientName, (YEAR(CURRENT_DATE()) - YEAR(DimPatient.DOB))
ORDER BY AppointmentHours DESC;

-- AppointmentCount, AppointmentHours and Time Per Appointment by Department
SELECT DimDepartment.DepartmentName, COUNT(*) AS AppointmentCount,
ROUND(SUM(TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(FactAppointment.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(FactAppointment.FinishTime, 0))) / 3600.0), 0) AS Hours,
ROUND((SUM(TIMESTAMPDIFF(SECOND, TIMESTAMP(dd.FullDate, IFNULL(FactAppointment.StartTime, 0)), TIMESTAMP(dd.FullDate, IFNULL(FactAppointment.FinishTime, 0))) / 3600.0) / COUNT(*)), 2) AS TimePerApp
FROM FactAppointment JOIN DimDepartment ON FactAppointment.DepartmentKey = DimDepartment.DepartmentKey
JOIN DimDate dd ON FactAppointment.DateKey = dd.DateKey
GROUP BY DimDepartment.DepartmentName
ORDER BY DimDepartment.DepartmentName;

-- List Zachary Johnson's doctor, department name and appointment scheduled start date and time
SELECT AppointmentKey, PatientKey, DimDoctor.DoctorName, DimDepartment.DepartmentName, FactAppointment.ScheduledStartTime
FROM FactAppointment JOIN DimDoctor ON FactAppointment.DoctorKey = DimDoctor.DoctorKey
JOIN DimDepartment ON FactAppointment.DepartmentKey = DimDepartment.DepartmentKey
WHERE PatientKey = (SELECT PatientKey FROM DimPatient WHERE PatientName = 'Zachary Johnson');

/*
-- Query not used in CA2_template submitted
-- Appointment count by quarter and percentage changed from previous quarter
SELECT Year, Quarter, AppointmentCount,
CONCAT(ROUND((AppointmentCount - LAG(AppointmentCount) OVER (PARTITION BY Year ORDER BY Quarter)) 
/ NULLIF(LAG(AppointmentCount) OVER (PARTITION BY Year ORDER BY Quarter), 0) * 100, 2), '%') AS PercentIncrease
FROM (
    SELECT DimDate.Year, DimDate.Quarter, COUNT(*) AS AppointmentCount
    FROM FactAppointment
    JOIN DimDate ON FactAppointment.DateKey = DimDate.DateKey
    GROUP BY DimDate.Year, DimDate.Quarter) AS QuarterlyData
ORDER BY Year, Quarter;

-- Appointment duration by department and year
SELECT DimDepartment.DepartmentName,
SUM(CASE WHEN DimDate.Year = 2020 THEN TIMESTAMPDIFF(SECOND, FactAppointment.StartTime, FactAppointment.FinishTime) ELSE 0 END) / 3600.0 AS 2020_Hrs,
SUM(CASE WHEN DimDate.Year = 2021 THEN TIMESTAMPDIFF(SECOND, FactAppointment.StartTime, FactAppointment.FinishTime) ELSE 0 END) / 3600.0 AS 2021_Hrs,
SUM(CASE WHEN DimDate.Year = 2022 THEN TIMESTAMPDIFF(SECOND, FactAppointment.StartTime, FactAppointment.FinishTime) ELSE 0 END) / 3600.0 AS 2022_Hrs,
SUM(CASE WHEN DimDate.Year = 2023 THEN TIMESTAMPDIFF(SECOND, FactAppointment.StartTime, FactAppointment.FinishTime) ELSE 0 END) / 3600.0 AS 2023_Hrs,
SUM(CASE WHEN DimDate.Year = 2024 THEN TIMESTAMPDIFF(SECOND, FactAppointment.StartTime, FactAppointment.FinishTime) ELSE 0 END) / 3600.0 AS 2024_Hrs
FROM FactAppointment JOIN DimDate ON FactAppointment.DateKey = DimDate.DateKey
JOIN DimDepartment ON FactAppointment.DepartmentKey = DimDepartment.DepartmentKey
GROUP BY DimDepartment.DepartmentName
ORDER BY DimDepartment.DepartmentName;

-- Rooms used by Lily Adams
SELECT Purpose FROM DimRoom WHERE RoomKey IN 
(SELECT RoomKey FROM FactAppointment 
WHERE DoctorKey IN (SELECT DoctorKey FROM DimDoctor WHERE DoctorName = 'Lily Adams'))
*/
