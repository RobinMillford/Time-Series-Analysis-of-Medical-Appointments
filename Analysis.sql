use DB;

--Total values
SELECT COUNT(*) AS total_values
FROM patients;

--number of appointments for each day
SELECT AppointmentDay, COUNT(*) AS AppointmentCount
FROM patients
GROUP BY AppointmentDay
ORDER BY AppointmentDay;

--Average Appointmet Per day
SELECT ROUND(AVG(AppointmentCount), 0) AS AverageAppointmentsPerDay
FROM (
    SELECT AppointmentDay, COUNT(*) AS AppointmentCount
    FROM patients
    GROUP BY AppointmentDay
) AS AppointmentCounts;

-- Highest AppointmentCount
SELECT
Top 1
AppointmentDay, COUNT(*) AS AppointmentCount
FROM patients
GROUP BY AppointmentDay
ORDER BY AppointmentCount DESC;

-- monthly average number of appointments
SELECT DATEADD(month, DATEDIFF(month, 0, AppointmentDay), 0) AS Month,
       ROUND(AVG(1.0 * AppointmentCount), 2) AS AverageAppointments
FROM (
    SELECT AppointmentDay, COUNT(*) AS AppointmentCount
    FROM patients
    GROUP BY AppointmentDay
) AS MonthlyAppointments
GROUP BY DATEADD(month, DATEDIFF(month, 0, AppointmentDay), 0);

-- Monthly Highest Appointment
SELECT TOP 1 DATEADD(month, DATEDIFF(month, 0, AppointmentDay), 0) AS Month,
       COUNT(*) AS AppointmentCount
FROM patients
GROUP BY DATEADD(month, DATEDIFF(month, 0, AppointmentDay), 0)
ORDER BY AppointmentCount DESC;


-- weekly average
WITH WeeklyAppointments AS (
    SELECT DATEADD(DAY, -DATEPART(WEEKDAY, AppointmentDay) + 1, AppointmentDay) AS WeekStart,
           COUNT(*) AS AppointmentCount
    FROM patients
    GROUP BY DATEADD(DAY, -DATEPART(WEEKDAY, AppointmentDay) + 1, AppointmentDay)
)

SELECT WeekStart AS StartOfWeek,
       ROUND(AVG(1.0 * AppointmentCount), 2) AS AverageAppointments
FROM WeeklyAppointments
GROUP BY WeekStart
ORDER BY StartOfWeek;

-- Highest numbered week
WITH WeeklyAppointments AS (
    SELECT DATEADD(DAY, -DATEPART(WEEKDAY, AppointmentDay) + 1, AppointmentDay) AS WeekStart,
           COUNT(*) AS AppointmentCount
    FROM patients
    GROUP BY DATEADD(DAY, -DATEPART(WEEKDAY, AppointmentDay) + 1, AppointmentDay)
)

SELECT TOP 1 WeekStart AS StartOfWeek,
       AppointmentCount
FROM WeeklyAppointments
ORDER BY AppointmentCount DESC;

-- Gender wised
SELECT Gender, COUNT(*) AS AppointmentCount
FROM patients
GROUP BY Gender;

--number of appointments per weekday
SELECT DATENAME(WEEKDAY, AppointmentDay) AS Weekday,
       COUNT(*) AS AppointmentCount
FROM patients
GROUP BY DATENAME(WEEKDAY, AppointmentDay)
ORDER BY AppointmentCount DESC;

-- the average time between scheduling and the appointment day
SELECT ROUND(AVG(DATEDIFF(DAY, ScheduledDay, AppointmentDay)), 0) AS AverageTimeInDays
FROM patients;