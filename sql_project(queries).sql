-- Question 1
-- How many patients visit the hospital over time (monthly & yearly)?
SELECT
    EXTRACT(YEAR FROM visitdate) AS year,
    COUNT(*) AS total_visits
FROM visit
GROUP BY EXTRACT(YEAR FROM visitdate)
ORDER BY year;

SELECT
    EXTRACT(YEAR FROM visitdate)  AS year,
    EXTRACT(MONTH FROM visitdate) AS month,
    COUNT(*) AS total_visits
FROM visit
GROUP BY
    EXTRACT(YEAR FROM visitdate),
    EXTRACT(MONTH FROM visitdate)
ORDER BY year, month;


-- Question 2
-- Which departments receive the highest OPD visits?
SELECT
    dp.name AS department,
    COUNT(*) AS total_opd_visits
FROM visit v
JOIN doctor d
    ON v.doctorid = d.doctorid
JOIN department dp
    ON d.departmentid = dp.departmentid
GROUP BY dp.name
ORDER BY total_opd_visits DESC;


-- Question 3
-- What is the OPD vs IPD ratio?

-- 1. OPD vs IPD ratio (count and percentage form)
SELECT
    patient_type,
    patient_count,
    ROUND(
        patient_count * 100.0 /
        SUM(patient_count) OVER (),
        2
    ) AS percentage
FROM (
    SELECT 'OPD' AS patient_type, COUNT(*) AS patient_count FROM visit
    UNION ALL
    SELECT 'IPD', COUNT(*) FROM admission
) t;

-- 2. OPD to IPD conversion rate
SELECT
    COUNT(DISTINCT a.patientid) AS admitted_patients,
    COUNT(DISTINCT v.patientid) AS opd_patients,
    ROUND(
        COUNT(DISTINCT a.patientid) * 100.0 /
        COUNT(DISTINCT v.patientid),
        2
    ) AS opd_to_ipd_conversion_rate
FROM visit v
LEFT JOIN admission a
    ON v.patientid = a.patientid;


-- Question 4
-- Which doctors handle the highest patient load?
SELECT
    d.doctorid,
    d.firstname || ' ' || d.lastname AS doctor_name,
    dp.name AS department,
    COUNT(v.visitid) AS total_opd_visits
FROM visit v
JOIN doctor d
    ON v.doctorid = d.doctorid
JOIN department dp
    ON d.departmentid = dp.departmentid
GROUP BY d.doctorid, doctor_name, dp.name
ORDER BY total_opd_visits DESC;


-- Question 5
-- What is the admission rate per department?
WITH opd_visits AS (
    SELECT
        dp.departmentid,
        dp.name AS department,
        COUNT(*) AS opd_count
    FROM visit v
    JOIN doctor d ON v.doctorid = d.doctorid
    JOIN department dp ON d.departmentid = dp.departmentid
    GROUP BY dp.departmentid, dp.name
),
admissions AS (
    SELECT
        dp.departmentid,
        COUNT(*) AS admission_count
    FROM admission a
    JOIN doctor d ON a.doctorid = d.doctorid
    JOIN department dp ON d.departmentid = dp.departmentid
    GROUP BY dp.departmentid
)
SELECT
    o.department,
    o.opd_count,
    COALESCE(a.admission_count, 0) AS admission_count,
    ROUND(
        COALESCE(a.admission_count, 0) * 100.0 / o.opd_count,
        2
    ) AS admission_rate_percent
FROM opd_visits o
LEFT JOIN admissions a
    ON o.departmentid = a.departmentid
ORDER BY admission_rate_percent DESC;


-- Question 6
-- What is the Average Length of Stay (LOS) by department?

-- 1. Average LOS by department
SELECT
    dp.name AS department,
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (ds.dischargedate - a.admissiondate)) / 86400
        ),
        2
    ) AS avg_length_of_stay_days
FROM admission a
JOIN discharge ds
    ON a.admissionid = ds.admissionid
JOIN doctor d
    ON a.doctorid = d.doctorid
JOIN department dp
    ON d.departmentid = dp.departmentid
GROUP BY dp.name
ORDER BY avg_length_of_stay_days DESC;

-- 2. LOS distribution
SELECT
    dp.name AS department,
    round(MIN(EXTRACT(EPOCH FROM (ds.dischargedate - a.admissiondate)) / 86400),2) AS min_los_days,
	round(MAX(EXTRACT(EPOCH FROM (ds.dischargedate - a.admissiondate)) / 86400),2) AS max_los_days,
	ROUND(AVG(EXTRACT(EPOCH FROM (ds.dischargedate - a.admissiondate)) / 86400),2) AS avg_los_days
FROM admission a
JOIN discharge ds
    ON a.admissionid = ds.admissionid
JOIN doctor d
    ON a.doctorid = d.doctorid
JOIN department dp
    ON d.departmentid = dp.departmentid
GROUP BY dp.name
ORDER BY avg_los_days DESC;


-- Question 7
-- What is the bed occupancy rate?

-- 1. Bed Occupancy Rate
WITH bed_stats AS (SELECT COUNT(*) AS total_beds FROM bed),
date_range AS (
	SELECT round(EXTRACT(EPOCH FROM (MAX(ds.dischargedate) - MIN(a.admissiondate))) / 86400 , 2)AS total_days
    FROM admission a
    JOIN discharge ds ON a.admissionid = ds.admissionid
),
occupied_days AS (
    SELECT round(SUM(EXTRACT(EPOCH FROM (ds.dischargedate - a.admissiondate)) / 86400),2) AS occupied_bed_days
    FROM admission a
    JOIN discharge ds ON a.admissionid = ds.admissionid
)
SELECT ROUND( (occupied_bed_days / (total_beds * total_days)) * 100,2) AS bed_occupancy_rate_percent
FROM bed_stats, date_range, occupied_days;

-- 2. Bed occupancy by ward
WITH ward_beds AS (
    SELECT wardid, COUNT(*) AS total_beds
    FROM bed
    WHERE wardid IS NOT NULL
    GROUP BY wardid
),
ward_occupied_days AS (
    SELECT
        a.bedid,
        SUM(EXTRACT(EPOCH FROM (ds.dischargedate - a.admissiondate)) / 86400)
            AS occupied_days
    FROM admission a
    JOIN discharge ds
        ON a.admissionid = ds.admissionid
    GROUP BY a.bedid
)
SELECT
    w.name AS ward,
    ROUND(
        SUM(COALESCE(wod.occupied_days,0)) /
        (wb.total_beds *
         (SELECT EXTRACT(EPOCH FROM (MAX(dischargedate) - MIN(admissiondate))) / 86400
          FROM admission a2 JOIN discharge d2 ON a2.admissionid = d2.admissionid)
        ) * 100,
        2
    ) AS ward_bed_occupancy_percent
FROM ward_beds wb
JOIN ward w ON wb.wardid = w.wardid
LEFT JOIN ward_occupied_days wod ON wb.wardid = wod.bedid
GROUP BY w.name, wb.total_beds
ORDER BY ward_bed_occupancy_percent DESC;


-- Question 8
-- Which wards and units are most utilized?

-- 1. Ward-wise utilization
SELECT
    w.name AS ward,
    COUNT(DISTINCT b.bedid) AS total_beds,
    ROUND(SUM(EXTRACT(EPOCH FROM (ds.dischargedate - a.admissiondate)) / 86400),2) AS total_bed_days_occupied
FROM admission a
JOIN discharge ds
    ON a.admissionid = ds.admissionid
JOIN bed b
    ON a.bedid = b.bedid
JOIN ward w
    ON b.wardid = w.wardid
GROUP BY w.name
ORDER BY total_bed_days_occupied DESC;

-- 2. Ward utilization rate
WITH ward_beds AS (
    SELECT
        wardid,
        COUNT(*) AS total_beds
    FROM bed
    WHERE wardid IS NOT NULL
    GROUP BY wardid
),
ward_occupied_days AS (
    SELECT
        b.wardid,
        round(SUM(EXTRACT(EPOCH FROM (ds.dischargedate - a.admissiondate)) / 86400),2) AS occupied_days
    FROM admission a
    JOIN discharge ds ON a.admissionid = ds.admissionid
    JOIN bed b ON a.bedid = b.bedid
    GROUP BY b.wardid
),
date_range AS (
    SELECT
        round(EXTRACT(EPOCH FROM (MAX(ds.dischargedate) - MIN(a.admissiondate))) / 86400 , 2) AS total_days
    FROM admission a
    JOIN discharge ds ON a.admissionid = ds.admissionid
)
SELECT
    w.name AS ward,
    wb.total_beds,
    ROUND((wo.occupied_days / (wb.total_beds * dr.total_days)) * 100,2) AS ward_utilization_percent
FROM ward_beds wb
JOIN ward w ON wb.wardid = w.wardid
JOIN ward_occupied_days wo ON wb.wardid = wo.wardid
CROSS JOIN date_range dr
ORDER BY ward_utilization_percent DESC;

-- 3. Unit-wise utilization
WITH unit_occupied_days AS (
    SELECT
        u.unitid,
        round(SUM(EXTRACT(EPOCH FROM (ds.dischargedate - a.admissiondate)) / 86400),2) AS occupied_days
    FROM admission a
    JOIN discharge ds ON a.admissionid = ds.admissionid
    JOIN bed b ON a.bedid = b.bedid
    JOIN ward w ON b.wardid = w.wardid
    JOIN unit u ON w.unitid = u.unitid
    GROUP BY u.unitid
),
unit_beds AS (
    SELECT
        u.unitid,
        COUNT(b.bedid) AS total_beds
    FROM unit u
    JOIN ward w ON u.unitid = w.unitid
    JOIN bed b ON w.wardid = b.wardid
    GROUP BY u.unitid
),
date_range AS (
    SELECT
        round(EXTRACT(EPOCH FROM (MAX(ds.dischargedate) - MIN(a.admissiondate))) / 86400 ,2) AS total_days
    FROM admission a
    JOIN discharge ds ON a.admissionid = ds.admissionid
)
SELECT
    u.name AS unit,
    ROUND((uo.occupied_days / (ub.total_beds * dr.total_days)) * 100,2) AS unit_utilization_percent
FROM unit_occupied_days uo
JOIN unit_beds ub ON uo.unitid = ub.unitid
JOIN unit u ON uo.unitid = u.unitid
CROSS JOIN date_range dr
ORDER BY unit_utilization_percent DESC;


-- Question 9
-- What are the peak admission days and discharge patterns?

-- 1. Daily admission trend (date-wise)
SELECT
    admissiondate::date AS admission_date,
    COUNT(*) AS total_admissions
FROM admission
GROUP BY admissiondate::date
ORDER BY total_admissions DESC;

-- 2. Daily discharge trend (date-wise)
SELECT
    dischargedate::date AS discharge_date,
    COUNT(*) AS total_discharges
FROM discharge
GROUP BY dischargedate::date
ORDER BY total_discharges DESC;

-- 3. Admissions by day of week
SELECT
    TO_CHAR(admissiondate, 'Day') AS day_of_week,
    COUNT(*) AS total_admissions
FROM admission
GROUP BY TO_CHAR(admissiondate, 'Day'),
         EXTRACT(DOW FROM admissiondate)
ORDER BY EXTRACT(DOW FROM admissiondate);

-- 4. Discharges by day of week
SELECT
    TO_CHAR(dischargedate, 'Day') AS day_of_week,
    COUNT(*) AS total_discharges
FROM discharge
GROUP BY TO_CHAR(dischargedate, 'Day'),
         EXTRACT(DOW FROM dischargedate)
ORDER BY EXTRACT(DOW FROM dischargedate);

-- 5. Admission vs discharge comparison
SELECT
    d::date AS date,
    COUNT(a.admissionid) AS admissions,
    COUNT(ds.admissionid) AS discharges
FROM generate_series(
        (SELECT MIN(admissiondate)::date FROM admission),
        (SELECT MAX(dischargedate)::date FROM discharge),
        INTERVAL '1 day'
     ) d
LEFT JOIN admission a
    ON a.admissiondate::date = d::date
LEFT JOIN discharge ds
    ON ds.dischargedate::date = d::date
GROUP BY d::date
ORDER BY d::date;


-- Question 10
-- What is the total revenue split by OPD vs IPD?

-- 1. Total revenue by OPD vs IPD 
SELECT
    CASE
        WHEN visitid IS NOT NULL THEN 'OPD'
        ELSE 'IPD'
    END AS patient_type,
    ROUND(SUM(amount), 2) AS total_revenue
FROM charge
GROUP BY patient_type;

-- 2. Revenue split as percentage
SELECT
    patient_type,
    total_revenue,
    ROUND(
        total_revenue * 100.0 /
        SUM(total_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM (
    SELECT
        CASE
            WHEN visitid IS NOT NULL THEN 'OPD'
            ELSE 'IPD'
        END AS patient_type,
        SUM(amount) AS total_revenue
    FROM charge
    GROUP BY patient_type
) t;


-- Question 11
-- What is the revenue contribution by department?

-- 1. Department-wise total revenue
SELECT
    dp.name AS department,
    ROUND(SUM(c.amount), 2) AS total_revenue
FROM charge c
LEFT JOIN visit v
    ON c.visitid = v.visitid
LEFT JOIN admission a
    ON c.admissionid = a.admissionid
JOIN doctor d
    ON d.doctorid = COALESCE(v.doctorid, a.doctorid)
JOIN department dp
    ON d.departmentid = dp.departmentid
GROUP BY dp.name
ORDER BY total_revenue DESC;

-- 2. Department-wise revenue split by OPD vs IPD
SELECT
    dp.name AS department,
    CASE
        WHEN c.visitid IS NOT NULL THEN 'OPD'
        ELSE 'IPD'
    END AS patient_type,
    ROUND(SUM(c.amount), 2) AS revenue
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid
JOIN doctor d ON d.doctorid = COALESCE(v.doctorid, a.doctorid)
JOIN department dp ON d.departmentid = dp.departmentid
GROUP BY dp.name, patient_type
ORDER BY dp.name, revenue DESC;

-- 3. Department revenue as percentage of total
SELECT
    department,
    total_revenue,
    ROUND(
        total_revenue * 100.0 /
        SUM(total_revenue) OVER (),
        2
    ) AS revenue_percentage
FROM (
    SELECT
        dp.name AS department,
        SUM(c.amount) AS total_revenue
    FROM charge c
    LEFT JOIN visit v ON c.visitid = v.visitid
    LEFT JOIN admission a ON c.admissionid = a.admissionid
    JOIN doctor d ON d.doctorid = COALESCE(v.doctorid, a.doctorid)
    JOIN department dp ON d.departmentid = dp.departmentid
    GROUP BY dp.name
) t
ORDER BY revenue_percentage DESC;


-- Question 12
-- Which services generate the most revenue?

-- 1. Top revenue-generating services
SELECT
    s.name AS service_name,
    sc.name AS service_category,
    ROUND(SUM(c.amount), 2) AS total_revenue
FROM charge c
JOIN service s
    ON c.serviceid = s.serviceid
JOIN servicecategory sc
    ON s.servicecategoryid = sc.servicecategoryid
GROUP BY s.name, sc.name
ORDER BY total_revenue DESC;

-- 2. Service revenue split by OPD vs IPD
SELECT
    s.name AS service_name,
    CASE
        WHEN c.visitid IS NOT NULL THEN 'OPD'
        ELSE 'IPD'
    END AS patient_type,
    ROUND(SUM(c.amount), 2) AS revenue
FROM charge c
JOIN service s ON c.serviceid = s.serviceid
GROUP BY s.name, patient_type
ORDER BY s.name, revenue DESC;

-- 3. Service category-wise revenue
SELECT
    sc.name AS service_category,
    ROUND(SUM(c.amount), 2) AS total_revenue
FROM charge c
JOIN service s ON c.serviceid = s.serviceid
JOIN servicecategory sc ON s.servicecategoryid = sc.servicecategoryid
GROUP BY sc.name
ORDER BY total_revenue DESC;


-- Question 13
-- What is the impact of concessions on total revenue?

-- 1. Overall concession impact
SELECT
    ROUND(SUM(amount), 2) AS gross_revenue,
    ROUND(SUM(concession), 2) AS total_concession,
    ROUND(SUM(amount - concession), 2) AS net_revenue,
    ROUND(
        SUM(concession) * 100.0 / SUM(amount),
        2
    ) AS concession_percentage
FROM charge;

-- 2. OPD vs IPD concession comparison
SELECT
    CASE
        WHEN visitid IS NOT NULL THEN 'OPD'
        ELSE 'IPD'
    END AS patient_type,
    ROUND(SUM(amount), 2) AS gross_revenue,
    ROUND(SUM(concession), 2) AS total_concession,
    ROUND(
        SUM(concession) * 100.0 / SUM(amount),
        2
    ) AS concession_percentage
FROM charge
GROUP BY patient_type;

-- 3. Department-wise concession impact
SELECT
    dp.name AS department,
    ROUND(SUM(c.amount), 2) AS gross_revenue,
    ROUND(SUM(c.concession), 2) AS total_concession,
    ROUND(
        SUM(c.concession) * 100.0 / SUM(c.amount),
        2
    ) AS concession_percentage
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid
JOIN doctor d ON d.doctorid = COALESCE(v.doctorid, a.doctorid)
JOIN department dp ON d.departmentid = dp.departmentid
GROUP BY dp.name
ORDER BY concession_percentage DESC;


-- Question 14
-- How does revenue differ by patient category (Self / Company / Staff / Staff Dependent)?

-- 1. Revenue by patient category
SELECT
    pc.name AS patient_category,
    ROUND(SUM(c.amount - c.concession), 2) AS net_revenue
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid
JOIN patientcategory pc
    ON pc.patientcategoryid = COALESCE(v.patientcategoryid, a.patientcategoryid)
GROUP BY pc.name
ORDER BY net_revenue DESC;

-- 2. OPD vs IPD revenue by patient category
SELECT
    pc.name AS patient_category,
    CASE
        WHEN c.visitid IS NOT NULL THEN 'OPD'
        ELSE 'IPD'
    END AS patient_type,
    ROUND(SUM(c.amount - c.concession), 2) AS net_revenue
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid
JOIN patientcategory pc
    ON pc.patientcategoryid = COALESCE(v.patientcategoryid, a.patientcategoryid)
GROUP BY pc.name, patient_type
ORDER BY pc.name, net_revenue DESC;

-- 3. Patient category contribution percentage (executive KPI)
SELECT
    pc.name AS patient_category,
    ROUND(
        SUM(c.amount - c.concession) * 100.0 /
        SUM(SUM(c.amount - c.concession)) OVER (),
        2
    ) AS revenue_percentage
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid
JOIN patientcategory pc
    ON pc.patientcategoryid = COALESCE(v.patientcategoryid, a.patientcategoryid)
GROUP BY pc.name
ORDER BY revenue_percentage DESC;


-- Question 15
-- Which doctors generate the highest revenue for the hospital?

-- 1. Top revenue-generating doctors
SELECT
    d.doctorid,
    d.firstname || ' ' || d.lastname AS doctor_name,
    dp.name AS department,
    ROUND(SUM(c.amount - c.concession), 2) AS net_revenue
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid
JOIN doctor d
    ON d.doctorid = COALESCE(v.doctorid, a.doctorid)
JOIN department dp
    ON d.departmentid = dp.departmentid
GROUP BY d.doctorid, doctor_name, dp.name
ORDER BY net_revenue DESC;

-- 2. OPD vs IPD revenue contribution per doctor
SELECT
    d.doctorid, d.firstname || ' ' || d.lastname AS doctor_name,
    CASE
        WHEN c.visitid IS NOT NULL THEN 'OPD'
        ELSE 'IPD'
    END AS patient_type,
    ROUND(SUM(c.amount - c.concession), 2) AS net_revenue
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid
JOIN doctor d ON d.doctorid = COALESCE(v.doctorid, a.doctorid)
GROUP BY d.doctorid, doctor_name, patient_type
ORDER BY net_revenue DESC;


-- Question 16
-- Which departments generate the highest net revenue?
SELECT
    dp.name AS department,
    ROUND(SUM(c.amount - c.concession), 2) AS net_revenue
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid
JOIN doctor d
    ON d.doctorid = COALESCE(v.doctorid, a.doctorid)
JOIN department dp
    ON d.departmentid = dp.departmentid
GROUP BY dp.name
ORDER BY net_revenue DESC;


-- Question 17
-- What is the Average Revenue Per Patient (ARPP)?

-- Overall Average Revenue Per Patient (MAIN KPI)
SELECT
    ROUND(
        SUM(c.amount - c.concession) * 1.0
        / COUNT(DISTINCT COALESCE(v.patientid, a.patientid)),
        2
    ) AS avg_revenue_per_patient
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid;

-- 2. OPD vs IPD Average Revenue Per Patient
SELECT
    patient_type,
    ROUND(
        SUM(net_revenue) / COUNT(DISTINCT patientid),
        2
    ) AS avg_revenue_per_patient
FROM (
    SELECT
        CASE
            WHEN c.visitid IS NOT NULL THEN 'OPD'
            ELSE 'IPD'
        END AS patient_type,
        COALESCE(v.patientid, a.patientid) AS patientid,
        (c.amount - c.concession) AS net_revenue
    FROM charge c
    LEFT JOIN visit v ON c.visitid = v.visitid
    LEFT JOIN admission a ON c.admissionid = a.admissionid
) t
group by patient_type

-- 3. Department-wise ARPP
SELECT
    dp.name AS department,
    ROUND(
        SUM(c.amount - c.concession)
        / COUNT(DISTINCT COALESCE(v.patientid, a.patientid)),
        2
    ) AS avg_revenue_per_patient
FROM charge c
LEFT JOIN visit v ON c.visitid = v.visitid
LEFT JOIN admission a ON c.admissionid = a.admissionid
JOIN doctor d ON d.doctorid = COALESCE(v.doctorid, a.doctorid)
JOIN department dp ON d.departmentid = dp.departmentid
GROUP BY dp.name
ORDER BY avg_revenue_per_patient DESC;


-- Question 18
-- What are the peak OPD visits and IPD admissions over time?

-- 1. Monthly OPD visit trend
SELECT
    TO_CHAR(DATE_TRUNC('month', visitdate), 'Mon-YYYY') AS month,
    COUNT(*) AS opd_visits
FROM visit
GROUP BY month
ORDER BY MIN(DATE_TRUNC('month', visitdate));

-- 2. Monthly IPD admission trend
SELECT
    TO_CHAR(DATE_TRUNC('month', admissiondate), 'Mon-YYYY') AS month,
    COUNT(*) AS ipd_admissions
FROM admission
GROUP BY month
ORDER BY month;

-- 3. Combined OPD vs IPD trend (VERY POWERFUL)
SELECT
    month,
    SUM(opd) AS opd_visits,
    SUM(ipd) AS ipd_admissions
FROM (
    SELECT
        TO_CHAR(DATE_TRUNC('month', visitdate), 'Mon-YYYY') AS month,
        COUNT(*) AS opd,
        0 AS ipd
    FROM visit
    GROUP BY month

    UNION ALL

    SELECT
        TO_CHAR(DATE_TRUNC('month', admissiondate), 'Mon-YYYY') AS month,
        0 AS opd,
        COUNT(*) AS ipd
    FROM admission
    GROUP BY month
) t
GROUP BY month
ORDER BY month;

-- 4. Peak OPD day of the week (operational gold)
SELECT
    TO_CHAR(visitdate, 'Day') AS day_of_week,
    COUNT(*) AS opd_visits
FROM visit
GROUP BY day_of_week
ORDER BY opd_visits DESC;

-- 5. Peak IPD admission day
SELECT
    TO_CHAR(admissiondate, 'Day') AS day_of_week,
    COUNT(*) AS ipd_admissions
FROM admission
GROUP BY day_of_week
ORDER BY ipd_admissions DESC;




