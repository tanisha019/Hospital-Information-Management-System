-- 1. Patient Category
INSERT INTO patientcategory (name, addedby, updatedby) VALUES
('Self',1,1),('Company',1,1),('Staff',1,1),('StaffDependent',1,1);

-- 2. Gender
INSERT INTO gender (name, addedby, updatedby) VALUES 
('Male',1,1),('Female',1,1);

-- 3. Nationality
INSERT INTO nationality (name, addedby, updatedby)
VALUES ('Indian', 1, 1);


INSERT INTO country (name, nationalityid, addedby, updatedby)
SELECT 'India', nationalityid, 1, 1
FROM nationality
WHERE name = 'Indian';


-- 4. Insurance Company
INSERT INTO insurancecompany (name, addedby, updatedby) VALUES
('Star Health',1,1),('Vidal Healthcare',1,1),('Aditya Birla',1,1),
('HDFC Ergo',1,1),('ICICI Lombard',1,1),('The oriental Insurance company',1,1),
('Care Health Insurance',1,1);

-- 5. Department (ALL 23)
INSERT INTO department (name, isclinical, addedby, updatedby) VALUES
('Cardiology',true,1,1),('Gynaecology',true,1,1),('Medicine',true,1,1),
('Nephrology',true,1,1),('Ophthalmology',true,1,1),('Orthopedic',true,1,1),
('Paediatrics',true,1,1),('Physiotherapy',true,1,1),('Neurology',true,1,1),
('Surgery',true,1,1),('Dental',true,1,1),('ENT',true,1,1),
('Administration',false,1,1),('Reception',false,1,1),('Billing',false,1,1),
('Store',false,1,1),('Account',false,1,1),('Maintainance',false,1,1),
('Bio-Medical',false,1,1),('Computer(IT)',false,1,1),('Pathology',false,1,1),
('Radiology',false,1,1),('Nursing',false,1,1),('Pharmacy',false,1,1);

-- 6. Service Category
INSERT INTO servicecategory (name, addedby, updatedby) VALUES
('Cardiology',1,1),('Gynaecology',1,1),('Medicine',1,1),('Nephrology',1,1),
('Ophthalmology',1,1),('Orthopedic',1,1),('Paediatrics',1,1),('Physiotherapy',1,1),
('Neurology',1,1),('Surgery',1,1),('Dental',1,1),('ENT',1,1),
('Pathology',1,1),('Radiology',1,1),('Nursing',1,1);

-- 7. Service Type
INSERT INTO servicetype (name, addedby, updatedby) VALUES
('OPD',1,1),('IPD-General',1,1),('IPD-Special',1,1);

-- 8. Unit
INSERT INTO unit (name, addedby, updatedby) VALUES
('Unit 1',1,1),('Unit 2',1,1),('Unit 3',1,1),('Unit 4',1,1),('Unit 5',1,1);

-- 9. Ward
INSERT INTO ward (name, unitid, addedby, updatedby)
SELECT w.wardname, u.unitid, 1, 1
FROM (
    VALUES
    ('Geneal Ward'),
    ('Male Ward'),
    ('Female Ward'),
    ('pediatric ward'),
    ('Special Ward'),
    ('Semi Special ward'),
    ('Geneal Ward II')
) w(wardname)
JOIN unit u ON u.name = 'Unit 1';


-- 10. Room
INSERT INTO room (name, wardid, addedby, updatedby)
SELECT r.roomname, w.wardid, 1, 1
FROM (
    VALUES
    ('Room 1','Special Ward'),
    ('Room 2','Special Ward'),
    ('Room 3','Special Ward'),
    ('Room 4','Special Ward'),
    ('Room 5','Special Ward'),
    ('Room 6','Special Ward'),
    ('Room 7','Special Ward'),
    ('Room 8','Semi Special ward'),
    ('Room 9','Semi Special ward'),
    ('Room 10','Semi Special ward'),
    ('Room 11','Geneal Ward II'),
    ('Room 12','Geneal Ward II'),
    ('Room 13','Geneal Ward II')
) r(roomname, wardname)
JOIN ward w ON w.name = r.wardname;

-- 11. Beds (65 total)
DO $$
DECLARE
    i INT := 1;
    v_wardid INT;
BEGIN
    SELECT wardid INTO v_wardid FROM ward WHERE name = 'Geneal Ward';

    WHILE i <= 20 LOOP
        INSERT INTO bed (name, wardid, roomid, addedby, updatedby)
        VALUES ('Bed-' || i, v_wardid, NULL, 1, 1);
        i := i + 1;
    END LOOP;
END $$;
DO $$
DECLARE
    i INT := 1;
    v_wardid INT;
BEGIN
    SELECT wardid INTO v_wardid FROM ward WHERE name = 'Male Ward';

    WHILE i <= 20 LOOP
        INSERT INTO bed (name, wardid, roomid, addedby, updatedby)
        VALUES ('Bed-' || i, v_wardid, NULL, 1, 1);
        i := i + 1;
    END LOOP;
END $$;
DO $$
DECLARE
    i INT := 1;
    v_roomid INT;
BEGIN
    SELECT roomid INTO v_roomid FROM room WHERE name = 'Room 1';

    WHILE i <= 5 LOOP
        INSERT INTO bed (name, wardid, roomid, addedby, updatedby)
        VALUES ('Bed-' || i, NULL, v_roomid, 1, 1);
        i := i + 1;
    END LOOP;
END $$;
DO $$
DECLARE
    i INT := 1;
    v_roomid INT;
BEGIN
    SELECT roomid INTO v_roomid FROM room WHERE name = 'Room 2';

    WHILE i <= 5 LOOP
        INSERT INTO bed (name, wardid, roomid, addedby, updatedby)
        VALUES ('Bed-' || i, NULL, v_roomid, 1, 1);
        i := i + 1;
    END LOOP;
END $$;


-- 12. Country/State/City
-- INSERT INTO country (name, nationalityid, addedby, updatedby)
-- SELECT 'India', nationalityid, 1, 1
-- FROM nationality
-- WHERE name = 'Indian';
INSERT INTO state (name, countryid, addedby, updatedby)
SELECT 'maharashtra', countryid, 1, 1
FROM country
WHERE name = 'India';
INSERT INTO city (name, stateid, addedby, updatedby)
SELECT c.cityname, s.stateid, 1, 1
FROM (
    VALUES
    ('Pune'),
    ('Nagpur'),
    ('Mumbai'),
    ('Nasik'),
    ('washim')
) c(cityname)
JOIN state s ON s.name = 'maharashtra';


-- 13. Relation
INSERT INTO relation (name, addedby, updatedby) VALUES
('Self',1,1),('Spouse',1,1),('Child',1,1),('Friend',1,1),('Father',1,1),
('Mother',1,1),('Son',1,1),('Brother',1,1),('Sister',1,1),('Daughter',1,1),
('Sister In Law',1,1),('Brother In Law',1,1),('Grand Father',1,1),('Grand Mother',1,1);

-- 14. Staff (10 per non-clinical dept = ~100 staff)
DO $$ DECLARE dept_id INT; i INT; BEGIN
    FOR dept_id IN SELECT departmentid FROM department WHERE isclinical = false LOOP
        i := 1; WHILE i <= 10 LOOP
            INSERT INTO staff (departmentid, firstname, middlename, lastname, genderid, dateofbirth,
                contactno1, contactno2, email, addressline1, addressline2, pincode, cityid, addedby, updatedby)
            VALUES (dept_id, 'SFname-'||dept_id||'-'||i, 'SMname-'||dept_id||'-'||i, 'SLname-'||dept_id||'-'||i,
                (SELECT genderid FROM gender ORDER BY random() LIMIT 1),
                CURRENT_DATE - (10000 + floor(random()*235))::int, '1234567890','1234567890',
                'staff'||dept_id||i||'@gmail.com', 'Address Line 1','Address Line 2','123456',
                (SELECT cityid FROM city ORDER BY random() LIMIT 1), 1,1);
            i := i + 1;
        END LOOP;
    END LOOP;
END $$;

-- 15. Doctor (3 per clinical dept = ~36 doctors)
DO $$ DECLARE dept_id INT; i INT; BEGIN
    FOR dept_id IN SELECT departmentid FROM department WHERE isclinical = true LOOP
        i := 1; WHILE i <= 3 LOOP
            INSERT INTO doctor (departmentid, firstname, middlename, lastname, qualification, genderid, dateofbirth,
                contactno1, contactno2, email, addressline1, addressline2, pincode, cityid, addedby, updatedby)
            VALUES (dept_id, 'Dr-'||dept_id||'-'||i, 'M-'||i, 'L-'||i, 'MBBS, MD',
                (SELECT genderid FROM gender ORDER BY random() LIMIT 1),
                CURRENT_DATE - (10000 + floor(random()*235))::int, '1234567890','1234567890',
                'doctor'||dept_id||i||'@gmail.com', 'Address Line 1','Address Line 2','123456',
                (SELECT cityid FROM city ORDER BY random() LIMIT 1), 1,1);
            i := i + 1;
        END LOOP;
    END LOOP;
END $$;

-- 16. Services (OPD/IPD/Pathology/Radiology - 100+ services)
CREATE TEMP TABLE temp_service (
    id SERIAL PRIMARY KEY,
    servicename VARCHAR(200)
);

INSERT INTO temp_service (servicename) VALUES
('Consulatation'),
('Follow-up Consulatation'),
('Procedure'),
('Operation Charges'),
('Anesthesist Charges'),
('OT Charges');

DO $$
DECLARE
    i INT;
    srv_name VARCHAR(200);
    cat_id INT;
    v_opd INT;
BEGIN
    SELECT servicetypeid INTO v_opd
    FROM servicetype
    WHERE name = 'OPD';

    FOR i IN SELECT id FROM temp_service LOOP
        SELECT servicename INTO srv_name FROM temp_service WHERE id = i;

        FOR cat_id IN
            SELECT servicecategoryid
            FROM servicecategory
            WHERE name NOT IN ('Pathology','Radiology','Nursing')
        LOOP
            INSERT INTO service
            (name, servicecategoryid, rate, servicetypeid, addedby, updatedby)
            VALUES
            (srv_name, cat_id, 200, v_opd, 1, 1);
        END LOOP;
    END LOOP;
END $$;

TRUNCATE temp_service;

INSERT INTO temp_service (servicename) VALUES
('Bed Charges'),
('Nursing Charges'),
('IPD Visit Charges'),
('Operation Charges'),
('Anesthesist Charges'),
('OT Charges'),
('O2 Charges'),
('Procedure');

DO $$
DECLARE
    i INT;
    srv_name VARCHAR(200);
    cat_id INT;
    v_ipd_gen INT;
    v_ipd_sp INT;
BEGIN
    SELECT servicetypeid INTO v_ipd_gen FROM servicetype WHERE name = 'IPD-General';
    SELECT servicetypeid INTO v_ipd_sp  FROM servicetype WHERE name = 'IPD-Special';

    FOR i IN SELECT id FROM temp_service LOOP
        SELECT servicename INTO srv_name FROM temp_service WHERE id = i;

        FOR cat_id IN
            SELECT servicecategoryid
            FROM servicecategory
            WHERE name NOT IN ('Pathology','Radiology','Nursing')
        LOOP
            INSERT INTO service(Name,ServiceCategoryId,Rate,ServiceTypeId,CompanyId,AddedBy,UpdatedBy)
            VALUES (srv_name,cat_id,400,v_ipd_gen,NULL,1,1);

            INSERT INTO service(Name,ServiceCategoryId,Rate,ServiceTypeId,CompanyId,AddedBy,UpdatedBy)
            VALUES (srv_name,cat_id,600,v_ipd_sp,NULL,1,1) ;
        END LOOP;
    END LOOP;
END $$;

TRUNCATE temp_service;

INSERT INTO temp_service (servicename) VALUES
('SGOT (AST)'),('SGPT (ALT)'),('ALBUMIN'),('WIDAL'),
('BILLIRUBIN TOTAL'),('BILLIRUBIN DIRECT'),
('BLOOD GROUP'),('PERIPHERAL SMEAR'),
('RETICULOCYTE COUNT'),('TOTAL WBC COUNT'),('CBC');

DO $$
DECLARE
    i INT;
    srv_name VARCHAR(200);
    cat_id INT;
    v_opd INT;
    v_ipd_gen INT;
    v_ipd_sp INT;
BEGIN
    SELECT servicecategoryid INTO cat_id FROM servicecategory WHERE name = 'Pathology';
    SELECT servicetypeid INTO v_opd FROM servicetype WHERE name = 'OPD';
    SELECT servicetypeid INTO v_ipd_gen FROM servicetype WHERE name = 'IPD-General';
    SELECT servicetypeid INTO v_ipd_sp FROM servicetype WHERE name = 'IPD-Special';

    FOR i IN SELECT id FROM temp_service LOOP
        SELECT servicename INTO srv_name FROM temp_service WHERE id = i;

        INSERT INTO service (name,servicecategoryid,rate,servicetypeid,companyid,addedby,updatedby) VALUES
        (srv_name, cat_id, 300, v_opd, NULL,1,1);

        INSERT INTO service (name,servicecategoryid,rate,servicetypeid,companyid,addedby,updatedby) VALUES
        (srv_name, cat_id, 400, v_ipd_gen, NULL,1,1);

        INSERT INTO service (name,servicecategoryid,rate,servicetypeid,companyid,addedby,updatedby) VALUES
        (srv_name, cat_id, 500, v_ipd_sp, NULL,1,1);
    END LOOP;
END $$;

TRUNCATE temp_service;

INSERT INTO temp_service (servicename) VALUES
('X-RAY'),
('CT Scan'),
('Sonography');

DO $$
DECLARE
    i INT;
    srv_name VARCHAR(200);
    cat_id INT;
    v_opd INT;
    v_ipd_gen INT;
    v_ipd_sp INT;
BEGIN
    SELECT servicecategoryid INTO cat_id FROM servicecategory WHERE name = 'Radiology';
    SELECT servicetypeid INTO v_opd FROM servicetype WHERE name = 'OPD';
    SELECT servicetypeid INTO v_ipd_gen FROM servicetype WHERE name = 'IPD-General';
    SELECT servicetypeid INTO v_ipd_sp FROM servicetype WHERE name = 'IPD-Special';

    FOR i IN SELECT id FROM temp_service LOOP
        SELECT servicename INTO srv_name FROM temp_service WHERE id = i;

        INSERT INTO service (name,servicecategoryid,rate,servicetypeid,companyid,addedby,updatedby) VALUES
        (srv_name, cat_id, 300, v_opd, NULL,1,1);

        INSERT INTO service (name,servicecategoryid,rate,servicetypeid,companyid,addedby,updatedby) VALUES
        (srv_name, cat_id, 400, v_ipd_gen, NULL,1,1);

        INSERT INTO service (name,servicecategoryid,rate,servicetypeid,companyid,addedby,updatedby) VALUES
        (srv_name, cat_id, 500, v_ipd_sp, NULL,1,1);
    END LOOP;
END $$;



DO $$
DECLARE
    i INT := 1;
BEGIN
    WHILE i <= 50000 LOOP
        INSERT INTO patient
        (firstname, middlename, lastname, genderid, dateofbirth,
         contactno1, contactno2, email, addressline1, addressline2,
         pincode, cityid, addedby, updatedby)
        VALUES
        ('PFname_'||i, 'PMname_'||i, 'PLname_'||i,
         (SELECT genderid FROM gender ORDER BY random() LIMIT 1),
         CURRENT_DATE - (10000 + floor(random()*235))::int,
         '1234567890','1234567890',
         'pfname'||i||'@gmail.com',
         'Address Line 1','Address Line 2','123456',
         (SELECT cityid FROM city ORDER BY random() LIMIT 1),
         1,1);
        i := i + 1;
    END LOOP;
END $$;
DO $$
DECLARE
    i INT := 1;
BEGIN
    WHILE i <= 10000 LOOP
        INSERT INTO visit
        (patientcategoryid, patientid, doctorid, unitid,
         visitdate, opdnumber, addedby, updatedby)
        VALUES
        ((SELECT patientcategoryid FROM patientcategory ORDER BY random() LIMIT 1),
         (SELECT patientid FROM patient ORDER BY random() LIMIT 1),
         (SELECT doctorid FROM doctor ORDER BY random() LIMIT 1),
         (SELECT unitid FROM unit ORDER BY random() LIMIT 1),
         CURRENT_DATE - (300 + floor(random()*235))::int,
         i,1,1);
        i := i + 1;
    END LOOP;
END $$;

INSERT INTO charge
(visitid, admissionid, serviceid, rate, amount, quantity, addedby, updatedby)
SELECT
    visitid, NULL,
    (SELECT s.serviceid FROM service s JOIN servicetype st ON st.servicetypeid = s.servicetypeid WHERE st.name = 'OPD' ORDER BY random() LIMIT 1),
    0,0,1,1,1
FROM visit;
DO $$
DECLARE
    i INT := 1;
BEGIN
    WHILE i <= 1500 LOOP
        INSERT INTO charge
        (visitid, admissionid, serviceid, rate, amount, quantity, addedby, updatedby)
        VALUES
        ((SELECT visitid FROM visit ORDER BY random() LIMIT 1),
         NULL,
         (SELECT s.serviceid FROM service s JOIN servicetype st ON st.servicetypeid = s.servicetypeid WHERE st.name = 'OPD' ORDER BY random() LIMIT 1),
         0,0,1,1,1);
        i := i + 1;
    END LOOP;
END $$;
UPDATE charge c
SET rate = s.rate
FROM service s
WHERE c.serviceid = s.serviceid;

UPDATE charge
SET amount = rate * quantity;

UPDATE charge
SET concession = (amount * 10) / 100;
INSERT INTO bill
(visitid, admissionid, totalamount, concession, addedby, updatedby)
SELECT
    visitid, NULL,
    SUM(amount),
    SUM(concession),
    1,1
FROM charge
WHERE visitid IS NOT NULL
GROUP BY visitid;

UPDATE bill
SET finalbillamount = totalamount - concession;
DO $$
DECLARE
    i INT := 1;
BEGIN
    WHILE i <= 1000 LOOP
        INSERT INTO admission
        (patientcategoryid, patientid, unitid, doctorid,
         admissiondate, ipdnumber, relativename,
         relationid, bedid, companyid, ismlc, addedby, updatedby)
        VALUES
        ((SELECT patientcategoryid FROM patientcategory ORDER BY random() LIMIT 1),
         (SELECT patientid FROM patient ORDER BY random() LIMIT 1),
         (SELECT unitid FROM unit ORDER BY random() LIMIT 1),
         (SELECT doctorid FROM doctor ORDER BY random() LIMIT 1),
         CURRENT_DATE - (300 + floor(random()*235))::int,
         i,
         'R Name-'||i,
         (SELECT relationid FROM relation ORDER BY random() LIMIT 1),
         (SELECT bedid FROM bed ORDER BY random() LIMIT 1),
         (SELECT companyid FROM insurancecompany ORDER BY random() LIMIT 1),
         false,1,1);
        i := i + 1;
    END LOOP;
END $$;
INSERT INTO charge
(visitid, admissionid, serviceid, rate, amount, quantity, addedby, updatedby)
SELECT
    NULL, admissionid,
    (SELECT s.serviceid
	FROM service s
	JOIN servicetype st ON st.servicetypeid = s.servicetypeid
	WHERE st.name IN ('IPD-General','IPD-Special')
	ORDER BY random()
	LIMIT 1),
    0,0,1,1,1
FROM admission;

UPDATE charge c
SET rate = s.rate
FROM service s
WHERE c.serviceid = s.serviceid AND c.visitid IS NULL;

UPDATE charge
SET amount = rate * quantity
WHERE visitid IS NULL;

UPDATE charge
SET concession = (amount * 10) / 100
WHERE visitid IS NULL;
INSERT INTO bill
(visitid, admissionid, totalamount, concession, addedby, updatedby)
SELECT
    NULL, admissionid,
    SUM(amount),
    SUM(concession),
    1,1
FROM charge
WHERE admissionid IS NOT NULL
GROUP BY admissionid;

UPDATE bill
SET finalbillamount = totalamount - concession
WHERE visitid IS NULL;
INSERT INTO discharge
(admissionid, doctorid, dischargedate, addedby, updatedby)
SELECT
    admissionid,
    doctorid,
    admissiondate + ((10 + floor(random()*5)) * INTERVAL '1 day'),
    1,1
FROM admission;
DROP TABLE IF EXISTS temp_service;

